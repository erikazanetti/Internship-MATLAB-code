%% Data Preperation
N = size(X,1);
idx = randperm(N);
Ntrain = round(0.7*N);
Xtrain = X(idx(1:Ntrain),:);
Ytrain = Y(idx(1:Ntrain),:);
Xval   = X(idx(Ntrain+1:end),:);
Yval   = Y(idx(Ntrain+1:end),:);



% Xtrain = X(1:605,:);
% Ytrain = Y(1:605,:);
% Xval   = X(606:end,:);
% Yval   = Y(606:end,:);

%% Data Normalization
[Xtrain, normalizationParams_X] = zScoreNormalization(Xtrain, 'calculate');
Xtrain=Xtrain';
[Ytrain, normalizationParams_Y] = zScoreNormalization(Ytrain, 'calculate');
Ytrain=Ytrain';
[Xval, normalizationParams] = zScoreNormalization(Xval, 'usePredefined',normalizationParams_X.mean,normalizationParams_X.std);
Xval=Xval';
[Yval, normalizationParams] = zScoreNormalization(Yval, 'usePredefined',normalizationParams_Y.mean,normalizationParams_Y.std);Yval=Yval';

%% MLP
[model, y_pred_MLP] = MLP_reg_FN(Xtrain, Ytrain, Xval, Yval,"bayes")
 figure;densityScatter(Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean, y_pred_MLP.*normalizationParams_Y.std+normalizationParams_Y.mean)
% figure;densityScatter(Yval, y_pred_MLP)

title('MLP')
xlabel('In-situ TSM [g/m^3]')
ylabel('Predicted TSM [g/m^3]')

%% Accurancy metrics
% A separate file called AccurancyMetrics.m is required
% If you do not have it, leave this commented
% [R2_MLP RMSE_MLP Bias_MLP MAE_MLP cRMSE_MLP NRMSE_MLP NMAE_MLP NcRMSE_MLP ALL_Stats_MLP]= AccuracyMetrics(y_pred_MLP'.*normalizationParams_Y.std+normalizationParams_Y.mean, Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean)
%% MDN Auto
 [net, y_pred_MDN, bayesResults] = AutoMDN("bayesopt", [], [], 600,Xtrain, Ytrain, Xval, Yval);
 figure;densityScatter(Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean, y_pred_MDN'.*normalizationParams_Y.std+normalizationParams_Y.mean)
title('MDN Auto')
xlabel('In-situ Chl-a [mg/m^3]')
ylabel('Predicted Chl-a [mg/m^3]')
[R2_MDN RMSE_MDn Bias_MDN MAE_MDN cRMSE_MDN NRMSE_MDN NMAE_MDN NcRMSE_MDN ALL_Stats_MDN]= AccuracyMetrics(y_pred_MDN'.*normalizationParams_Y.std+normalizationParams_Y.mean, Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean)

%% RF All Features
 [y_pred_RF, model, featureInfo] = AutoRandomForest(Xtrain', Ytrain', Xval', Yval', [],"all")
  figure;densityScatter(Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean, y_pred_RF.*normalizationParams_Y.std+normalizationParams_Y.mean)
title('RF All Features')
xlabel('In-situ Chl-a [mg/m^3]')
ylabel('Predicted Chl-a [mg/m^3]')
[R2_RF RMSE_RF Bias_RF MAE_RF cRMSE_RF NRMSE_RF NMAE_RF NcRMSE_RF ALL_Stats_RF]= AccuracyMetrics(y_pred_RF.*normalizationParams_Y.std+normalizationParams_Y.mean, Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean)

%% RF All Auto Features
%  [Y_pred_val, model, featureInfo] = AutoRandomForest( ...
%     Xtrain', Ytrain', Xval', Yval', [],"auto")
%   figure;densityScatter(Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean, Y_pred_val.*normalizationParams_Y.std+normalizationParams_Y.mean)
% title('RF Auto Features')
%% SVM
  [y_pred_SVM, model, svmInfo] = AutoSVMRegression(Xtrain', Ytrain', Xval', Yval', [])
  figure;densityScatter(Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean, y_pred_SVM.*normalizationParams_Y.std+normalizationParams_Y.mean)
  title('SVM')
  xlabel('In-situ Chl-a [mg/m^3]')
ylabel('Predicted Chl-a [mg/m^3]')
  [R2_SVM RMSE_SVM Bias_SVM MAE_SVM cRMSE_SVM NRMSE_SVM NMAE_SVM NcRMSE_SVM ALL_Stats_SVM]= AccuracyMetrics(y_pred_SVM.*normalizationParams_Y.std+normalizationParams_Y.mean, Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean)

  %% Gradient boosting Regression
  [y_pred_GBR, model, gbInfo] = AutoGBRegression(Xtrain', Ytrain', Xval', Yval')
  figure;densityScatter(Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean, y_pred_GBR.*normalizationParams_Y.std+normalizationParams_Y.mean)
  title('GBR')
  xlabel('In-situ Chl-a [mg/m^3]')
ylabel('Predicted Chl-a [mg/m^3]')
  [R2_GBR RMSE_GBR Bias_GBR MAE_GBR cRMSE_GBR NRMSE_GBR NMAE_GBR NcRMSE_GBR ALL_Stats_GBR]= AccuracyMetrics(y_pred_GBR.*normalizationParams_Y.std+normalizationParams_Y.mean, Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean)

  %% Stepwise Quadratic
  [y_pred_Step, model, swInfo] = AutoStepwiseQuadratic(Xtrain', Ytrain', Xval', Yval')
    figure;densityScatter(Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean, y_pred_Step.*normalizationParams_Y.std+normalizationParams_Y.mean)
  title('Stepwise')
  xlabel('In-situ Chl-a [mg/m^3]')
ylabel('Predicted Chl-a [mg/m^3]')
[R2_Step RMSE_Step Bias_Step MAE_Step cRMSE_Step NRMSE_Step NMAE_Step NcRMSE_Step ALL_Stats_Step]= AccuracyMetrics(y_pred_Step.*normalizationParams_Y.std+normalizationParams_Y.mean, Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean)

%% Ensemble
k=5;
cv = PrepareKFolds(Xtrain', Ytrain', k);
y_pred_MLP_ensemble=[];Ytrain_ensemble=[];y_pred_MDN_ensemble=[];y_pred_RF_ensemble=[];y_pred_SVM_ensemble=[];y_pred_GBR_ensemble=[];y_pred_Step_ensemble=[];
for i=1:k;
[model, y_pred_MLP_temp] = MLP_reg_FN(cv(i).Xtrain', cv(i).Ytrain', cv(i).Xtest', cv(i).Ytest',"bayes");
y_pred_MLP_ensemble=[y_pred_MLP_ensemble;y_pred_MLP_temp'];
Ytrain_ensemble=[Ytrain_ensemble;cv(i).Ytest];y_pred_MLP_temp=[];
[net, y_pred_MDN_temp, bayesResults] = AutoMDN("bayesopt", [], [], 400,cv(i).Xtrain', cv(i).Ytrain', cv(i).Xtest', cv(i).Ytest');
y_pred_MDN_ensemble=[y_pred_MDN_ensemble;y_pred_MDN_temp'];
[y_pred_RF_temp, model, featureInfo] = AutoRandomForest(cv(i).Xtrain, cv(i).Ytrain, cv(i).Xtest, cv(i).Ytest, [],"all");
y_pred_RF_ensemble=[y_pred_RF_ensemble;y_pred_RF_temp];

[y_pred_SVM_temp, model, svmInfo] = AutoSVMRegression(cv(i).Xtrain, cv(i).Ytrain, cv(i).Xtest, cv(i).Ytest, []);
y_pred_SVM_ensemble=[y_pred_SVM_ensemble;y_pred_SVM_temp];

[y_pred_GBR_temp, model, gbInfo] = AutoGBRegression(cv(i).Xtrain, cv(i).Ytrain, cv(i).Xtest, cv(i).Ytest);
y_pred_GBR_ensemble=[y_pred_GBR_ensemble;y_pred_GBR_temp];
[y_pred_Step_temp, model, swInfo] = AutoStepwiseQuadratic(cv(i).Xtrain, cv(i).Ytrain, cv(i).Xtest, cv(i).Ytest);
y_pred_Step_ensemble=[y_pred_Step_ensemble;y_pred_Step_temp];
end
%% Ensemble data
Xtrain_ensemble=[y_pred_MLP_ensemble y_pred_MDN_ensemble y_pred_RF_ensemble y_pred_SVM_ensemble y_pred_GBR_ensemble y_pred_Step_ensemble];
Xval_ensemble=[y_pred_MLP' y_pred_MDN' y_pred_RF y_pred_SVM y_pred_GBR y_pred_Step];

[model, y_pred_ENSEMBLE] = MLP_reg_FN(Xtrain_ensemble(:,1:end-1)', Ytrain_ensemble', Xval_ensemble(:,1:end-1)', Yval,"bayes");
    figure;densityScatter(Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean, y_pred_ENSEMBLE'.*normalizationParams_Y.std+normalizationParams_Y.mean)
    title('Ensemble')
    xlabel('In-situ Chl-a [mg/m^3]')
ylabel('Predicted Chl-a [mg/m^3]')
[R2_Ens RMSE_Ens Bias_Ens MAE_Ens cRMSE_Ens NRMSE_Ens NMAE_Ens NcRMSE_Ens ALL_Stats_ENs]= AccuracyMetrics(y_pred_ENSEMBLE'.*normalizationParams_Y.std+normalizationParams_Y.mean, Yval'.*normalizationParams_Y.std+normalizationParams_Y.mean)
