# peakfind2D
A peak-finding routine in Matlab for diffraction images

### General steps:
1. Center-blocking (centerblock)
2. Disection of image matrix into small blocks of the same size (matsect)
3. Find the region with potential peaks according to ranking of summed intensity (findPeakCandidates)
4. Apply distance filter to the candidates (distanceFilter)
5. Apply Gaussian filter to the candidates 1-2 times (GaussianFilter)
6. Calculate the averaged intensity of a number of pixels around the peak (avgnearest)


### Visualization of results:
1. Peak-location-annotated images (peakLocationPlot)
2. Panel plot of all found peaks (peakPanelPlot)

N.B. the intensity at the peak locations are set to zero for better illustration in the visualization functions
