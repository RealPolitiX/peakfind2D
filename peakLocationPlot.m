function imgmatz = peakLocationPlot(imgmat, svmax)

    % Label selected 2D peaks on diffraction pattern
    
    % Sort peaks by their intensity
    [~,maxind] = sort(svmax(:,3),'descend');
    
    % Temporarily set all peaks intensities to zero (for annotation in plot)
    for k = 1:length(svmax)
        imgmat(svmax(maxind(k),1),svmax(maxind(k),2)) = 0;
    end
    
    % BW plot with peak annotation
    hpk = figure;
    set(hpk,'Position',[2 2 850 800]);
    imshow(-imgmat,[-2000 0]);
    hold on
    
    for k = 1:length(svmax)
        
        rectangle('Position',[svmax(maxind(k),2)-4,svmax(maxind(k),1)-4,8,8],'LineWidth',1.5,'EdgeColor','c');%[204 122 83]/255
        text(svmax(maxind(k),2)-4,svmax(maxind(k),1)-8,num2str(k),'FontSize',9,'FontWeight','bold','Color',[205,133,63]/255);
    
    end
    
    hold off
    %xlim([142 817]);
    %ylim([90 692]);
    
    % Color plot with peak annotation
    hpkbw = figure;
    set(hpkbw,'Position',[2 2 850 800]);
    imagesc(imgmat,[0 2000])
    
    for k = 1:length(svmax)
        
        rectangle('Position',[svmax(maxind(k),2)-4,svmax(maxind(k),1)-4,8,8],'LineWidth',1.5,'EdgeColor','k');
        text(svmax(maxind(k),2)-4,svmax(maxind(k),1)-8,num2str(k),'FontSize',9,'FontWeight','bold','Color',[0 0.5 0]);
    
    end
    
    hold off
    colormap(jet)
    
    % Return image with peak centers set to zero
    imgmatz = imgmat;

end