# peakfind2D
A peak-finding routine in Matlab for static and time-resolved (electron) diffraction images

### General steps (see [example](https://github.com/RealPolitiX/peakfind2D/tree/master/example)):
1. Load diffraction image
2. Apply median filter to the image to remove salt-and-pepper noise ([`medfilt2`](https://www.mathworks.com/help/images/ref/medfilt2.html))
3. Center-blocking ([`centerblock`](https://github.com/RealPolitiX/peakfind2D/blob/master/centerblock.m))
4. Disection of image matrix into small blocks of the same size ([`matsect`](https://github.com/RealPolitiX/peakfind2D/blob/master/matsect.m))
5. Find the region with potential peaks (peak candidates) according to ranking of summed intensity ([`findPeakCandidates`](https://github.com/RealPolitiX/peakfind2D/blob/master/findPeakCandidates.m))
6. Apply distance filter to the peak candidates ([`distanceFilter`](https://github.com/RealPolitiX/peakfind2D/blob/master/distanceFilter.m))
7. Apply Gaussian filter to the peak candidates 1-2 times ([`GaussfitFilter`](https://github.com/RealPolitiX/peakfind2D/blob/master/GaussfitFilter.m))
8. Calculate the averaged intensity of a number of pixels around the peak ([`avgnearest`](https://github.com/RealPolitiX/peakfind2D/blob/master/avgnearest.m))


### Visualization of results (see [example](https://github.com/RealPolitiX/peakfind2D/tree/master/example) below):
N.B. the intensity at the peak locations are set to zero for better illustration in the visualization functions
1. Peak-location-annotated images ([`peakLocationPlot`](https://github.com/RealPolitiX/peakfind2D/blob/master/peakLocationPlot.m))
![Si electron diffraction pattern](https://github.com/RealPolitiX/peakfind2D/blob/master/example/Img_wPeakAnnotation_BW.png)
2. Panel plot of all found peaks ([`peakPanelPlot`](https://github.com/RealPolitiX/peakfind2D/blob/master/peakPanelPlot.m))
![Peak gallery #1](https://github.com/RealPolitiX/peakfind2D/blob/master/example/2000-00-00_Scan1_PeakGallery_1.png)
![Peak gallery #2](https://github.com/RealPolitiX/peakfind2D/blob/master/example/2000-00-00_Scan1_PeakGallery_2.png)
![Peak gallery #3](https://github.com/RealPolitiX/peakfind2D/blob/master/example/2000-00-00_Scan1_PeakGallery_3.png)
