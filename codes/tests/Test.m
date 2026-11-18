%Taha zaoui : Stochastic optimal control :

% Matlab code :

% ======== Test of adding a white noise to a signal :=============
x = 0:0.05:10;

y = sin(x) + 1;
figure
plot(x, y)
hold on

z = awgn(y,25,'measured');
plot(x, z)
hold off
%%
% ======= Simulation of an Ito process : the price S :============
mu = 0.05;
sigma = 0.2;

T = 1;
N = 1000;
dt = T/N;

W = sqrt(dt)*randn(1,N);
S = zeros(1,N);
S(1) = 95; % initial price
for i =1:N-1
    S(i+1) = S(i) + mu*S(i)*dt + sigma*S(i)*(W(i+1)-W(i));
end

t = linspace(0, T, N) ; 
figure
plot(t, S)
%%
% ====== Observing the parameters effect ==========

mu = 0.25;
sigma_values = [0.1 0.25 0.5];

T = 5;
N = 5000;
dt = T/N;
t = linspace(0, T, N) ; 

figure;

for k = 1:length(sigma_values)
    
    sigma = sigma_values(k);
    W = sqrt(dt)*randn(1,N);
    S = zeros(1,N);
    S(1) = 90; % initial price
    
    for i =1:N-1
        S(i+1) = S(i) + mu*S(i)*dt + sigma*S(i)*(W(i+1)-W(i));
    end
    
    plot(t, S)
    hold on
    
end

plot(t, S(1)*exp(mu*t))

hold off
legend('\sigma = 0.1','\sigma = 0.25', '\sigma = 0.5','mean')
%%
% ======== Simulation of B-S solution ===========
E = 100; % exercice price
r = 0.05;  
f = @(x) exp(-x.^2/2)/(sqrt(2*pi));
phi = @(x) integral(f,-Inf, x);

d_1 = (log(S/E)+(r + sigma^2/2)*(T - t))/sigma/sqrt(T - t);
d_2 = (log(S/E)+(r - sigma^2/2)*(T - t))/sigma/sqrt(T - t);

% call option :
V_call = S*phi(d_1) - E*exp(-r*(T-t))*phi(d_2);

% put option :
V_put = E*exp(-r*(T-t))*phi(-d_2) - S*phi(-d_1);

figure
plot(t, V_call, 'r')
hold on 
plot(t, V_put, 'b')
hold off






