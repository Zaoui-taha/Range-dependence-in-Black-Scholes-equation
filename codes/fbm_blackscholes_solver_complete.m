clc ;
clear all ;

% Data :
mu = 0.05;
sigma = 0.1;
r = 0.1;
option = 1;
S0 = 120;
E = 100; 

% time data :
t0 = 1e-10;
T = 1;
n_times = 500;
t = linspace(t0, T, n_times);
dt = t(2) - t(1);

% space data :
X = 2;
M = 100;
x = linspace(0, X, M);
%% 
% Analytical solution :

% FBM simulation :
H = 0.3;
W = fbm_simulator(H, n_times, dt);

ax = gca;
ax.XAxis.FontSize = 20; % bigger x-axis numbers
ax.YAxis.FontSize = 20; % smaller y-axis numbers

Y = sigma .* W;
figure
plot(t, Y, 'b');
xlabel('Time', 'FontSize', 18)
ylabel('Option Value', 'FontSize', 18)

% Simulation of stock price :
S = stock_price(S0, mu, sigma, t, H, W);

% Simulation of option price :
V_ana = option_price(S, E, T, r, sigma, H, t, option);
%%
% Simulated solution :
[u_sol, V_sol] = fbm_solver_pde(mu, sigma, W, r, H, S0, E, t0, T, n_times, x, option);
%%
% Plot solution of the PDE :
figure
surf(x, t, u_sol)
colormap("parula")          
colorbar       
if option == 1
    xlabel('x'), ylabel('t'), zlabel('u_{call}(x,t)')
else
    xlabel('x'), ylabel('t'), zlabel('u_{put}(x,t)')
end
%%
% plot option price solution and compare with theory :
if option == 1
    figure
    plot(t, V_sol, 'o-', 'MarkerFaceColor', 'r', 'MarkerSize', 3);
    hold on
    plot(t, V_ana, 'b');
    hold off
    xlabel('Time', 'FontSize', 18)
    ylabel('Option Value', 'FontSize', 18)
    legend('Analytical Value', 'Simulated Value', 'FontSize', 20)
    error = norm((V_ana - V_sol) ./ V_ana, "inf") * 100 ;
    disp(error);
else
    figure
    plot(t, V_sol, 'o-', 'MarkerFaceColor', 'r', 'MarkerSize', 3);
    hold on
    plot(t, V_ana, 'b');
    hold off
    xlabel('Time', 'FontSize', 18)
    ylabel('Option Value', 'FontSize', 18)
    legend('Analytical Value', 'Simulated Value', 'FontSize', 20)
    error = norm((V_ana - V_sol) ./ V_ana, "inf") * 100 ; 
    disp(error);
end
%%
% Different plots of u :
W1 = fbm_simulator(0.2, n_times, dt);
[u_1, ~] = fbm_solver_pde(mu, sigma, W1, r, 0.2, S0, E, t0, T, n_times, x, option);

W2 = fbm_simulator(0.4, n_times, dt);
[u_2, ~] = fbm_solver_pde(mu, sigma, W2, r, 0.4, S0, E, t0, T, n_times, x, option);

W3 = fbm_simulator(0.7, n_times, dt);
[u_3, ~] = fbm_solver_pde(mu, sigma, W3, r, 0.7, S0, E, t0, T, n_times, x, option);

W4 = fbm_simulator(0.8, n_times, dt);
[u_4, ~] = fbm_solver_pde(mu, sigma, W4, r, 0.8, S0, E, t0, T, n_times, x, option);

figure('Position',[100 100 800 600]);

subplot(2,2,1);   
surf(x, t, u_1);
title('H = 0.2', 'FontSize', 20);
xlabel('x', 'FontSize', 18)
ylabel('t', 'FontSize', 18)
zlabel('u(x,t)', 'FontSize', 18)

subplot(2,2,2);   
surf(x, t, u_2);
title('H = 0.4', 'FontSize', 20);
xlabel('x', 'FontSize', 18)
ylabel('t', 'FontSize', 18)
zlabel('u(x,t)', 'FontSize', 18)

subplot(2,2,3);   
surf(x, t, u_3);
title('H = 0.7', 'FontSize', 20);
xlabel('x', 'FontSize', 18)
ylabel('t', 'FontSize', 18)
zlabel('u(x,t)', 'FontSize', 18)

subplot(2,2,4);  
surf(x, t, u_4);
title('H = 0.8', 'FontSize', 20);
xlabel('x', 'FontSize', 18)
ylabel('t', 'FontSize', 18)
zlabel('u(x,t)', 'FontSize', 18)