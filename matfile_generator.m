% .mat file generator
% Created by: Jenna Grieshop
% Date created: 7/25/2023
%
% Purpose: To create .mat files that correspond with bin converted .avis
%
% Inputs: LUT file (.csv or .xlsx that is formatted for the automontager
% and also included the FOVs in column E (formatted as just one number
% e.g. 3)
%
% Outputs: .mat files containing the struct and field containing the fov
% number that is used by ARFS for each confocal video in the data folder
%
% Developed with MATLAB 2023b, need at least 2022b to run

clear all
close all
clc


%% load in the LUT file

% User selects the LUT:
[LUTfile, LUTpath] = uigetfile({'*.xlsx; *.csv'},'Select the LUT');
LUT = readcell(fullfile(LUTpath,LUTfile));

% User selects the folder containing avis
data_dir_path = uigetdir('.','Select directory containing input data');

% Find the files within the chosen directory:
data_dir = dir(data_dir_path);
temp = data_dir;

% Fix the DOS era issue with the dir function (loads in the parent
% directories '.' and '..')
data_dir = temp(~ismember({temp.name}, {'.', '..'}));
fname_list = {data_dir.name}';


%% Reading in information from LUT file and loading data

% loop to go through each file in folder
for i = (1:length(data_dir))
    % finds files that are confocal
    if contains(data_dir(i).name, 'CON', IgnoreCase=true)
        % extracts the video number from the avi name
        vid_num = str2double(data_dir(i).name(end-6:end-4));
        % extracts which index that video number is on for the lut file
        index = find([LUT{:,1}] == vid_num);
        % extracts the fov from the LUT
        fov = LUT{index, 5};
        % creates the variable we need to match what is normally in the mat
        % file and extracted from ARFS
        optical_scanners_settings.raster_scanner_amplitude_in_deg = fov;
        save(fullfile(data_dir_path, strcat(data_dir(i).name(1:end-4), '.mat')), "optical_scanners_settings");
    end

end

