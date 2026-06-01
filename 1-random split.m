%% Random split: 70% training, 30% validation

rng(1) %%rende il random split ripetibile quindi la prossima volta vengono scelti gli stessi samples importante per confrontare esperimenti

N = size(X, 1);

idx = randperm(N); %%crea lista casuale di numeri da 1 a N

Ntrain = round(0.70 * N);

idxTrain = idx(1:Ntrain);
idxVal = idx(Ntrain+1:end);

Xtrain_raw = X(idxTrain, :);
Ytrain_raw = Y(idxTrain, :);

Xval_raw = X(idxVal, :);
Yval_raw = Y(idxVal, :);

disp("Size of Xtrain_raw:")
disp(size(Xtrain_raw))

disp("Size of Ytrain_raw:")
disp(size(Ytrain_raw))

disp("Size of Xval_raw:")
disp(size(Xval_raw))

disp("Size of Yval_raw:")
disp(size(Yval_raw))


%% Z-score normalization

[Xtrain_norm, normX] = zScoreNormalization(Xtrain_raw, 'calculate'); %%calcola media e deviazione standard delle bande solo sul training set e normalizza Xtrain_raw

[Xval_norm, ~] = zScoreNormalization(Xval_raw, ...
    'usePredefined', normX.mean, normX.std); %%normalizza la validation usando la stessa media e deviazione standard del training

[Ytrain_norm, normY] = zScoreNormalization(Ytrain_raw, 'calculate');

[Yval_norm, ~] = zScoreNormalization(Yval_raw, ...
    'usePredefined', normY.mean, normY.std);
    

%% Prepare data format for MLP_reg_FN

Xtrain_MLP = Xtrain_norm';
Ytrain_MLP = Ytrain_norm';

Xval_MLP = Xval_norm';
Yval_MLP = Yval_norm';


%% Train first MLP model: manual architecture

architecture = [30 30];

[model_TSS_manual, Yval_pred_norm] = MLP_reg_FN( ...
    Xtrain_MLP, ...
    Ytrain_MLP, ...
    Xval_MLP, ...
    Yval_MLP, ...
    "manual", ...
    architecture);


MLP_reg_FN(...)


%% Convert predictions back to original TSS units

Yval_pred = Yval_pred_norm' .* normY.std + normY.mean;

Yval_true = Yval_raw;


%% Calculate simple validation metrics

errors = Yval_pred - Yval_true;

RMSE = sqrt(mean(errors.^2));
MAE = mean(abs(errors));
Bias = mean(errors);

R2 = 1 - sum(errors.^2) / sum((Yval_true - mean(Yval_true)).^2);

disp("Validation metrics for TSS - manual MLP")
disp(table(R2, RMSE, MAE, Bias))

%% Scatter plot: true vs predicted TSS

figure
densityScatter(Yval_true, Yval_pred)
title("TSS - Random split - Manual MLP [30 30]")
xlabel("True TSS")
ylabel("Predicted TSS")
