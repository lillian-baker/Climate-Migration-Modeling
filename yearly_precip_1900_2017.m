% Extract monthly gridded precipitation values from netCDF file and average
% to annual values. For SMH project by L. Baker

% Data source: Univ Delaware monthly gridded product, at high resolution
% (0.5 x 0.5 degree), available from Jan-1901 to Dec-2017
% https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html

% Filename: precip.mon.total.v501.nc

% Variable metadata (from ncdisp):
% ncdisp('C:\Users\bbarrett\Documents\MATLAB\precip.mon.total.v501.nc')
% Source:
%            C:\Users\bbarrett\Downloads\precip.mon.total.v501.nc
% Format:
%            netcdf4_classic
% Global Attributes:
%            Conventions   = 'CF-1.0'
%            title         = 'Terrestrial Air Temperature and Precipitation: V4.01'
%            version       = '5.01'
%            dataset_title = 'Terrestrial Air Temperature and Precipitation: 1900-2017 Gridded Monthly Time Series'
%            history       = 'created 12/2018 by CAS NOAA/ESRL PSD'
%            Source        = 'http://climate.geog.udel.edu/~climate/html_pages/download.html'
%            References    = 'https://www.psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html'
%            _NCProperties = 'version=2,netcdf=4.6.3,hdf5=1.10.5'
% Dimensions:
%            lat  = 360
%            lon  = 720
%            time = 1416  (UNLIMITED)
% Variables:
%     lat   
%            Size:       360x1
%            Dimensions: lat
%            Datatype:   single
%            Attributes:
%                        actual_range       = [89.75       -89.75]
%                        long_name          = 'Latitude'
%                        units              = 'degrees_north'
%                        axis               = 'Y'
%                        standard_name      = 'latitude'
%                        coordinate_defines = 'center'
%     lon   
%            Size:       720x1
%            Dimensions: lon
%            Datatype:   single
%            Attributes:
%                        long_name          = 'Longitude'
%                        units              = 'degrees_east'
%                        axis               = 'X'
%                        standard_name      = 'longitude'
%                        actual_range       = [0.25        359.75]
%                        coordinate_defines = 'center'
%     time  
%            Size:       1416x1
%            Dimensions: time
%            Datatype:   double
%            Attributes:
%                        long_name          = 'Time'
%                        units              = 'hours since 1900-1-1 0:0:0'
%                        delta_t            = '0000-01-00 00:00:00'
%                        avg_period         = '0000-01-00 00:00:00'
%                        axis               = 'T'
%                        standard_name      = 'time'
%                        coordinate_defines = 'start'
%                        actual_range       = [0  1033632]
%     precip
%            Size:       720x360x1416
%            Dimensions: lon,lat,time
%            Datatype:   single
%            Attributes:
%                        missing_value = -9.969209968386869e+36
%                        units         = 'cm'
%                        var_desc      = 'Precipitation'
%                        level_desc    = 'Surface'
%                        statistic     = 'Total'
%                        parent_stat   = 'Other'
%                        long_name     = 'Monthly total of precipitation'
%                        cell_methods  = 'time: sum'
%                        avg_period    = '0000-01-00 00:00:00'
%                        actual_range  = [0        776.75]
%                        valid_range   = [0  1200]
%                        dataset       = 'Univ. of Delaware Precipitation and Air Temp v5.01'

% Extract the whole time series
precip_monthly = ncread('precip.mon.total.v501.nc','precip');
lat = ncread('precip.mon.total.v501.nc','lat');
lon = ncread('precip.mon.total.v501.nc','lon');
time= ncread('precip.mon.total.v501.nc','time');


% Sum the 12 months to get annual amounts
m=0; %year counter
for i=1900:2017
    m=m+1; %counter
    precip(:,:,m) = sum(precip_monthly(:,:,(m-1)*12+1:m*12),3); %sum up months 1-12, 13-24, 25-36, etc to get yearly precip at each grid point
end

% The variable "precip" has 720 longitudes x 360 latitudes x 118 years

save new_precip_variable_UDel.mat precip lat lon time

