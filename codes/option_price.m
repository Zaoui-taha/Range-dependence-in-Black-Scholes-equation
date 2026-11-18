function V = option_price(S, E, T, r, sigma, H, t, option) 

    lambda_H = zeros(size(S));
    
    for index = 1:length(S)
        lambda_H(index) = 2 * H * t(index)^(2 * H - 1);
    end
    
    d1 = zeros(size(S));
    d2 = zeros(size(S));
    
    for index = 1:length(S)
        d1(index) = (log(S(index) / E) + (r + 0.5 * lambda_H(index) * sigma^2) * (T - t(index))) / sigma / sqrt(lambda_H(index) * (T - t(index)));
        d2(index) = (log(S(index) / E) + (r - 0.5 * lambda_H(index) * sigma^2) * (T - t(index))) / sigma / sqrt(lambda_H(index) * (T - t(index)));
    end
    
    % Analytical value :
    V = zeros(size(S));
    
    % call option :
    if option == 1
        for index = 1:length(S)
            V(index) = S(index) * normcdf(d1(index)) - E * exp(-r * (T -t(index))) * normcdf(d2(index));
        end
    end
    
    % put option :
    if option == 0
        for index = 1:length(S)
            V(index) = E * exp(-r * (T - t(index))) * normcdf(- d2(index)) - S(index) * normcdf(- d1(index));
        end
    end

end