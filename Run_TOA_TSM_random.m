clear
clc
close all

%% Read TOA dataset

T = readtable("Ebro_TOA_data.xlsx", ...
    "Sheet", "Sentinel TOA data", ...
    "VariableNamingRule", "preserve");


%% Define input bands and target

bandCols = {'B1_mean','B2_mean','B3_mean','B4_mean','B5_mean','B6_mean','B7_mean','B8_mean','B8a_mean'};

targetCol = 'TSS_mean';

X = table2array(T(:, bandCols));
Y = T.(targetCol);

%% Run random split MLP

Run_reg_clean

%% Plot labels

title('MLP - TOA - TSM - Random split')
xlabel('In-situ TSM [g/m^3]')
ylabel('Predicted TSM [g/m^3]')

%% Save results

if ~exist("results", "dir")
    mkdir("results")
end

exportgraphics(gcf, "results/MLP_TOA_TSM_random_split.png", "Resolution", 300)
savefig(gcf, "results/MLP_TOA_TSM_random_split.fig")

save("results/MLP_TOA_TSM_random_split_results.mat", ...
    "model", ...
    "idx", ...
    "Xtrain", "Ytrain", ...
    "Xval", "Yval", ...
    "y_pred_MLP", ...
    "normalizationParams_X", ...
    "normalizationParams_Y", ...
    "Yval_plot", ...
    "Ypred_plot", ...
    "bandCols", ...
    "targetCol")
