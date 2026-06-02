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

%% Create X and Y for Run_reg.m

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

%% Run supervisor script

%% Data Preparation

rng(1)

N = size(X,1);

idx = randperm(N);

Ntrain = round(0.7*N);

Xtrain = X(idx(1:Ntrain),:);
Ytrain = Y(idx(1:Ntrain),:);

Xval = X(idx(Ntrain+1:end),:);
Yval = Y(idx(Ntrain+1:end),:);

disp("Training samples:")
disp(size(Xtrain))

disp("Validation samples:")
disp(size(Xval))


%% Data Normalization

[Xtrain, normalizationParams_X] = zScoreNormalization(Xtrain, 'calculate');
Xtrain = Xtrain';

[Ytrain, normalizationParams_Y] = zScoreNormalization(Ytrain, 'calculate');
Ytrain = Ytrain';

[Xval, ~] = zScoreNormalization(Xval, ...
    'usePredefined', normalizationParams_X.mean, normalizationParams_X.std);
Xval = Xval';

[Yval, ~] = zScoreNormalization(Yval, ...
    'usePredefined', normalizationParams_Y.mean, normalizationParams_Y.std);
Yval = Yval';


%% MLP

[model, y_pred_MLP] = MLP_reg_FN(Xtrain, Ytrain, Xval, Yval, "bayes");


%% Convert validation data back to original TSS scale

Yval_original = Yval' .* normalizationParams_Y.std + normalizationParams_Y.mean;

Ypred_original = y_pred_MLP' .* normalizationParams_Y.std + normalizationParams_Y.mean;


%% Scatter plot

figure;
densityScatter(Yval_original, Ypred_original)

title('MLP - TSS - Random split')
xlabel('In-situ TSS [g/m^3]')
ylabel('Predicted TSS [g/m^3]')


%% Simple accuracy metrics

errors = Ypred_original - Yval_original;

R2 = 1 - sum(errors.^2) / sum((Yval_original - mean(Yval_original)).^2);
RMSE = sqrt(mean(errors.^2));
MAE = mean(abs(errors));
Bias = mean(errors);

disp("MLP validation metrics:")
disp(table(R2, RMSE, MAE, Bias))
