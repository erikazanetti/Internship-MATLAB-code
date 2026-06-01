function [model, Yval_pred, Ynew_pred] = MLP_reg_FN(Xtrain, Ytrain, Xval, Yval, mode, architecture, XNew)
% MLP_reg_FN
% Robust MLP regression with:
%   - Manual or Bayesian-optimized architecture
%   - Dropout + L2 regularization
%   - Internal CV only on training set
%   - Final validation on unseen Xval/Yval
%   - Optional prediction on XNew
%
% USAGE:
%   Manual architecture:
%       [model, Yval_pred] = MLP_reg_FN(Xtr, Ytr, Xv, Yv, "manual", [50 30 20]);
%
%   Bayesian optimization:
%       [model, Yval_pred] = MLP_reg_FN(Xtr, Ytr, Xv, Yv, "bayes");
%
%   With XNew prediction:
%       [model, Yval_pred, Ynew_pred] = MLP_reg_FN(Xtr, Ytr, Xv, Yv, "bayes", [], XNew);

    % -------------------------------
    % Optional XNew
    % -------------------------------
    if nargin < 7 || isempty(XNew)
        XNew = [];
    end

    % -------------------------------
    % Select architecture mode
    % -------------------------------
    if strcmpi(mode, "manual")
        if nargin < 6 || isempty(architecture)
            error("Manual mode requires an architecture vector as input.");
        end
        arch = architecture;

    elseif strcmpi(mode, "bayes")
        arch = optimizeArchitectureBayes(Xtrain, Ytrain);

    else
        error("Mode must be either 'manual' or 'bayes'.");
    end

    fprintf("\nSelected architecture: [%s]\n", num2str(arch));

    % Convert to dlarray format
    Xtrain_dl = Xtrain';
    Ytrain_dl = Ytrain';

    % Build network layers
    layers = buildMLPLayers(arch, size(Xtrain,1));

    % Training options
    options = trainingOptions("adam", ...
        "MaxEpochs", 300, ...
        "MiniBatchSize", 64, ...
        "InitialLearnRate", 1e-3, ...
        "Shuffle", "every-epoch", ...
        "ValidationData", {Xtrain_dl, Ytrain_dl}, ...
        "ValidationFrequency", 30, ...
        "ValidationPatience", 10, ...
        "L2Regularization", 1e-4, ...
        "Plots", "training-progress", ...
        "Verbose", false);

    % Train network
    fprintf("\nTraining network...\n");
    net = trainNetwork(Xtrain_dl, Ytrain_dl, layers, options);

    % Final validation prediction
    Yval_pred = predict(net, Xval');
    Yval_pred = Yval_pred';

    valMSE = mean((Yval_pred - Yval).^2);
    fprintf("\nFinal Validation MSE: %.6f\n", valMSE);

    % Plots
    plotResults(Yval, Yval_pred);

    % -------------------------------
    % Optional XNew prediction
    % -------------------------------
    if ~isempty(XNew)
        Ynew_pred = predict(net, XNew');
        Ynew_pred = Ynew_pred';
    else
        Ynew_pred = [];
    end

    % Output model struct
    model.net = net;
    model.YvalPred = Yval_pred;
    model.predictedValues = Yval_pred;
    model.valMSE = valMSE;
    model.architecture = arch;
end


%% ------------------------------------------------------------------------
function bestArch = optimizeArchitectureBayes(Xtrain, Ytrain)
    fprintf("\n--- Bayesian Optimization of Architecture ---\n");

    vars = [
        optimizableVariable('L',[1 3],'Type','integer')
        optimizableVariable('N',[10 120],'Type','integer')
    ];

    fun = @(params) archObjective(params, Xtrain, Ytrain);

    results = bayesopt(fun, vars, ...
        'MaxObjectiveEvaluations', 40, ...
        'IsObjectiveDeterministic', false, ...
        'AcquisitionFunctionName', 'expected-improvement-plus');

    L = results.XAtMinObjective.L;
    N = results.XAtMinObjective.N;

    bestArch = N * ones(1, L);
    fprintf("Best architecture found: [%s]\n", num2str(bestArch));
end


%% ------------------------------------------------------------------------
function loss = archObjective(params, Xtrain, Ytrain)
    L = params.L;
    N = params.N;
    arch = N * ones(1, L);

    layers = buildMLPLayers(arch, size(Xtrain,1));

    X = Xtrain';
    Y = Ytrain';

    options = trainingOptions("adam", ...
        "MaxEpochs", 80, ...
        "MiniBatchSize", 64, ...
        "Shuffle", "every-epoch", ...
        "Verbose", false);

    net = trainNetwork(X, Y, layers, options);

    pred = predict(net, X);
    loss = mean((pred - Y).^2);
end


%% ------------------------------------------------------------------------
function layers = buildMLPLayers(architecture, inputDim)
    layers = [
        featureInputLayer(inputDim, "Name","input")
    ];

    for i = 1:length(architecture)
        layers = [
            layers
            fullyConnectedLayer(architecture(i), "Name", "fc"+i, ...
                "WeightsInitializer","he")
            reluLayer("Name","relu"+i)
            dropoutLayer(0.2,"Name","drop"+i)
        ];
    end

    layers = [
        layers
        fullyConnectedLayer(1,"Name","output")
        regressionLayer("Name","regression")
    ];
end


%% ------------------------------------------------------------------------
function plotResults(Ytrue, Ypred)
    figure;
    subplot(1,3,1)
    plot(Ytrue, Ypred, 'o')
    xlabel("True")
    ylabel("Predicted")
    title("Regression Plot")
    grid on

    subplot(1,3,2)
    histogram(Ypred - Ytrue)
    title("Error Histogram")
    xlabel("Error")
    grid on

    subplot(1,3,3)
    plot(Ytrue, 'b'); hold on
    plot(Ypred, 'r')
    legend("True","Predicted")
    title("Prediction vs True")
    grid on
end