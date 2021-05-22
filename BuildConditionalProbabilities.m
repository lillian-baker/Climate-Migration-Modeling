%Run the model with an age cutoff (age_stop) at every year between 15 and 80
%At age_stop, record the p(t) decision factor for anyone who has not yet
%migrated
%Build a coniditonal probability distribution for every age_stop

tic
%Probability p(age_stop) = p, given the person hasn't migrated
for age_stop = 15:1:80

t0 = 15;
dt = .005;
t_final = age_stop; 
t = t0:dt:t_final; %time vector

%Initialize p vector
p2 = zeros(size(t));

%Define initial conditions
p_0 = 0.3;

%Define equilibrium
p_eq = 0.55;

%Define parameters
mu = 1.95;
sigma = 0.8;

trials_cond = 10000; %Symbolizes 10,000 people who have not migrated at age_stop
%t_stop_cond = zeros(trials_cond, 1);

%Run the model and record decision factor at age_stop
r = 1;  %Counter
frequency_age_stop = zeros(trials_cond, 1); %Vector to record decision factor of each person (each trial)

tic
while r < trials_cond + 1
    p2 = zeros(size(t));
    p2(1) = p_0;
    for i = 1:length(t)-1
        p2(i+1) = p2(i) + dt*mu*p2(i)*(p_eq-p2(i))+sqrt(dt)*sigma*(p2(i)^2)*randn; %Adding dp to each p(i) to find p(i+1)
        if p2(i+1) > 1 %First passage time
        %t_stop_cond(r) = t(i+1);
            break    %Stops the model once someone has migrated
        end

    end

    %Check if the person migrated
    if i < length(t)-1 %Didn't finish the loop because the person migrated
        r = r;
    else %the person reached age_stop without migrating, so count this run: record decision factor at age_stop
        frequency_age_stop(r) = p2(end);
        r = r+1;
    end
end
toc


% %hist(data, either number of bins OR bin centers)
[counts_cond, center_cond] = hist(frequency_age_stop, linspace(0.015,1.005,100)); %try with different bin numbers
counts_cond = counts_cond/sum(counts_cond); %Normalize to sum to 1

load Conditional_Distribution_at_age_stop_35.mat
plot(center_cond, counts_cond, 'o')
title(['Distribution of Decision Factor at Age ', num2str(age_stop)])
xlabel(['Decision Factor (p) at Age ', num2str(age_stop)])
ylabel('Normalized Frequency')
xlim([0 1])
ylim([0 max(counts_cond)+0.01])

 

%Saving the data for each age_stop run
file = strcat('Conditional_Distribution_at_age_stop_', num2str(age_stop), '.mat');
save(file, 'counts_cond', 'center_cond', 'frequency_age_stop', 'age_stop') 

age_stop

end
toc
