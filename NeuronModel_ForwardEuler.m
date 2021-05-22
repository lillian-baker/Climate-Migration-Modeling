%Forward Euler of Motion with Drift
%clear all

%define time vector
dt = 0.005;
t_final = 1;
t = dt:dt:t_final;

%initialize v vector
v = zeros(size(t));

%Define initial condition
v_0 = 0;
v(1) = v_0;

%for sigma_w = [0.1 1 5]
%Forward Euler Loop
%Creates the data for the probability that one individual will migrate
mu_w = 2;
sigma_w = 0.1; %uncertainty - the factors too complicated to express (random
%events)
trials = 100000;
t_stop = zeros(trials,1);

%Build probability function
for r =1:trials
    v = zeros(size(t));
for i = 1:length(t)-1
v(i+1) = v(i) + dt*mu_w + sigma_w*sqrt(dt)*randn; %dw/dt chooses a random number and scales by sqrt(dt)
if v(i+1) > 1 %Crosses threshold?
    t_stop(r) = t(i+1);
    break
end
end
end
%Plots a probability distribution
figure
hold on
%hist(data, either number of bins OR bin centers)
[counts, center] = hist(t_stop, t);
counts = counts/sum(counts); %Normalize to sum to 1
plot(center, counts, 'o')

%Equation 42
theta = 1;
f_theta = (theta./sqrt(2*pi*(sigma_w^2).*t.^3)).*exp((-1.*((theta-mu_w.*t).^2))./(2*(sigma_w^2).*t));
f_theta = f_theta/sum(f_theta);


plot(t,f_theta, 'g-')
title(['Distribution of Time of Migration for \mu =', num2str(mu_w), ', \sigma =', num2str(sigma_w)])
xlabel('Time of Migration')
ylabel('Normalized Frequency')
xlim([0 1])
ylim([0 (max(f_theta)+0.01)])
filename = ['NEW_ProbDist_sigma_', num2str(sigma_w),'_trials_', num2str(trials), '.png'];
%saveas(gcf, filename)

figure
plot(t, v, '-')
hold on
plot (t, mu_w*t, '--') %Migration with no uncertainty
title(['Individual''s Decision to Migrate for \mu =', num2str(mu_w), ', \sigma = ', num2str(sigma_w)])
    xlabel('Time')
    ylabel('Individual''s Migration Decision Factor')
    ylim([0 1.1])
    xlim([0 1])
filename = ['NEW_ExactSolution_sigma_', num2str(sigma_w),'_trials_', num2str(trials), '.png'];
%saveas(gcf, filename)
%end

