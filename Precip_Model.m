%Building model over all years

%Create a probability sum for each year

%Time vector of years
t = 1980:1:2017;

%Initialize sum
year_sum = NaN(length(t),1);

%Define population distribution of Mexico in 1980
x=15:1:80;  %Symbolic age vector
x = x-14;
f = exp((-1/20)*x);
f = f/sum(f);   %Normalize to sum to 1


%Perform for each year (i)
for i = 1:length(t)
    year_sum(i) = 0;    %Ensure starting sum for year i is 0
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
            file_2 = strcat('Precip_Year_v_Frequency_at_p_0_', num2str(p_0), '.mat'); 
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
    year_sum(i)=sum_age;
end

%Below used to create the figure "Precip_model.png"
% freq = year_sum/sum(year_sum);
% figure
% plot(t, freq, 'o')
% title('Frequency of Migration vs. Time')
% ylabel('Normalized Frequency'); xlabel('Year')

%save('precip_model.mat', 't', 'freq', 'year_sum')

%USed to construct "freq_mig_data.png/.fig"
load mig170.mat
%Extract migration year in column 40
mig_year = mig170(:,40);
%Extract only years after 1980
mig_year = mig_year(mig_year > 1979);
[data_counts, data_center] = hist(mig_year, linspace(1980.5,2017.5, 38));
data_counts = data_counts/sum(data_counts);
figure
plot(data_center, data_counts, 'o')
title('Frequency of Migration vs. Year')
ylabel('Normalized Frequency')
xlabel('Year')

%Used to construct "anomaly_vs_freq_data.png/.fig"
figure
plot(data_counts, precip_anomaly_total(81:118), 'o')
title('Frequency of Migration vs. Total Precipitation Anomaly')
ylabel('Normalized Standard Deviation')
xlabel('Frequency of Migration')

%Used to construct"anomaly_vs_freq_model.png/.fig"
figure
plot(year_sum, precip_anomaly_total(81:118), 'o')
title('Frequency of Migration vs. Total Precipitation Anomaly')
ylabel('Normalized Standard Deviation')
xlabel('Frequency of Migration')
    