function peakpos = GaussfitFilter(scanDate, imgmat, svmax, runit, cunit)
    
    % Fitting constraints
    % r^2 > 0.8
    % row center position (rcent) within the size of the imagelet
    % column center position (ccent) within the size of the imagelet
    
    [rval, cval] = size(imgmat);
    rfitrad = ceil(runit/2);
    cfitrad = ceil(cunit/2);

    % Filtering peaks by Gaussian filter
    [~,maxind] = sort(svmax(:,3),'descend');
    [x, y] = meshgrid(1:cunit+1, 1:runit+1);
    
    % Initialize counter for satisfactory fits
    ctROI = 0;
    
    % Initialize matrix for storing fittin results
    peakpos = [];
    
    % Loop over all of previously selected peak candidates
    for m = 1:length(svmax)
        
        mx = svmax(maxind(m),1);
        my = svmax(maxind(m),2);

        % Set each ROI for fitting to be centered around a pre-selected peak
        leftlim = mx - rfitrad;
        rightlim = mx + rfitrad; 
        toplim = my - cfitrad;
        bottomlim = my + cfitrad;
        
        % Discard the candidates very close to the edge of the image
        if leftlim>0 && toplim>0 && rightlim<rval && bottomlim<cval
            
            ROI = imgmat(leftlim:rightlim, toplim:bottomlim);
            ROIView = ROI;
            
        end

        % Perform fitting to Gaussian
        [f,g,smROI] = GaussFit(x,y,ROI);
        ccent = double(int16(f.x0));
        rcent = double(int16(f.y0));

        % Impose fitting constraints for peak selection
        if g.rsquare>0.8 && ccent>0 && ccent<cunit+1 && rcent>0 && rcent<runit+1 && f.b>0 && f.b<runit && f.c>0 && f.c<cunit

            % If the fitting result satisfies the criteria, add counter by
            % 1 and store the ROI matrix
            ctROI = ctROI + 1;
            save(['ROI',num2str(ctROI),'_Fit.mat'],'f','g','ROI');

            % Plot fit with data (as 2D surface)
            [xData, yData, zData] = prepareSurfaceData( x, y, smROI );
            hfit = figure( 'Name', ['ROI',num2str(ctROI)] );
            set(hfit,'Position',[200 200 1300 500])
            subplot(1,5,[1 3]);
            h = plot( f, [xData, yData], zData );
            legend( h, ['ROI',num2str(ctROI),' fit'], ['ROI',num2str(ctROI),' data'], 'Location', 'NorthEast' );

            % Label axes
            xl = xlabel(['x (x_0=',num2str(f.x0),',\sigma_x=',num2str(f.b),')'],'FontSize',15,'FontWeight','Bold','rotation',15);
            set(xl, 'Units', 'Normalized', 'Position', [0.8, 0.05, 0.1]);
            yl = ylabel(['y (y_0=',num2str(f.y0),',\sigma_y=',num2str(f.c),')'],'FontSize',15,'FontWeight','Bold', 'rotation',-25);
            set(yl, 'Units', 'Normalized', 'Position', [0.1, 0.1, 0.1]);
            zlabel('ROI counts','FontSize',15,'FontWeight','Bold');
            title(['ROI',num2str(ctROI),' fit (R^2 = ',num2str(g.rsquare),')'],'FontSize',15,'FontWeight','Bold');
            grid on;
            set(gca,'FontWeight','bold');

            % Plot fitted region w/ the peak labeled (peak intensity set to 0 in display)
            ROIView(rcent,ccent) = 0;
            subplot(1,5,[4 5]);
            imagesc(ROIView,[0.98*prctile(ROI(:),3) 1.02*prctile(ROI(:),97)]);
            title(['ROI',num2str(ctROI)],'FontSize',12,'FontWeight','Bold');
            set(gca,'FontWeight','bold');
            %colormap(jet)

            % Save and close figures
            saveas(hfit,[scanDate,'_ROI',num2str(ctROI)],'fig');
            fr = getframe(gcf);
            [imgX, ~] = frame2im(fr);
            imwrite(imgX,[scanDate,'_ROI',num2str(ctROI),'.png']);
            close(hfit);

            % Convert relative peak positions into absolute row and column
            % positions in the whole image (peak_rPositionAbs & peak_cPositionAbs)
            peak_rPositionAbs = rcent-rfitrad+svmax(maxind(m),1)-1;
            peak_cPositionAbs = ccent-cfitrad+svmax(maxind(m),2)-1;
            
            % Store the fit results in the peakpos matrix
            peakpos(m,:) = [peak_rPositionAbs, peak_cPositionAbs, ROI(rcent,ccent)];

        end

    end

end