% comparing errors in LSMC method depending on the number of iterations N :
clc;
clear all;

% time discretization :
t0 = 0;
T = 0.1;
n_time = 10;
t = linspace(t0, T, n_time);
dt = t(2) - t(1);

% space discretization :
X = 2;
M = 100;
x = linspace(0, X, M);

% Data :
S0 = 110;
E = 100;
option = 1;
mu = 0.05;
sigma = 0.1;
r = 0.1;
H = 0.7;

% fbm employed :
W = fbm_simulator(H, n_time, dt); 

% solution using BPDE :
S = stock_price(S0, mu, sigma, t, H,  W);
Vana = option_price(S, E, T, r, sigma, H, t, option);

% list of values of N :
N_values = [10, 50, 100, 500, 1000, 5000, 10000, 50000, 100000]; 
error_values = zeros(length(N_values), 1); 

for i = 1:length(N_values)
    [~, Vsde] = sde_solver(t0, T, n_time, X, M, W, S0, E, mu, sigma, r, H, N_values(i), option);
    error = norm(Vsde - Vana, 'inf');
    error_values(i) = error;
end

% plot
figure
plot(N_values, error_values, 'o-', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'LineWidth', 2)
set(gca, 'XScale', 'log')  
xlabel('N', 'FontSize', 20)
ylabel('error', 'FontSize', 20)
title('Convergence of LSMC method', 'FontSize', 20)
grid on