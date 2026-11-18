%% Data:
alpha = 1.5;
H = alpha/2;
T = 0.01;
N = 100;
dt = T/N;
K = 100;
r = 0.1;
mu = 0.2;
sigma = 0.5 ;
t = linspace(0,T,N);
%% Simulation of the FBM
V = normrnd(0, 1, [N, 1]); % gaussian(0, I)
C = zeros(N); % autocovariance matrix
for i = 1:N
    for j = 1:N
        C(i, j) = c(i, j, H, dt);
    end
end
L = chol(C, 'lower');
W = L*V;
figure
plot(t, W)
xlabel('t');
ylabel('W_t');
title(['Fractional Brownian Noise with hurst exponant H = ', num2str(H)])
%% Simulaion of the real solution
S_real = zeros(size(t));
S_real(N) = K ;
for i =1:N-1
    S_real(i) = K/exp(r*(T^alpha - t(i)^alpha)/gamma(alpha) + mu*(T - t(i)) - (T-t(i))*(sigma^2)/2/(gamma(1+alpha)^2) + sigma*(W(N)-W(i))/gamma(1+alpha));
end
%% Approached solution :
S_simu = zeros(size(t));
S_simu(N) = K ;
for k = N-1:-1:1
    I1 = 0 ;
    for j = k+1:N
       I1 = I1 + r*S_simu(j)*dt*(t(j) - t(k))^(alpha-1) ;
    end
    I2 = 0 ;
    for j = k+1:N
       I2 = I2 + mu*S_simu(j)*dt ;
    end
    I3 = 0 ;
    for j = k+1:N
       I3 = I3 + sigma*S_simu(j)*(W(j) - W(j-1)) ;
    end
    S_simu(k) = K - I1/gamma(alpha) - I2 - I3/gamma(1+alpha) ;  
end
%% Plot
figure
plot(t, S_real)
hold on 
plot(t, S_simu, '-*')
xlabel('t');
ylabel('S_{simu}, S_{real}');
legend('Real solution', 'Simulation')
title('Real solution VS Simulation');
hold off
%%
function a = c(i, j, H, dt)
    k = i-j ;
    r = 2*H ;
    a = (dt^r)*(abs(k-1)^r + abs(k+1)^r - 2*abs(k)^r)/2 ;
end