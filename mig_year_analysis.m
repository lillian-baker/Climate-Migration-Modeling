%Make a histogram of years of 1st US migration

%Read in mig170 file - contains data on heads of household who have
%migrated
mig170 = xlsread('mig170_excel.xlsx');

%Pulls the data for year of first US trip
usmigyr1 = mig170(:, 40);

%Pulls the column for year surveyed
survey_year = mig170(:, 4);

%Initialize counter 
counter_year(1:121) = 0;

%Calculate the number of times each year could have occurred as an answer
%for year of first migration
for i = 1:size(survey_year, 1)
    for k = 1900:survey_year(i)
        counter_year(k-1899) = counter_year(k-1899)+1;
    end
end


clear mig170

[N, BIN] = histc(usmigyr1, 1900.5:1:2020.5); %Returns count vector N and bin number vector BIN for year of first US migration

%Plot bar graph for years of first US migration
figure(1)
clf
hold on
bar(1901:2021, N)
title('Frequency of Years of First US Migration') 
xlabel('Year')
ylabel('Number of People to Migrate')

%Plot bar graph for frequency of years as possible answers (inclusive of
%survey year)
figure(2)
clf
hold on
bar(1900:2020, counter_year, 'k')
title('Possible Occurrences of Years of First US Migration')
xlabel('Year')
ylabel('Possible Number of People to Migrate')

%Scale the years of first US migration according to possibility as an
%answer
normalized_data = N./counter_year';

%Plot scaled/normalized data for year of first US migration
figure(3)
clf
hold on
bar(1901:2021, normalized_data, 'g')
title('Scaled Frequency of Years of First US Migration')
xlabel('Year')
ylabel('People who Migrated as a Fraction of Possible Total')