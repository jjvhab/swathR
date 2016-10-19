# swathR
generalized swath-profiles with R

# v.0.4 - README

---------------------
### Description:

Calculate swath-profile values perpendicular to a *straight* baseline. The baseline is generated between two user-defined points (X|Y), see argument 'coords'. The distance between samples and the number of samples can be specified, see arguments 'k' and 'dist'. Values of the swath-profile are extracted from a given raster file, see argument 'raster'. CRS of raster and points have to be identical.

---------------------
### Arguments:

+ coords = matrix(ncol=2, nrow=2) with x and y coordinates of beginning and end point of the baseline; each point in one row
 + column 1: xcoordinates
 + column 2: ycoordinates
+ raster = raster file (loaded with raster() from package 'raster')
+ k = integer; number of lines on each side of the baseline
+ dist = numeric; distance between lines
+ crs = string; CRS
+ method = string; method for extraction of raw data, see extract() from package 'raster'; default value: 'bilinear'

---------------------
### Required packages:

'sp', 'rgeos', 'raster'
