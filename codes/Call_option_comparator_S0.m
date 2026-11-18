clc;
clear all;

% error comparison in case H = 0.5 call option :

mu = 0.05;
sigma = 0.1;
r = 0.1;
E = 100; 
t0 = 0.001;
T = 0.1;
N = 1000;
t = linspace(t0, T, N);
dt = t(2) - t(1);
x = linspace(0, 2, 60);
B = fbm_simulator(0.5, N, dt);

S0_values = [160, 170, 180];

for s = S0_values

    % Stock price in standard case :
    S = zeros(N, 1);
    B = fbm_simulator(0.5, N, dt);
    
    for index = 1:N
        S(index) = s*exp((mu - sigma^2/2)*t(index) + sigma*B(index));
    end
    
    d1 = zeros(size(S));
    d2 = zeros(size(S));
    
    for index = 1:length(S)
        d1(index) = (log(S(index)/E) + (r + sigma^2/2) * (T - t(index))) / sigma / sqrt(T - t(index));
        d2(index) = (log(S(index)/E) + (r - sigma^2/2) * (T - t(index))) / sigma / sqrt(T - t(index));
    end
    
    % Analytical value :
    Vana = zeros(size(S));
    for index = 1:length(S)
        % call option :
        Vana(index) = S(index) * normcdf(d1(index)) - E * exp(-r * (T-t(index))) * normcdf(d2(index));
    end
    
    % Simulated option value :
    [~, ~, Vsimu] = fbm_solver_pde(mu, sigma, B, r, 0.5, s, E, t0, T, N, x, 1);
    
    % Comparing solution and evaluating error :
    error = norm(Vana - Vsimu, "inf");
    disp(error);
end