function [u_final, V_final] = fbm_solver_pde(mu, sigma, W, r, H, S0, E, t0, T, n_times, x, option)

    % Data :
    b = r - mu;
    t = linspace(t0, T, n_times) ;
    
    % Resolution of Black Scholes in case of a FBM process :
    % Using function pdepe : 
    m = 0; 
    tau = T - flip(t);  % time reverse
    
    % Transformed process :
    Y = zeros(size(W));

    for index = 1:length(Y)
        Y(index) = sigma * W(index);
    end
    
    % Resolution of the equation and simulation :
    
    % Call option :
    if option == 1

        % Numerical solution :
        sol_call = pdepe(m, @pdefun, @icfun_call, @bcfun_call, x, tau);

        % reverse time dimension : 
        u_final = flip(sol_call, 1);   

        % Plot option price using Y_t and time t :
        V_call = zeros(n_times, 1);

        for index = 1:n_times
            V_call(index) = interpoler(exp(Y(index)), index, x, u_final);
        end

        V_final = V_call;
    end
    
    % Put option ====
    
    if option == 0
    
        % Numerical solution for put option :
        sol_put = pdepe(m, @pdefun, @icfun_put, @bcfun_put, x, tau);
        
        % reverse time dimension :   
        u_final = flip(sol_put, 1); 
        
        % Plot option price using Y_t and time t :
        V_put = zeros(n_times, 1);
        
        for index = 1:n_times
            V_put(index) = interpoler(exp(Y(index)), index, x, u_final);
        end   
    
        V_final = V_put;
    
    end
    
    % --- Nested function definitions ---
        
        % PDE definition :
        function [c, f, s] = pdefun(x, t, u, dudx)
            c = 1;
            f = sigma^2 * H * (T - t)^(2 * H - 1) * x^2 * dudx;
            s = (b - sigma^2 * H * (T - t)^(2 * H - 1)) * x * dudx - r * u;
        end
        
        % Initial condition for both cases :

        function u0 = icfun_call(x)
            u0 = max(S0 * exp(mu * T - 0.5 * sigma^2 * T^(2 * H)) * x - E, 0);
        end
    
        function u0 = icfun_put(x)
            u0 = max(E - S0 * exp(mu * T - 0.5 * sigma^2 * T^(2 * H)) * x, 0);
        end
    
        % Boundary conditions call option :
        function [pl, ql, pr, qr] = bcfun_call(~, ul, xr, ur, t)
            pl = ul;  ql = 0;
            pr = ur + E - S0 * exp(mu * (T - t) - 0.5 * sigma^2 * (T - t)^(2 * H)) * xr;  qr = 0;
        end
    
        % Boundary conditions put option :
        function[pl, ql, pr, qr] = bcfun_put(~, ul, ~, ur, t)
            pl = ul - E * exp(-r * t);
            ql = 0;
            pr = ur ;  qr = 0;
        end

end