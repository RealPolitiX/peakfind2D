function peakpos = GaussfitFilter(scanDate, imgmat, svmax, runit, cunit)
    
    rfitrad = ceil(runit/2);
    cfitrad = ceil(cunit/2);

    % Filtering peaks by Gaussian filter
    [~,maxind] = sort(svmax(:,3),'descend');
    [x, y] = meshgrid(1:runit+1,1:cunit+1);
    
    % Initialize counter for passable fits
    ctROI = 0;
    
    % Initialize matrix for storing fittin results
    peakpos = [];
    
    % Loop over all of previously selected peaks
    for m = 1:length(svmax)

        my = svmax(maxind(m),2);
        mx = svmax(maxind(m),1);

        % Set each ROI for fitting to be centered around a pre-selected peak
        ROI = imgmat(mx-rfitrad:mx+rfitrad, my-cfitrad:my+cfitrad);
        ROIView = ROI;

        % Perform fitting to Gaussian
        [f,g,smROI] = GaussFit(x,y,ROI);
        ccent = double(int16(f.x0));
        rcent = double(int16(f.y0));

        % Impose fitting constraints for peak selection
        if g.rsquare>0.8 && ccent>0 && ccent<21 && rcent>0 && rcent<21 && f.b>0 && f.b<20 && f.c>0 && f.c<20

            % If the fitting result passes the criteria, add counter by 1
            % and store the ROI matrix
            ctROI = ctROI + 1;
            save(['ROI',num2str(ctROI),'_Fit.mat'],'f','g','smROI');

            % Plot fit with data (as 2D surface)
            [xData, yData, zData] = prepareSurfaceData( x, y, smROI );
            hfit = figure( 'Name', ['ROI',num2str(ctROI)] );
            set(hfit,'Position',[100 100 1300 500])
            subplot(1,5,[1 3]);
            h = plot( f, [xData, yData], zData );
            legend( h, ['ROI',num2str(ctROI),' fit'], ['ROI',num2str(ctROI),' data'], 'Location', 'NorthEast' );

            % Label axes
            xlabel(['x (x_0=',num2str(f.x0),',\sigma_x=',num2str(f.b),')'],'FontSize',15,'FontWeight','Bold');
            ylabel(['y (y_0=',num2str(f.y0),',\sigma_y=',num2str(f.c),')'],'FontSize',15,'FontWeight','Bold');
            zlabel('ROI counts','FontSize',15,'FontWeight','Bold');
            title(['ROI',num2str(ctROI),' fit (R^2 = ',num2str(g.rsquare),')'],'FontSize',15,'FontWeight','Bold');
            grid on;
            set(gca,'FontWeight','bold');

            % Plot fitted region w/ the peak labeled (set to 0 in display)
            ROIView(rcent,ccent) = 0;
            subplot(1,5,[4 5]);
            imagesc(ROIView,[0 1.25*max(max(ROI))]);
            title(['ROI',num2str(ctROI)],'FontSize',12,'FontWeight','Bold');
            set(gca,'FontWeight','bold');

            % Save and close figures
            saveas(hfit,[scanDate,'_ROI',num2str(ctROI)],'fig');
            fr = getframe(gcf);
            [imgX, ~] = frame2im(fr);
            imwrite(imgX,[scanDate,'_ROI',num2str(ctROI),'.png']);
            close(hfit);

            % Store the fit results in the peakpos matrix
            peakpos(m,:) = [rcent-11+svmax(maxind(m),1), ccent-11+svmax(maxind(m),2), ROI(rcent,ccent)];

        end

    end

end