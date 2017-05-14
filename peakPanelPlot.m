function peakPanelPlot(scanDate, scanNum, imgmat, imgmatz, peakpos)
    
    % Plot the final selected peaks
    % imgmat is the original diffraction image
    % imgmatz is the image with peaks intensities set to zero
    
    % Set the number of subplots per row and column in each main plot
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
            ROIView = imgmatz(pcx-10:pcx+10,pcy-10:pcy+10);
            ROI = imgmat(pcx-10:pcx+10,pcy-10:pcy+10);

            %save([scanDate,'_RotScan_',num2str(rdeg),'deg_','ROI',num2str(n),'.mat'],'ROI');

            ROIPeak = imgmat(pcx-1:pcx+1,pcy-1:pcy+1);
            PeakVal = round(sum(ROIPeak(:))/numel(ROIPeak));
            imagesc(ROIView,[0 1.25*max(ROI(:))]);
            title(['#',num2str(n),':',num2str(PeakVal)],'FontSize',12,'FontWeight','Bold');

        end

        colormap(jet)

        saveas(ha,[scanDate, '_Scan', num2str(scanNum)],'fig');
        saveas(ha,[scanDate, '_Scan', num2str(scanNum)],'tiff');
        saveas(ha,[scanDate, '_Scan', num2str(scanNum)],'png');

    end
    
end