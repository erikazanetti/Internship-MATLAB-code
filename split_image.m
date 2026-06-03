clear
clc
close all

%% Read dataset

T = readtable("Ebro_dataset_MATLAB.xlsx", ...
    "Sheet", "Sentinel-RAdCor data", ...
    "VariableNamingRule", "preserve");

%% Summary by image for TSS

summary_TSS = groupsummary(T, ...
    "id_image", ...
    ["numel","min","max","mean"], ...
    "TSS_mean");

disp("TSS summary by image:")
disp(summary_TSS)

%% Summary by image for Chl-a after threshold

chlThreshold = 0.1;

T_chla = T(T.chl_a_mean >= chlThreshold, :);

summary_Chla = groupsummary(T_chla, ...
    "id_image", ...
    ["numel","min","max","mean"], ...
    "chl_a_mean");

disp("Chl-a summary by image:")
disp(summary_Chla)
