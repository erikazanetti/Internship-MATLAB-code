function [R2, RMSE, Bias, MAE, cRMSE, NRMSE, NMAE, NcRMSE, ALL_Stats] = AccuracyMetrics(y_pred, y_true)

% AccuracyMetrics computes common regression accuracy metrics.
%
% Inputs:
%   y_pred = predicted values
%   y_true = reference / observed values
%
% Outputs:
%   R2      = coefficient of determination
%   RMSE    = root mean square error
%   Bias    = mean error, i.e. mean(predicted - observed)
%   MAE     = mean absolute error
%   cRMSE   = centered RMSE
%   NRMSE   = normalized RMSE, in %
%   NMAE    = normalized MAE, in %
%   NcRMSE  = normalized centered RMSE, in %
%   ALL_Stats = table containing all metrics

% Make sure both inputs are column vectors
y_pred = y_pred(:);
y_true = y_true(:);

% Remove possible NaN values
valid = ~isnan(y_pred) & ~isnan(y_true);
y_pred = y_pred(valid);
y_true = y_true(valid);

% Error
error = y_pred - y_true;

% Basic metrics
Bias = mean(error);
RMSE = sqrt(mean(error.^2));
MAE = mean(abs(error));

% Coefficient of determination
R2 = 1 - sum(error.^2) / sum((y_true - mean(y_true)).^2);

% Centered RMSE
cRMSE = sqrt(mean((error - Bias).^2));

% Normalized metrics
% Here normalization is done using the range of observed values.
dataRange = max(y_true) - min(y_true);

NRMSE = RMSE / dataRange * 100;
NMAE = MAE / dataRange * 100;
NcRMSE = cRMSE / dataRange * 100;

% Output table
ALL_Stats = table(R2, RMSE, Bias, MAE, cRMSE, NRMSE, NMAE, NcRMSE);

end
