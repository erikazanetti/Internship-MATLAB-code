clear
clc
close all

%% Read dataset

T = readtable("Ebro_dataset_MATLAB.xlsx", ...
    "Sheet", "Sentinel-RAdCor data", ...
    "VariableNamingRule", "preserve");

%% Filter Chl-a values

chlThreshold = 0.1;

T = T(T.chl_a_mean >= chlThreshold, :);

%% Define input bands and target

bandCols = {'B1_mean','B2_mean','B3_mean','B4_mean','B5_mean','B6_mean','B7_mean','B8_mean','B8a_mean'};

targetCol = 'chl_a_mean';

X = table2array(T(:, bandCols));
Y = T.(targetCol);

%% Define validation images

valImages = [
    "S2B_T31TCF_2018-03-07"
    "S2A_T31TBF_2023-08-03"
    "S2C_2025-08-22_LEE001000"
];

%% Run MLP with image split

Run_reg_image_split_clean

%% Plot labels

title('MLP - Chl-a - Split by image')
xlabel('In-situ Chl-a [\mug/L]')
ylabel('Predicted Chl-a [\mug/L]')

%% Save results

if ~exist("results", "dir")
    mkdir("results")
end

exportgraphics(gcf, "results/MLP_Chla_split_by_image_threshold_01.png", "Resolution", 300)
savefig(gcf, "results/MLP_Chla_split_by_image_threshold_01.fig")

save("results/MLP_Chla_split_by_image_threshold_01_results.mat", ...
    "model", ...
    "valImages", ...
    "chlThreshold", ...
    "idxTrain", "idxVal", ...
    "Xtrain", "Ytrain", ...
    "Xval", "Yval", ...
    "y_pred_MLP", ...
    "normalizationParams_X", ...
    "normalizationParams_Y", ...
    "Yval_plot", ...
    "Ypred_plot", ...
    "bandCols", ...
    "targetCol")
