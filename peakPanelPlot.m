function peakPanelPlot(scanDate, scanNum, imgmat, imgmatz, peakpos, runit, cunit)
    
    % Plot the final selected peaks
    % imgmat is the original diffraction image
    % imgmatz is the image with peaks intensities set to zero
    
    rrad = ceil(runit/2);
    crad = ceil(cunit/2);
    
    % Set the number of subplots per row (rsubplt) and column (csubplt) in each main plot
    npks = size(peakpos,1);
    rsubplt = 4; csubplt = 5;
    nsubplt = rsubplt*csubplt;
    BlockVal = 0:nsubplt:ceil(npks/nsubplt)*nsubplt;

    % Loop main plots
    for nb = 1:length(BlockVal) - 1

        ha = figure;
        set(ha,'Position',[100 100 1000 800]);

        % Loop over the image block (imglet) in each main plot
        for n = (BlockVal(nb)+1):min([BlockVal(nb+1), npks])

            pcy = peakpos(n,2);
            pcx = peakpos(n,1);

            subplot(rsubplt, csubplt, n-BlockVal(nb))
            ROIView = imgmatz(pcx-rrad:pcx+rrad,pcy-crad:pcy+crad);
            ROI = imgmat(pcx-rrad:pcx+rrad,pcy-crad:pcy+crad);

            ROIPeak = imgmat(pcx-1:pcx+1,pcy-1:pcy+1);
            PeakVal = round(sum(ROIPeak(:))/numel(ROIPeak));
            
            % Plot image with custom color scaling
            imagesc(ROIView,[0.98*prctile(ROI(:),3) 1.02*prctile(ROI(:),97)]);
            title(['#',num2str(n),':',num2str(PeakVal)],'FontSize',12,'FontWeight','Bold');
            
            % Remove the ticks and labels in the x & y axes
            set(gca,'XTick',[],'YTick',[],'TickLength',[0 0])
            axis equal
            % colormap(jet)

        end

        saveas(ha,[scanDate, '_Scan', num2str(scanNum), '_', num2str(nb)],'fig');
        saveas(ha,[scanDate, '_Scan', num2str(scanNum), '_', num2str(nb)],'tiff');
        saveas(ha,[scanDate, '_Scan', num2str(scanNum), '_', num2str(nb)],'png');

    end
    
end