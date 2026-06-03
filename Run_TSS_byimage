clear
clc
close all

%% Read dataset

T = readtable("Ebro_dataset_MATLAB.xlsx", ...
    "Sheet", "Sentinel-RAdCor data", ...
    "VariableNamingRule", "preserve");

%% Define input bands and target

bandCols = {'B1_mean','B2_mean','B3_mean','B4_mean','B5_mean','B6_mean','B7_mean','B8_mean','B8a_mean'};

targetCol = 'TSS_mean';

X = table2array(T(:, bandCols));
Y = T.(targetCol);

%% Define validation images

valImages = [
    "S2B_T31TCF_2018-03-07"
    "S2A_T31TBF_2023-08-03"
    "S2C_2025-08-22_LEE001000"
];

%% Run MLP with image split

Run_reg_clean_splitbyimage

%% Plot labels

title('MLP - TSM - Split by image')
xlabel('In-situ TSM [g/m^3]')
ylabel('Predicted TSM [g/m^3]')

%% Save results

if ~exist("results", "dir")
    mkdir("results")
end

exportgraphics(gcf, "results/MLP_TSM_split_by_image.png", "Resolution", 300)
savefig(gcf, "results/MLP_TSM_split_by_image.fig")

save("results/MLP_TSM_split_by_image_results.mat", ...
    "model", ...
    "valImages", ...
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
