clear
clc
close all

%% Read the Excel dataset

T = readtable("Ebro_dataset_MATLAB.xlsx", ...
    "Sheet", "Sentinel-RAdCor data", ...
    "VariableNamingRule", "preserve");

%% Define input bands and target variable

bandCols = {'B1_mean','B2_mean','B3_mean','B4_mean','B5_mean','B6_mean','B7_mean','B8_mean','B8a_mean'};

targetCol = 'TSS_mean';

%% Create X and Y for Run_reg_MLP_clean.m

X = table2array(T(:, bandCols));

Y = T.(targetCol);

%% Basic checks

disp("Dataset loaded correctly.")
disp("Size of X:")
disp(size(X))

disp("Size of Y:")
disp(size(Y))

disp("Missing values in X:")
disp(sum(isnan(X), "all"))

disp("Missing values in Y:")
disp(sum(isnan(Y), "all"))

disp("TSS range:")
disp([min(Y), max(Y), mean(Y)])

%% Run MLP script

Run_reg_clean_TSS

%% Save results

if ~exist("results", "dir")
    mkdir("results")
end

exportgraphics(gcf, "results/MLP_TSS_random_split.png", "Resolution", 300)
savefig(gcf, "results/MLP_TSS_random_split.fig")

save("results/MLP_TSS_random_split_results.mat", ...
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
