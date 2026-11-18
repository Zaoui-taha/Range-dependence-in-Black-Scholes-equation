% Comparator of models for different values of H :

H_list = [0.4, 0.5, 0.7, 0.9];
figure
for h = H_list
    W = fbm_simulator(h, N, dt);
    [~, ~, V] = fbm_solver_pde(mu, sigma, W, r, h, S0, E, t0, T, N, x, option);
    plot(timeseries, V, 'DisplayName', ['Option price for H = ', num2str(h)]);
    hold on
end
hold off
xlabel('t')
ylabel('Option Price')
title('Effect of Hurst Exponent H on Option Price')
legend('show')