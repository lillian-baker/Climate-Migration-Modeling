%CHIRPS Data practice

%Load data
precip = ncread('chirps-v2.0.annual.nc', 'precip', [1000 1201 1], [1100 500 39]);
%Time variable runs 1981-2019

%Load latitutde/longitude
lat = ncread('chirps-v2.0.annual.nc', 'latitude', 1201, 500);  %latitude 10.025 is row 1201, latitude 35.025 is row 1701
lon = ncread('chirps-v2.0.annual.nc', 'longitude', 1000, 1100); %longitude -130.025 is row 1000, longitude -75.025 is row 2100

%Create a meshgrid for x and y
[y,x] = meshgrid(lat, lon);

%% Break

%Make a figure
figure(1)
clf
hold on
axis equal %forces matlab to make axes proportional
contourf(x,y,squeeze(precip(:,:,18)),0:600:3000,'linecolor','none')
title('Annual preciptation in 1998, mm/year')
xlabel('longitude')
ylabel('latitude')
colormap(jet)
colorbar
caxis([0 3000])
xlim([-180 180])
ylim([-50 50])
%hh = colorbar;
%ylabel(hh, 'precipitation (mm)','fonstize', 14)
borders = shaperead('ne_50m_admin_0_countries.shp');
for j = 1:size(borders,1)
    line(borders(j).X, borders(j).Y, 'color', [50 50 50]/255, 'linestyle', '-', 'linewidth',1);
end

%% San Francisco del Rincon
%Data for San Francisco del Rincon 21.02 N	101.86 W
    %Row 1563, column 1421 (identified from viewing the X/Y data tables in
    %MatLab
subset_precip = precip(1563-5:1563+5, 1421-5:1421+5, :);  %creates subset of the precip data from 11 data points of both latitude and longitude (creating array with 121 points)
avg_precip = nanmean(reshape(subset_precip, 121, 39), 1);   %reshapes the subset into a vector and then takes the average
figure(2)
clf
hold on
line(1981:2019, squeeze(precip(1563, 1421, :)))
line(1981:2019, avg_precip, 'color', 'r')


%% Read in Community Lat/Long

% communities = xlsread('Communities_Appendix.xlsx');
load communities.mat
for i=1:size(communities,1)-1
    x_distance = x-(-1)*communities(i,7);
    y_distance = y-communities(i,6);
    
    combined_distance = sqrt((x_distance).^2 + (y_distance).^2);
    
    [min_dim1, index_dim1] = nanmin(combined_distance);
    [min_dim2, index_dim2] = nanmin(min_dim1);
    
    x_coordinate_community(i) = x(index_dim1(index_dim2), index_dim2);
    y_coordinate_community(i) = y(index_dim1(index_dim2), index_dim2);
    
    precip_community(i, :) = precip(index_dim1(index_dim2), index_dim2, :);
    
    %recreate subset_precip and avg_precip for each community (use 10 on
    %either side)
end

%% Create figures

%for i=1:size(precip_community, 1)
for i = 121
    figure (1)
        clf
    %ylim manual
    %ylim([100 3500]) %standardize y axis
    %hold on
    plot(1981:2019, precip_community(i,:))
    title(['Annual Precipitation for Community ', num2str(i)])
    xlabel('Year')
    ylabel('Precipitation (mm)')
    filename = ['AutoScale_Precip_Community_', num2str(i), '.png'];
    %saveas(gcf, filename)
end





























