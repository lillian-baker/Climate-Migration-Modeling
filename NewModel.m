%New first passage model

%Define time vector
t0 = 15;
dt = .005;
t_final = 100; %t0 ~ 15 y.o.
t = t0:dt:t_final;

%Initialize p vector
p = zeros(size(t));

%Define initial conditions
p_0 = 0.3;
 %should p_0 be 0.5?
 
%Equilibrium 
p_eq = 0.55;

mu = 1.95;
tic
for sigma = .8

trials = 100000;
t_stop = zeros(trials, 1);

%Build the function by Euler's Method
for r =1:trials
    p = zeros(size(t));
    p(1) = p_0;
for i = 1:length(t)-1
p(i+1) = p(i) + dt*mu*p(i)*(p_eq-p(i))+sqrt(dt)*sigma*(p(i)^2)*randn; %Adding dp to each p(i) to find p(i+1)
if p(i+1) > 1 %First passage time
    t_stop(r) = t(i+1);
    break
end

end
end
toc


%Plots a probability distribution
figure
hold on
%hist(data, either number of bins OR bin centers)
[counts, center] = hist(t_stop, linspace(t0,t_final, 100)); %try with different bin numbers
counts = counts/sum(counts); %Normalize to sum to 1
plot(center, counts, 'o')


title(['Distribution of Age of Migration for \mu =', num2str(mu), ', \sigma =', num2str(sigma)])
xlabel('Age of Migration')
ylabel('Normalized Frequency')
xlim([t0 100])
ylim([0 max(counts)+.01])
%filename = ['NEW_ProbDist_sigma_', num2str(sigma),'_trials_', num2str(trials), '.png'];
%saveas(gcf, filename)
%end


figure
plot(t, p, '-')
hold on
title(['Individual''s Decision to Migrate for \mu =', num2str(mu), ', \sigma = ', num2str(sigma)])
    xlabel('Age')
    ylabel('Individual''s Migration Decision Factor')
    xlim([t0 100])
    ylim([0 1.1])
%filename = ['Model_2_mu_', num2str(mu), '_sigma_', num2str(sigma),'.png'];
%saveas(gcf, filename)
end