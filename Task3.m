%Running year vs. frequency for the model with 1980 = year 0

%Define time vector in years
t0 = 1980;
dt = .005;
t_final = 2020; 
t = t0:dt:t_final;


%Initialize p vector
p = zeros(size(t));

 
%Set equilibrium and parameters
%for t0:1:t_final
%p_eq=zeros(size(t),1)
p_eq = 0.55;    %0.55+sig(precip_i(t))*abs(precip_i

mu = 1.95;
sigma = .8;

trials_time = 10000;

%t_stop is the time when someone migrates
t_stop = NaN(trials_time, 1);

%Build the function by Euler's Method

for p_0 = 0.01:0.01:0.99
    tic
    for r =1:trials_time %Will perform this loop for every trial
        p = zeros(size(t));
        p(1) = p_0;
        for i = 1:length(t)-1
            p(i+1) = p(i) + dt*mu*p(i)*(p_eq-p(i))+sqrt(dt)*sigma*(p(i)^2)*randn; %Adding dp to each p(i) to find p(i+1)
            if p(i+1) > 1 %First passage time signifies this person migrated
                t_stop(r) = t(i+1); %Record year in which this person migrated
                %Final t_stop vector has a year for everyone who migrated,
                %o/w value is 0
                break
            end
        end
    end




    %Count the frequency of migration in each year
    %hist(data, either number of bins OR bin centers)
    [counts_time, center_time] = hist(t_stop, linspace(t0+0.5,t_final+0.5, 41)); %try with different bin numbers
    counts_time = counts_time/sum(counts_time); %Normalize to sum to 1
    
    %save these values for each p_0
    %file = strcat('Year_v_Frequency_at_p_0_', num2str(p_0), '.mat');
    %save(file, 'counts_time', 'center_time', 'p_0', 'trials_time', 't_stop', 't0', 't_final', 't')
    
    %Create figure of year vs. frequency
%     figure 
%     hold on
%     plot(center_time, counts_time, 'o')
%     title(['Frequency of Migration vs. Year for p_{0} =', num2str(p_0)])
%     xlabel('Year')
%     ylabel('Normalized Frequency')
%     xlim([t0 t_final+1])
%     ylim([0 max(counts_time)+0.01])

p_0

toc
end
