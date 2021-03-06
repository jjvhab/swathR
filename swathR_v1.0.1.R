# swathR v1.0.1 by V.Haburaj

### Description:
#---------------------
# Calculate swath-profile values perpendicular to a straight baseline. The 
# baseline is generated between two user-defined points (X|Y), see argument 
# 'coords'. The distance between samples and the number of samples can be 
# specified, see arguments 'k' and 'dist'. Values of the swath-profile are 
# extracted from a given raster file, see argument 'raster'. CRS of raster 
# and points have to be the same.

### Arguments:
#---------------------
# coords = matrix(ncol=2, nrow=2) with x and y coordinates of beginning and end point of
#           the baseline; each point in one row
#           column 1: xcoordinates
#           column 2: ycoordinates
# raster = raster file (loaded with raster() from package 'raster')
# k = integer; number of lines on each side of the baseline
# dist = numeric; distance between lines
# crs = string; CRS
# method = string; method for extraction of raw data, see extract() from package 'raster';
#           default value: 'bilinear'

### Required packages:
#---------------------
# install.packages('sp', dependencies=T)
# install.packages('rgeos', dependencies=T)
# install.packages('raster', dependencies=T)

### Function:
#---------------------
swathR <- function(coords, raster, k, dist, crs, method) {
    library(sp)
    library(rgeos)
    library(raster)
    message('Initializing ...')
    # set default method:
    if (missing(method)) {
        method <- 'bilinear'
    }
    # create SpatialPoints from coords:
    spt <- SpatialPoints(coords, proj4string = CRS(crs))
    # get slope of baseline:
    m <- (ymin(spt[1]) - ymin(spt[2])) / (xmin(spt[1]) - xmin(spt[2]))
    # get slope of normal function:
    m1 <- - (1/m)
    # get slope-angle from slope:
    alpha <- atan(m)
    alpha1 <- atan(m1)
    # get deltax and deltay from pythagoras:
    if ((alpha*180)/pi < 90 & (alpha*180)/pi > 270) {
        deltax <- cos(alpha1) * dist
    } else deltax <- cos(alpha1) * dist * -1
    if ((alpha*180)/pi > 0  & (alpha*180)/pi < 180) {
        deltay <- sqrt(dist**2 - deltax**2)
    } else deltay <- sqrt(dist**2 - deltax**2) * -1
    # create empty matrix:
    swath <- matrix(nrow = k*2+1, ncol = 8)
    colnames(swath) <- c('distance', 'mean', 'median',
                         'std.dev.', 'min', 'max', 'quantile(25)', 'quantile(75)')
    # list for spatial lines:
    allLines <- list()
    # add baseline:
    allLines[[k+1]] <- spLines(coords, crs=crs)
    # set distance for baseline:
    swath[k+1, 1] <- 0
    # generate k lines parallel to baseline:
    for (n in 1:k) {
        # BELOW BASELINE:
        # new points
        cn <- matrix(nrow=2, ncol=2)
        cn[1,] <- cbind(coords[1,1] - (deltax * n), coords[1,2] - (deltay * n))
        cn[2,] <- cbind(coords[2,1] - (deltax * n), coords[2,2] - (deltay * n))
        # line between points:
        allLines[[k+1-n]] <- spLines(cn, crs=crs)
        # distance value:
        swath[k+1-n,1] <- -1*n*dist
        # ABOVE BASELINE:
        # new points
        cn <- matrix(nrow=2, ncol=2)
        cn[1,] <- cbind(coords[1,1] + (deltax * n), coords[1,2] + (deltay * n))
        cn[2,] <- cbind(coords[2,1] + (deltax * n), coords[2,2] + (deltay * n))
        # line between points:
        allLines[[k+n+1]] <- spLines(cn, crs=crs)
        # distance value:
        swath[k+n+1, 1] <- n*dist
    }
    # get raw data:
    message('Extracting raw data (this may take some time) ...')
    raw.data <- sapply(allLines, FUN=function(x) {extract(raster, x, method=method)})
    # generalise data:
    message('Generalising data ...')
    swath[,2] <- sapply(raw.data, function(x) {mean(x, na.rm = T)})
    swath[,3] <- sapply(raw.data, function(x) {median(x, na.rm = T)})
    swath[,4] <- sapply(raw.data, function(x) {sd(x, na.rm = T)})
    swath[,5] <- sapply(raw.data, function(x) {min(x, na.rm = T)})
    swath[,6] <- sapply(raw.data, function(x) {max(x, na.rm = T)})
    swath[,7] <- sapply(raw.data, function(x) {quantile(x, na.rm = T)[2]})
    swath[,8] <- sapply(raw.data, function(x) {quantile(x, na.rm = T)[4]})
    # return results:
    results <- list(swath, raw.data, allLines)
    message('Operation finished successfully!')
    message('Structure of results (list): [[1]] swath profile data (matrix, numeric), [[2]] raw data (list, numeric), [[3]] generated lines (list, spLines)')
    return(results)
} 


### References:
#---------------------
# citation('rgeos')
# Bivand, R., Rundel, C., Pebesma, E., & Hufthammer, K. O. (2015). rgeos: Interface to Geometry 
# Engine - Open Source (GEOS) (Version 0.3-15). 
# Retrieved from https://cran.r-project.org/web/packages/rgeos/index.html

# citation('raster')
# Hijmans, R. J., Etten, J. van, Cheng, J., Mattiuzzi, M., Sumner, M., Greenberg, J. A., … 
# Shortridge, A. (2015). raster: Geographic Data Analysis and Modeling (Version 2.5-2). 
# Retrieved from https://cran.r-project.org/web/packages/raster/index.html

# citation('sp')        
# Pebesma, E., Bivand, R., Rowlingson, B., Gomez-Rubio, V., Hijmans, R., Sumner, M., … O’Brien,
# J. (2015). sp: Classes and Methods for Spatial Data (Version 1.2-1). 
# Retrieved from https://cran.r-project.org/web/packages/sp/index.html
