% Time: 2017
% Author: R. Patrick Xian

clear all;clc;

% Load image
load('Si_pattern.mat');

%%
% Apply median filter to remove salt-and-pepper noise
img = medfilt2(imgload, [4 4]);

% Set fitting parameters
scanNum = 1;
scanDate = '2000-00-00';
rrad = 30; crad = 30;
rcent = 342; ccent = 370;
runit = 20; cunit = 20;
ntop = 1000; dist = sqrt(2)*30;

% Block the center of the diffraction pattern (0,0,0) with an ellipse
imgdcent = centerblock(img, rcent, ccent, rrad, crad);

% Disect center-blocked image matrix into smaller pieces
blkmat = matsect(imgdcent, runit, cunit);

% Plot center-blocked diffraction image
h = figure;
set(h,'Position',[2 2 800 800]);
imagesc(imgdcent,[0 18000])

% Find the brightest pixels in the top n (ntop) image blocks sorted by collective intensity
maxmat = findPeakCandidates(blkmat, ntop);

% Sieving by distance
svmax = distanceFilter(imgdcent, maxmat, dist);

%%
% Plot located peaks
peakLocationPlot(imgload, svmax, 0.05);

%%
% First round of filtering by fitting to a Gaussian
peakpos = GaussfitFilter(scanDate, imgload, svmax, runit, cunit);

%%
% Discard the deselected peaks
peakpos = peakpos(peakpos(:,3) ~= 0,:);
%save([scanDate, '_peakpos_1st_filtering.mat'], 'peakpos');

%%
% Second round of filtering by fitting to a Gaussian
peakpos2 = GaussfitFilter(scanDate, imgload, peakpos, runit, cunit);

%%
% Remove the non-peaks from Gaussian fitting results
peakpos2 = peakpos2(peakpos2(:,3) ~= 0,:);
%save([scanDate, '_peakpos_2nd_filtering.mat'], 'peakpos');

%%
% Plot the latest locations of peaks
imgpks = peakLocationPlot(imgload, peakpos2, 0.05);

%%
% Augment peakpos matrix by one columns of zeros
peakpos2 = [peakpos2 zeros(length(peakpos2),2)];

% Calculate the 9- and 25-pixel average of each found peak
for i = 1:size(peakpos2,1)
    
    peakpos2(i,4) = avgnearest(img, peakpos(i,1), peakpos(i,2), 1, 1);
    peakpos2(i,5) = avgnearest(img, peakpos(i,1), peakpos(i,2), 2, 2);
    
end

%%
% Plot the final selected peaks
peakPanelPlot(scanDate, scanNum, imgload, imgpks, peakpos2, runit, cunit)