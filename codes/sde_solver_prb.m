% solving the problem through SDE and LSMC :
clc;
clear all;

% time discretization :
t0 = 0;
T = 0.1;
n_time = 50;
t = linspace(t0, T, n_time);
dt = t(2) - t(1);

% space discretization :
X = 2;
M = 200;
x = linspace(0, X, M);

% Data :
option = 1;
S0 = 110;
E = 100;
mu = 0.05;
sigma = 0.1;
r = 0.1;
H = 0.7;

% Monte-Carlo simulation :
N = 20000; 

% fbm employed :
W = fbm_simulator(H, n_time, dt); 

tic ;

% solving through LSMC :
[~, Vsde] = sde_solver(t0, T, n_time, X, M, W, S0, E, mu, sigma, r, H, N, option);

S = stock_price(S0, mu, sigma, t, H,  W);
Vana = option_price(S, E, T, r, sigma, H, t, option);

elapsed_time = toc; % stop timer and store elapsed time
disp(['Execution time: ', num2str(elapsed_time), ' seconds']);

figure
plot(t, Vana, 'b');
hold on
plot(t, Vsde, 'o-', 'MarkerFaceColor', 'b', 'MarkerSize', 3)
legend('PDE solver', 'LSMC solver', 'FontSize', 14)
xlabel('Time', 'FontSize', 18)
ylabel('Option Value', 'FontSize', 18)
legend('PDE method', 'SDE method', 'FontSize', 20)
title(['Comparison of both methods for H = ', num2str(H)], 'FontSize', 20)

error = norm(Vsde - Vana, "inf") ;
disp(error);

rel_error = norm((Vsde - Vana) ./ Vana, "inf") *  100 ;
disp(rel_error);