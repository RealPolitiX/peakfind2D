function [fitresult, gof, smROI] = GaussFit(x, y, ROI)
    
    % Fit the ROI to a Gaussian
    
    [rlen, clen] = size(ROI);
    [xData, yData, zData] = prepareSurfaceData( x, y, ROI );

    [fltfit, ~] = fit([xData, yData], zData, 'loess');
    % Evaluate the smoothed ROI at each x and y
    smROI = feval(fltfit,x,y);

    [xData, yData, zData] = prepareSurfaceData( x, y, smROI );
    
    % Estimate initial conditions
    a_init = max(max(smROI));
    b_init = clen/2;
    c_init = rlen/2;
    d_init = prctile(smROI(:),10);
    x0_init = clen/2;
    y0_init = rlen/2;
    
    % Set up fittype and options
    ft = fittype( 'a*exp(-((x-x0)^2)/(2*b^2)-((y-y0)^2)/(2*c^2))+d', 'independent', {'x', 'y'}, 'dependent', 'z' );
    opts = fitoptions( ft );
    opts.Display = 'Off';
    opts.Lower = [0 0 0 -Inf -Inf -Inf];
    opts.Upper = [Inf Inf Inf Inf 2*clen 2*rlen];
    opts.StartPoint = [a_init b_init c_init d_init x0_init y0_init];

    % Fit model to data.
    [fitresult, gof] = fit( [xData, yData], zData, ft, opts );

    % % Plot fit with data.
    % figure( 'Name', 'ROI2' );
    % h = plot( fitresult, [xData, yData], zData );
    % legend( h, 'ROI2', 'ROI vs. x, y', 'Location', 'NorthEast' );
    % % Label axes
    % xlabel( 'x' );
    % ylabel( 'y' );
    % zlabel( 'ROI' );
    % grid on


