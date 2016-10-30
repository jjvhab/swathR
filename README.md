# swathR
generalized swath-profiles with R

# v.1.0.1 - README

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
### Required packages & References:

**rgeos:**
Bivand, R., Rundel, C., Pebesma, E., & Hufthammer, K. O. (2015). rgeos: Interface to Geometry 
 Engine - Open Source (GEOS) (Version 0.3-15). 
 Retrieved from https://cran.r-project.org/web/packages/rgeos/index.html

**raster:**
Hijmans, R. J., Etten, J. van, Cheng, J., Mattiuzzi, M., Sumner, M., Greenberg, J. A., … 
 Shortridge, A. (2015). raster: Geographic Data Analysis and Modeling (Version 2.5-2). 
 Retrieved from https://cran.r-project.org/web/packages/raster/index.html

**sp:**
Pebesma, E., Bivand, R., Rowlingson, B., Gomez-Rubio, V., Hijmans, R., Sumner, M., … O’Brien,
 J. (2015). sp: Classes and Methods for Spatial Data (Version 1.2-1). 
 Retrieved from https://cran.r-project.org/web/packages/sp/index.html

---------------------
### MIT License

or cite via DOI on [Zenodo](https://zenodo.org/search?page=1&size=20&q=swathR)
