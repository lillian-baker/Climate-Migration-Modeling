%Building model over all years

%Create a probability sum for each year

%Time vector of years
t = 1980:1:2020;

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
        
        file_1 = strcat('Conditional_Distribution_at_age_stop_', num2str(age), '.mat'); 
        load(file_1, 'counts_cond', 'center_cond');    %counts_cond is a 1x100 vector of frequencies
        %center_cond indexes correspond to center of decision factor
        
       sum_decision=0;
        %sum_decision=zeros(11,1);   %Initialize sum over all decision factors
        %r=1;    %Initialize counter for decision factor sum
        for p_0 = 0.01:0.01:0.99
            index = round(p_0*100); 
                %Only go to index 99 because index 100 (p=1) means that
                %person migrated at exactly age_stop
            %prob = 0;   %Reset probability sum for each decision factor
            file_2 = strcat('Year_v_Frequency_at_p_0_', num2str(p_0), '.mat'); 
            load(file_2, 'counts_time');     
            %counts_time is 1x41, indexed so that i=1 symbolizes 1980 and
                %each index increases by year after that
            
            %counts_time(i) = probability that a person migrated in year i
            %counts_cond(p_0*100) = probability that a person who
                %hasn't migrated at age has decision factor = p_0
            sum_decision = sum_decision + counts_time(i)*counts_cond(index)*f(age-14); %age-14 corresponds
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
    