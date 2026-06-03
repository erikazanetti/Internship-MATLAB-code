%% Data Preparation - split by image

if ~exist("valImages", "var")
    error("You must define valImages before running this script.")
end

valRows = ismember(string(T.id_image), string(valImages));
trainRows = ~valRows;

idxTrain = find(trainRows);
idxVal = find(valRows);
Xtrain = X(trainRows,:);
Ytrain = Y(trainRows,:);
Xval = X(valRows,:);
Yval = Y(valRows,:);

disp("Training samples:")
disp(size(Xtrain,1))
disp("Validation samples:")
disp(size(Xval,1))
disp("Validation images:")
disp(valImages)


%% Data Normalization

[Xtrain, normalizationParams_X] = zScoreNormalization(Xtrain, 'calculate');
Xtrain = Xtrain';

[Ytrain, normalizationParams_Y] = zScoreNormalization(Ytrain, 'calculate');
Ytrain = Ytrain';

[Xval, normalizationParams] = zScoreNormalization(Xval, 'usePredefined', normalizationParams_X.mean, normalizationParams_X.std);
Xval = Xval';

[Yval, normalizationParams] = zScoreNormalization(Yval, 'usePredefined', normalizationParams_Y.mean, normalizationParams_Y.std);
Yval = Yval';


%% MLP

[model, y_pred_MLP] = MLP_reg_FN(Xtrain, Ytrain, Xval, Yval, "bayes");

Yval_plot = Yval(:) .* normalizationParams_Y.std + normalizationParams_Y.mean;
Ypred_plot = y_pred_MLP(:) .* normalizationParams_Y.std + normalizationParams_Y.mean;

figure;
densityScatter(Yval_plot, Ypred_plot)
