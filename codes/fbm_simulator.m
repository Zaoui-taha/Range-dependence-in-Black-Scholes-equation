function W = fbm_simulator(H, n_times, dt)

    % Simulation of the fbm with Hurst exponent H :
    U = normrnd(0, 1, [n_times, 1]); % gaussian(0, I)

    C = zeros(n_times); % autocovariance matrix
    for i = 1:n_times
        for j = 1:n_times
            C(i, j) = cov_fgm(i, j, H, dt);
        end
    end

    % Cholesky matrix :
    L = chol(C, 'lower');

    % gaussian noise :
    X = L*U;

    % FBM by accumulation :
    W = zeros(n_times, 1);

    for i = 1:(n_times-1)
        W(i+1) = W(i) + X(i);
    end

    % Covariance function for FBM :
    function a = cov_fgm(i, j, H, dt)
        k = i - j;
        r = 2 * H;
        a = (dt^r) * (abs(k - 1)^r + abs(k + 1)^r - 2 * abs(k)^r) / 2;
    end
end
