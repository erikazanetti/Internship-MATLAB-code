clear
clc
close all

%% Read the Excel dataset

T = readtable("Ebro_dataset_MATLAB.xlsx", ...
    "Sheet", "Sentinel-RAdCor data", ...
    "VariableNamingRule", "preserve");

%% Define Chl-a threshold

chlThreshold = 0.1;

%% Filter dataset for Chl-a

validRows = T.chl_a_mean >= chlThreshold;

T = T(validRows, :);

%% Define input bands and target variable

bandCols = {'B1_mean','B2_mean','B3_mean','B4_mean','B5_mean','B6_mean','B7_mean','B8_mean','B8a_mean'};

targetCol = 'TSS_mean';

%% Create X and Y for

X = table2array(T(:, bandCols));

Y = T.(targetCol);

%% Basic checks

disp("Chl-a dataset loaded correctly.")
disp("Threshold used:")
disp(chlThreshold)

disp("Number of samples after filtering:")
disp(size(T,1))

disp("Size of X:")
disp(size(X))

disp("Size of Y:")
disp(size(Y))

disp("Missing values in X:")
disp(sum(isnan(X), "all"))

disp("Missing values in Y:")
disp(sum(isnan(Y), "all"))

disp("Chl-a range after filtering:")
disp([min(Y), max(Y), mean(Y)])

%% Run MLP script

Run_reg_clean

title('MLP')
xlabel('In-situ Chl-a [μg/L]')
ylabel('Predicted Chl-a [μg/L]')

%% Save results

if ~exist("results", "dir")
    mkdir("results")
end

exportgraphics(gcf, "results/MLP_Chla_random_split_threshold_01.png", "Resolution", 300)
savefig(gcf, "results/MLP_Chla_random_split_threshold_01.fig")

save("results/MLP_Chla_random_split_threshold_02_results.mat", ...
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
    "targetCol", ...
    "chlThreshold")
