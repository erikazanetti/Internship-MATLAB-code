function [normalizedData, normalizationParams] = zScoreNormalization(data, method, meanValues, stdValues)
    % Inputs:
    % data: Matrix where each row is a sample, and each column is a feature
    % method: 'calculate' or 'usePredefined'
    % meanValues: Mean values for each feature (required if method is 'usePredefined')
    % stdValues: Standard deviation for each feature (required if method is 'usePredefined')

    % Outputs:
    % normalizedData: Data after Z-score normalization
    % normalizationParams: Struct containing 'mean' and 'std' values

    normalizationParams = struct(); % Initialize output struct

    if strcmpi(method, 'calculate')
        % Calculate mean and standard deviation from the provided data
        mu = mean(data, 1); % Mean of each feature (column-wise)
        sigma = std(data, 1); % Standard deviation of each feature (column-wise)

        % Normalize the data
        normalizedData = (data - mu) ./ sigma;

        % Save normalization parameters
        normalizationParams.mean = mu;
        normalizationParams.std = sigma;

        % Display normalization parameters for reference
        disp('Calculated normalization parameters:');
        disp('Mean:');
        disp(mu);
        disp('Standard Deviation:');
        disp(sigma);

    elseif strcmpi(method, 'usePredefined')
        if nargin < 4
            error('When using "usePredefined", both meanValues and stdValues must be provided.');
        end
        
        % Use predefined mean and standard deviation
        mu = meanValues;
        sigma = stdValues;

        % Normalize the data
        normalizedData = (data - mu) ./ sigma;

        % Save predefined normalization parameters
        normalizationParams.mean = mu;
        normalizationParams.std = sigma;

    else
        error('Invalid method! Use "calculate" or "usePredefined".');
    end
end