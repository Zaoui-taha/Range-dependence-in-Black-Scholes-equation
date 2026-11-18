function [U, V] = sde_solver(t0, T, n_time, X, M, W, S0, E, mu, sigma, r, H, N, option)

    U = zeros(n_time, M);
    x = linspace(0, X, M); % Spatial grid
    t = linspace(t0, T, n_time); % Time grid
    dt = t(2) - t(1);
    b = r - mu;

    % Precompute constant drift and diffusion terms for efficiency
    drift = b + H * sigma^2 * t.^(2*H - 1);
    diffusion = sigma * sqrt(2 * H) * t.^(H - 0.5);

    % simulation for each value of xk :
    for k = 1:M

        % Final value condition :
        if option ==1 
            U(n_time, k) = psi_call(x(k));
        else
            U(n_time, k) = psi_put(x(k)); 
        end

        % for each value 
        for i = n_time-1 : -1 : 1
            % Simulate paths of the process P^(ti, xk)
            P = simu_P(i, k);

            % Initialize Y
            Y = zeros(N, n_time);

            if option == 1
                Y(:, n_time) = psi_call(P(:, n_time));
            else 
                Y(:, n_time) = psi_put(P(:, n_time));
            end

            % Backward simulation of Y
            for j = n_time-1 : -1 : 1
                Y_target = Y(:, j + 1) .* (1 - r * dt);
                Y(:, j) = cond_exp(Y_target, P(:, j));
            end

            % Approximate solution at (ti, xk)
            U(i, k) = mean(Y(:, i));
        end
    end

    % simulation of the stock price using the fractional Brownian motion :
    Z = sigma .* W;

    % option value simulation :
    V = zeros(n_time, 1);
    for index = 1:n_time
        V(index) = interpoler(exp(Z(index)), index, x, U);
    end
    
    function y = psi_call(x)
        lambda = S0 * exp(mu * T - 0.5 * sigma^2 * T^(2 * H));
        y = max(lambda * x - E, 0);
    end
    
    function y = psi_put(x)
        lambda = S0 * exp(mu * T - 0.5 * sigma^2 * T^(2 * H));
        y = max(E - lambda * x, 0);
    end

    % Simulator of P^(ti, xk) 
    function P = simu_P(i, k)
        P = zeros(N, n_time);
        P(:, 1:i) = x(k);
        for p = i:n_time-1
            dW = sqrt(dt) .* randn(N, 1);
            P(:, p + 1) = P(:, p) .* (1 + drift(p) * dt + diffusion(p) .* dW);
        end
    end


    function E = cond_exp(Y, X)
        % Use apolynomial basis
        A = [ones(N,1), X, X.^2];
        beta = pinv(A) * Y; % Least-squares solution
        E = A * beta;
    end

end