%Running year vs. frequency for the model with 1980 = year 0
%Testing the addition of precip for Community 30
load Precip_anomaly_total.mat


%Define time vector in years
t0 = 1980;
dt = .005;
t_final = 2018; 
t = t0:dt:t_final;


%Initialize p vector
p = zeros(size(t));

 
%Set equilibrium and parameters
%Define equilibrium value based on precip
for i = (t0-1899):1:(t_final-1902)  %adjust time scale to precip data set
    if abs(precip_anomaly_total(i))> 1
        sig_fxn = 1;
    else
        sig_fxn = 0;
    end
    %Shift to start index at 1, corresponds to 1980
    p_eq(i-80) = 0.55+sig_fxn*abs(precip_anomaly_total(i)/10);    %0.55+sig(precip_i(t))*abs(precip_i(t)
end

mu = 1.95;
sigma = .8;

trials_time = 10000;

%t_stop is the time when someone migrates
t_stop_precip = NaN(trials_time, 1);

%Build the function by Euler's Method

for p_0 = 0.01:0.01:0.99
    tic
    for r =1:trials_time %Will perform this loop for every trial
        p = zeros(size(t));
        p(1) = p_0;
        for i = 1:length(t)-1
            eq_index = ceil(i/200);
            p(i+1) = p(i) + dt*mu*p(i)*(p_eq(eq_index)-p(i))+sqrt(dt)*sigma*(p(i)^2)*randn; %Adding dp to each p(i) to find p(i+1)
            if p(i+1) > 1 %First passage time signifies this person migrated
                t_stop_precip(r) = t(i+1); %Record year in which this person migrated
                %Final t_stop vector has a year for everyone who migrated,
                %o/w value is 0
                break
            end
        end
    end




    %Count the frequency of migration in each year
    %hist(data, either number of bins OR bin centers)
    [precip_counts_time, precip_center_time] = hist(t_stop_precip, linspace(t0+0.5,t_final-0.5, 38)); %try with different bin numbers
    precip_counts_time = precip_counts_time/sum(precip_counts_time); %Normalize to sum to 1
    
    %save these values for each p_0
    file = strcat('Precip_Year_v_Frequency_at_p_0_', num2str(p_0), '.mat');
    save(file, 'precip_counts_time', 'precip_center_time', 'p_0', 'trials_time', 't_stop_precip', 't0', 't_final', 't')
    
    %Create figure of year vs. frequency
%     figure 
%     hold on
%     plot(precip_center_time, precip_counts_time, 'o')
%     title(['Frequency of Migration vs. Year for p_{0} =', num2str(p_0)])
%     xlabel('Year')
%     ylabel('Normalized Frequency')
%     xlim([t0 t_final+1])
%     ylim([0 max(counts_time)+0.01])

p_0

toc
end
