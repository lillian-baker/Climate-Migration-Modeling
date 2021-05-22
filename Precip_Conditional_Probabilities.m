%Run the model with an age cutoff (age_stop) at every year between 15 and 80
%At age_stop, record the p(t) decision factor for anyone who has not yet
%migrated
%Build a coniditonal probability distribution for every age_stop

%Testing the addition of precip for Community 30
load Precip_anomaly_total.mat


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

%Define equilibrium value based on precip
for i = (1980-1899):1:(2020-1902)  %adjust time scale to precip data set
    if abs(precip_anomaly_total(i))> 1
        sig_fxn = 1;
    else
        sig_fxn = 0;
    end
    %Shift to start index at 1, corresponds to 1980
    p_eq(i-80) = 0.55+sig_fxn*abs(precip_anomaly_total(i)/10);    %0.55+sig(precip_i(t))*abs(precip_i(t)
end

%Define parameters
mu = 1.95;
sigma = 0.8;

trials_cond = 10000; %Symbolizes 10,000 people who have not migrated at age_stop
%t_stop_cond = zeros(trials_cond, 1);

%Run the model and record decision factor at age_stop
r = 1;  %Counter
precipfrequency_age_stop = zeros(trials_cond, 1); %Vector to record decision factor of each person (each trial)

tic
while r < trials_cond + 1
    p2 = zeros(size(t));
    p2(1) = p_0;
    for i = 1:length(t)-1
        if i/200 > 38
            eq_index = 38;  %will use final eq value for all ages past precip time available
        else
            eq_index = ceil(i/200); %treats everyone as if they were 15 in 1980
        end
        p2(i+1) = p2(i) + dt*mu*p2(i)*(p_eq(eq_index)-p2(i))+sqrt(dt)*sigma*(p2(i)^2)*randn; %Adding dp to each p(i) to find p(i+1)
        if p2(i+1) > 1 %First passage time
        %t_stop_cond(r) = t(i+1);
            break    %Stops the model once someone has migrated
        end

    end

    %Check if the person migrated
    if i < length(t)-1 %Didn't finish the loop because the person migrated
        r = r;
    else %the person reached age_stop, so count this run: record decision factor at age_stop
        precip_frequency_age_stop(r) = p2(end);
        r = r+1;
    end
end
toc


% %hist(data, either number of bins OR bin centers)
[precip_counts_cond, precip_center_cond] = hist(precip_frequency_age_stop, linspace(0.015,1.005,100)); %try with different bin numbers
precip_counts_cond = precip_counts_cond/sum(precip_counts_cond); %Normalize to sum to 1

%Use to plot after loading specific conditional distribution
% plot(precip_center_cond, precip_counts_cond, 'o')
% title(['Distribution of Decision Factor at Age ', num2str(age_stop)])
% xlabel(['Decision Factor (p) at Age ', num2str(age_stop)])
% ylabel('Normalized Frequency')
% xlim([0 1])
% ylim([0 max(precip_counts_cond)+0.01])

 

%Saving the data for each age_stop run
file = strcat('Precip_Conditional_Distribution_at_age_stop_', num2str(age_stop), '.mat');
save(file, 'precip_counts_cond', 'precip_center_cond', 'precip_frequency_age_stop', 'age_stop') 

age_stop

end
