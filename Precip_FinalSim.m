%Final Simulation (1940-2060) with precip

load Precip_anomaly_total.mat

%p_eq variable saved from code above; years beyond the precip data set
%padded with 0.55
load Precip_p_eq.mat

mu = 1.95;
sigma = .8;

trials_time = 10000;

%Define time vector in years
for t0 = 1940:1:2020
dt = .005;
t_final = t0 + 40; 
t = t0:dt:t_final;


%Initialize p vector
p = zeros(size(t));

 
%Set equilibrium and parameters
%Define equilibrium value based on precip
% for i = 41:1:160  %adjust time scale to precip data set
%     if i > 118
%         p_eq(i-40) = 0.55;
%     else
%         if abs(precip_anomaly_total(i))> 1
%         sig_fxn = 1;
%         else
%         sig_fxn = 0;
%         end
%         p_eq(i-40) = 0.55+sig_fxn*abs(precip_anomaly_total(i)/10);    %0.55+sig(precip_i(t))*abs(precip_i(t)
%     end
% end




%t_stop is the time when someone migrates
t_stop_precip = NaN(trials_time, 1);

%Build the function by Euler's Method

for p_0 = 0.01:0.01:0.99
    tic
    for r =1:trials_time %Will perform this loop for every trial
        p = zeros(size(t));
        p(1) = p_0;
        for i = 1:length(t)-1
            eq_index = t0 - 1940;
            eq_index = eq_index + ceil(i/200);
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
    file = strcat('Precip_', num2str(t0), '_v_Frequency_at_p_0_', num2str(p_0), '.mat');
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


end
t0
end


%% Final Simulation with Precip

%Building model over all years

%Create a probability sum for each year

%Initialize sum
precip_year_sum = NaN(41,81);

%Define population distribution of Mexico in 1980
x=15:1:80;  %Symbolic age vector
x = x-14;
f = exp((-1/20)*x);
f = f/sum(f);   %Normalize to sum to 1

for t0 = 1940:1:2020
    tic
    t = t0:1:t0+37;
    
%Perform for each year (i)
for i = 1:length(t)
    precip_year_sum(i, t0-1939) = 0;    %Ensure starting sum for year i is 0
    sum_age = 0;    %Initialize sum over all ages
    for age = 15:1:80
        
        file_1 = strcat('Precip_Conditional_Distribution_at_age_stop_', num2str(age), '.mat'); 
        load(file_1, 'precip_counts_cond', 'precip_center_cond');    %counts_cond is a 1x100 vector of frequencies
        %center_cond indexes correspond to center of decision factor
        
       sum_decision=0;
        %sum_decision=zeros(11,1);   %Initialize sum over all decision factors
        %r=1;    %Initialize counter for decision factor sum
        for p_0 = 0.01:0.01:0.99
            index = round(p_0*100); 
                %Only go to index 99 because index 100 (p=1) means that
                %person migrated at exactly age_stop
            %prob = 0;   %Reset probability sum for each decision factor
            file_2 = strcat('Precip_', num2str(t0), '_v_Frequency_at_p_0_', num2str(p_0), '.mat'); 
            load(file_2, 'precip_counts_time');     
            %counts_time is 1x41, indexed so that i=1 symbolizes 1980 and
                %each index increases by year after that
            
            %counts_time(i) = probability that a person migrated in year i
            %counts_cond(p_0*100) = probability that a person who
                %hasn't migrated at age has decision factor = p_0
            sum_decision = sum_decision + precip_counts_time(i)*precip_counts_cond(index)*f(age-14); %age-14 corresponds
            %             r = r+1;
            %Add new probability to the sum of probability overa all
            %decision factors
            
        end
        %Add the sum over all decision factors to the existing sum over all
        %ages
        sum_age = sum_age + sum_decision;
    end
    precip_year_sum(i, t0-1939)=sum_age;
end

t0
toc
end

precip_sim = zeros(118,1);
    for j = 1:81
        precip_sim(j:j+37,1) = precip_sim(j:j+37,1) + precip_year_sum(1:38,j);
    end
