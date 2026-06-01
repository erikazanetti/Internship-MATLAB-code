function densityScatter(x, y)
    % Check if x and y are the same length
    if length(x) ~= length(y)
        error('Vectors x and y must be of the same length.');
    end
    
    % Combine x and y into a 2D matrix
    data = [x(:), y(:)];
    
    % Use ksdensity to estimate the density of the points
    [density, ~] = ksdensity(data, data, 'Bandwidth', 0.1);
    
    % Normalize the density from 0 to 1
    density = (density - min(density)) / (max(density) - min(density));
    
    % Scatter plot with density as color
    scatter(x, y, 10, density, 'o', 'filled'); % Changed from '.' to 'o' and kept the size at 50
    colormap('jet'); % Use a jet colormap
    colorbar; % Show the colorbar
    ax = gca; % Get handle to the current axes
    ax.FontSize = 14; % Set the font size for axes labels and ticks
    hold on;
    
    % Calculate and plot the regression line
    coeffs = polyfit(x, y, 1);
    regY = polyval(coeffs, x);
    plot(x, regY, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Regression Line');
    
    % Add the 1:1 line
    xLimits = [min([x(:); y(:)]), max([x(:); y(:)])];
    plot(xLimits, xLimits, 'k--', 'LineWidth', 1.5, 'DisplayName', '1:1 Line');
    
    % Make the plot square with equal ranges for axes
    axis equal;
    xlim(xLimits);
    ylim(xLimits);
    
    % Add black border around the plot
    box on; % Turn on the plot box
    set(gca, 'LineWidth', 1.5, 'Box', 'on'); % Set black border (Box)
    
    % Calculate R^2 and RMSE
    ssRes = sum((y - regY).^2); % Residual sum of squares
    ssTot = sum((y - mean(y)).^2); % Total sum of squares
    rSquared = 1 - (ssRes / ssTot); % R^2
    rmse = sqrt(mean((y - regY).^2)); % RMSE
    
    % Display statistics on the plot
    nPoints = length(x);
    statsText = sprintf('R^2 = %.2f\nRMSE = %.2f\nN = %d', rSquared, rmse, nPoints);
    text(xLimits(1) + 0.05 * range(xLimits), xLimits(2) - 0.1 * range(xLimits), ...
        statsText, 'FontSize', 14, 'BackgroundColor', 'w');
    
    % Add labels, title, and legend
    xlabel('X','FontSize', 14);
    ylabel('Y','FontSize', 14);
    legend('show', 'Location', 'southeast');
    hold off;
end