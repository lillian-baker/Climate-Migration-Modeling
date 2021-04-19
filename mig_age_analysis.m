%Age of migration analysis
%Make a histogram of age at year of 1st migration

%Read data
load mig170.mat;

%Pull columns for birth year, year of 1st migration, 
usmigyr1 = mig170(:, 40);
birth_year = mig170(:, 8);
survey_year = mig170(:, 4);

%8823 data points in each vector

%Calculate age at 1st migration
mig_age = zeros(8823,1);
mig_age = usmigyr1 - birth_year;

%Clean data for survey responses of "unknown"
mig_age = mig_age(mig_age < 100 & mig_age > 0);
length(mig_age) %8816 data points

a = min(mig_age);
b = max(mig_age);
%Confirmed these results with the data set

clear mig170

%Build histogram
[N, BIN] = histc(mig_age, a-0.5:1:b-0.5);
% figure
% clf
% hold on
% bar (a:b, N)
% title('Frequency of Age of First US Migration')
% xlabel('Age')
% ylabel('Number of People to Migrate')

%Scaled frequency figure
figure
clf
hold on
bar (a:b, N/sum(N))
xlim([15 100])
title('Frequency of Age of First US Migration')
xlabel('Age')
ylabel('Normalized Frequency')