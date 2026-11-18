clc;
clear all;

% time discretization :
t0 = 1e-2;
T = 1;
n_times = 200;
t = linspace(t0, T, n_times);
dt = t(2) - t(1);

% space discretization :
X = 2;
M = 200;
x = linspace(0, X, M);

% Data :
S0 = 80;
E = 100;
option = 0;
mu = 0.05;
sigma = 0.08;
r = 0.1;

% fbm simulator :
H = 0.3;
W = fbm_simulator(H, n_times, dt);

% analytical solution :
S = stock_price(S0, mu, sigma, t, H,  W);
Vana = option_price(S, E, T, r, sigma, H, t, option);

% Simulated option value :
[~, Vsimu] = fbm_solver_pde(mu, sigma, W, r, H, S0, E, t0, T, n_times, x, option);

% Prepare for plotting by ensuring the figure is ready
figure
plot(t, Vana, '-', 'MarkerFaceColor', 'b', 'MarkerSize', 3)
hold on
plot(t, Vsimu, 'o-', 'MarkerFaceColor', 'r', 'MarkerSize', 2)
hold off
xlabel('Time', 'FontSize', 18)
ylabel('Option Value', 'FontSize', 18)
legend('Analytical Value', 'Simulated Value', 'FontSize', 20)
title(['Comparison of Analytical and Simulated Option Values for H = ', num2str(H)], 'FontSize', 20)


% error :
error = norm(Vana - Vsimu, "inf");
disp(error)

rel_error = norm((Vana - Vsimu) ./ Vana, "inf") * 100;
disp(rel_error)

