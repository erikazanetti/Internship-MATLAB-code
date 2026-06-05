clear
clc
close all

%% Read dataset

T = readtable("Ebro_TOA_data_MATLAB.xlsx", ...
    "Sheet", "Sentinel TOA data", ...
    "VariableNamingRule", "preserve");

%% Define input bands and target

bandCols = {'B1_mean','B2_mean','B3_mean','B4_mean','B5_mean','B6_mean','B7_mean','B8_mean','B8a_mean'};

targetCol = 'TSS_mean';

X = table2array(T(:, bandCols));
Y = T.(targetCol);

%% Define validation images

valImages = [
    "S2B_MSIL1C_20180307T105019_N0500_R051_T31TCF_20230908T224638.SAFE"
    "S2A_MSIL1C_20230803T104631_N0510_R051_T31TBF_20241015T035715.SAFE"
    "S2C_MSIL1C_20250822T105041_N0511_R051_T31TCF_20250822T142931.SAFE"
];

%% Run MLP with image split

Run_reg_clean_splitbyimage

%% Plot labels

title('MLP - TOA - TSM - Split by image')
xlabel('In-situ TSM [g/m^3]')
ylabel('Predicted TSM [g/m^3]')

%% Save results

if ~exist("results", "dir")
    mkdir("results")
end

exportgraphics(gcf, "results/MLP_TOA_TSM_split_by_image.png", "Resolution", 300)
savefig(gcf, "results/MLP_TOA_TSM_split_by_image.png.fig")

save("results/MLP_TOA_TSM_split_by_image.png.mat", ...
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
