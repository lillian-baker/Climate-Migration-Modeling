%Migration time/age analysis for community 159
%Ixcaquitla, Puebla, MX
%219 people surveyed in 2016, 40 confirmed to migrate

%% Build community migration data

%Load data
load mig170.mat
%Survey year in column 4
%Birth year in column 8
%Migration year in column 40


N = NaN(170, 121);
normalized_data = NaN(170,121);


%Set community
%place = 159;
for place = 1:170

%Code below was used to extract migration data for each community
%separately
% %     %Initialize matrix
%     comm = zeros(219,3);
% 
%     %Initialize count
%     count = 0;
% 
%     %Pull data for community: construct matrix of survey year, birth year,
%     %migration year
%     for i = 1:8823
%         if mig170(i,2) == place
%             count = count+1;
%             comm(count,1) = mig170(i,4);
%             comm(count,2) = mig170(i,8);
%             comm(count,3) = mig170(i,40);        
%         end
%     end
% 
%     A = nonzeros(comm);
%     B = reshape(A, count, 3);
%     comm = B;
% 
% save(['Community_' num2str(place),'.mat'], 'comm', 'place') 


load(['Community_' num2str(place),'.mat'], 'comm') 





%     % Age of migration analysis
% 
        migyr = comm(:,3);
%     birthyr = comm(:,2);
%     age = migyr - birthyr;
% 
%     a = min(age);
%     b = max(age);
% 
%     % [n, bin] = histc(age, a-0.5:1:b-0.5);
%     % figure
%     % clf
%     % hold on
%     % bar (a:b, n)
%     % title('Frequency of Age of First US Migration')
%     % xlabel('Age')
%     % ylabel('Number of People to Migrate')
%     % ylim([0 max(n)+1])
% 
%     %Scaled age of migration
%     [n, bin] = histc(age, a-0.5:1:b-0.5);
%     n = n./sum(n);
%     figure
%     clf
%     hold on
%     bar (a:b, n)
%     title('Frequency of Age of First US Migration')
%     xlabel('Age')
%     ylabel('Number of People to Migrate')
%     ylim([0 max(n)+0.05])




    % Migration timing analysis

    survyr = comm(:,1);

    [dummy_N, dummy_BIN] = histc(migyr, 1900.5:1:2020.5); %Returns count vector N and bin number vector BIN for year of first US migration
    N(place,1:121) = dummy_N; %Builiding array of all N
    
    %Plot bar graph for years of first US migration
%     figure(1)
%     clf
%     hold on
%     bar(1901:2021, N)
%     title('Frequency of Years of First US Migration') 
%     xlabel('Year')
%     ylabel('Number of People to Migrate')
%     ylim([0 max(N)+1])

    % Scaled Frequency Analysis

    %Plot bar graph for frequency of years as possible answers (inclusive of
    %survey year)

    %Calculate the number of times each year could have occurred as an answer
    %for year of first migration
    counter_year(1:121) = 0;

    for i = 1:size(survyr, 1)
        for k = 1900:survyr(i)
            counter_year(k-1899) = counter_year(k-1899)+1;
        end
    end

    % figure(2)
    % clf
    % hold on
    % bar(1900:2020, counter_year, 'k')
    % title('Possible Occurrences of Years of First US Migration')
    % xlabel('Year')
    % ylabel('Possible Number of People to Migrate')

    %Scale the years of first US migration according to possibility as an
    %answer
    normalized_data(place,1:121) = N(place,:)./counter_year; 
    
    normalized_data_v2(place,1:121) = N(place,:)./sum(N(place,:)); 

%     %Plot scaled/normalized data for year of first US migration
%     figure(4)
%     clf
%     hold on
%     bar(1901:2021, normalized_data(place,:), 'g')
%     title('Scaled Frequency of Years of First US Migration')
%     xlabel('Year')
%     ylabel('People who Migrated as a Fraction of Possible Total')
end   %Compiles migration data (normalized_data) for all 170 communities over 121 years

%% Precipitation Analysis

%Load community location data: community number in first column, year
%surveyed in column 3, latitude in column 6, longitude in column 7

load communities.mat   

%Pulls estimated lat/long of a community
comm_lat = communities(:, 6);
comm_long = communities(:, 7);

load new_precip_variable_UDel.mat %Annual precip for 1900-2017

lon_old = lon; %Converting longitude to match CHIRPS format
lon = lon_old-360; %Converting DE longitude to match CHIRPS


%Create a meshgrid for x and y
[y,x] = meshgrid(lat, lon);


%Find nearest point in UDel precip dataset

for i=1:size(communities,1)-1 %Remove NaN in last row (1:170)
    
    %Calculate distances between communities and every lat/lon point in the precip dataset
    x_distance = x-(-1)*communities(i,7);
    y_distance = y-communities(i,6);
    %Turn x and y distances into straight distance
    combined_distance = sqrt((x_distance).^2 + (y_distance).^2);
    
    %Find the nearest point
    [min_dim1, index_dim1] = nanmin(combined_distance);
    [min_dim2, index_dim2] = nanmin(min_dim1);
    
    %Building new lat/lon vectors of the points each community (i) is
    %closest to
    x_coordinate_community(i) = x(index_dim1(index_dim2), index_dim2);
    y_coordinate_community(i) = y(index_dim1(index_dim2), index_dim2);
    
    precip_community(i, :) = precip(index_dim1(index_dim2), index_dim2, :);
    
    %recreate subset_precip and avg_precip for each community (use 10 on
    %either side)
end

%Anomalous precip variable
% for i = 1:170
%    precip_anomaly_community(i,:) = precip_community(i,:)-nanmean(precip_community(i,:),2);
% end

%Standard deviation precip variable
for i = 1:170
    precip_anomaly_community(i,:) = (precip_community(i,:)-nanmean(precip_community(i,:),2))./nanstd(precip_community(i,:),0,2);
end

    %for all communities: 
    %precip_anomaly_total = sum(precip_community)-nanmean(sum(precip_community))./nanstd(sum(precip_community))
    
    precip_anomaly_total = nanmean(precip_anomaly_community,1); %averaging standardized anomalies
    
    
%% Scatterplot Analysis

% figure(5)
% clf
% hold on
% %correct for 3 fewer years in DE dataset
% plot(normalized_data([1:62, 64:122, 124:170],1:118), precip_community([1:62, 64:122, 124:170],:), 'kx')
%Frequency on x-axis and precip on y-axis
normalized_data_no_zeros = normalized_data; 
normalized_data_no_zeros(normalized_data==0) = NaN;

% figure(7)
% clf
% hold on
% %correct for 3 fewer years in DE dataset
% plot(normalized_data([1:62, 64:122, 124:170],1:118), precip_anomaly_community([1:62, 64:122, 124:170],:), 'kx')
% 
% corrcoef(normalized_data([1:62, 64:122, 124:170],1:118), precip_anomaly_community([1:62, 64:122, 124:170],:), 'rows', 'pairwise')


figure
clf
hold on
%correct for 3 fewer years in UDel dataset
plot(normalized_data_no_zeros([1:62, 64:122, 124:170],1:118), precip_anomaly_community([1:62, 64:122, 124:170],:), 'kx')

%corrcoef(normalized_data_no_zeros([1:62, 64:122, 124:170],1:118), precip_anomaly_community([1:62, 64:122, 124:170],:), 'rows', 'pairwise')

% 
% normalized_data_no_zeros_v2 = normalized_data_v2; 
% normalized_data_no_zeros_v2(normalized_data_v2==0) = NaN;
% 
% figure(9)
% clf
% hold on
% %correct for 3 fewer years in DE dataset
% plot(normalized_data_no_zeros_v2([1:62, 64:122, 124:170],1:118), precip_anomaly_community([1:62, 64:122, 124:170],:), 'kx')

