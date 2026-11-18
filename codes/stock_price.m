function S = stock_price(S0, mu, sigma, t, H,  W)

    S = zeros(size(W));
    
    for index = 1:length(W)
        S(index) = S0 * exp(mu * t(index) - 0.5 * sigma^2 * t(index)^(2 * H)  + sigma * W(index));
    end

end