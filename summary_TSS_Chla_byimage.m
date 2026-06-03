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
    ["min","max","mean"], ...
    "TSS_mean");


disp(summary_TSS)

%% Summary by image for Chl-a after threshold

chlThreshold = 0.1;

T_chla = T(T.chl_a_mean >= chlThreshold, :);

summary_Chla = groupsummary(T_chla, ...
    "id_image", ...
    ["min","max","mean"], ...
    "chl_a_mean");

disp(summary_Chla)

%% Save summary

writetable(summary_TSS, "summary_TSS_by_image.xlsx")
writetable(summary_Chla, "summary_Chla_by_image_threshold_01.xlsx")
