---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.8.0
  kernelspec:
    display_name: R
    language: R
    name: ir
---

<!-- #region kernel="SoS" -->
# <b style="color:red; font-family:verdana">Raster Data Model</b>
<!-- #endregion -->

<!-- #region kernel="SoS" -->
<br>
<b style="font-family:Fantasy">Giuliano Langella</b> &nbsp; &nbsp;
<b style="font-family:Arial">glangella@unina.it</b>

<b>Tobler's Low of Geography (1970): <br><em>$\quad$ "Everything is related to everything else, but near things are more related than distant things".</em></b>
<!-- #endregion -->

<!-- #region kernel="SoS" -->
### <b style="color:#929292">Useful links</b>
https://cran.r-project.org/doc/contrib/intro-spatial-rl.pdf <br>
http://www.rspatial.org <br>
http://pakillo.github.io/R-GIS-tutorial/#iovec <br>
https://rspatial.org/raster/spatial/6-crs.html <br>
<!-- #endregion -->

```R hideCode=false kernel="R" tags=[] jupyter={"source_hidden": true}
library(repr)  # to size plots within Jupyter
options(repr.plot.width = 8)
```

<!-- #region kernel="R" -->
---
<!-- #endregion -->

<!-- #region kernel="R" -->
## <b style="color:orange">Coordinate Reference Systems</b>
<!-- #endregion -->

---

<!-- #region kernel="R" -->
### Read  <b style="color:green">chapter 09 </b>of following link
<!-- #endregion -->

[Intro to GIS and Spatial Analysis > Ch.9 - Coordinate Systems](https://mgimond.github.io/Spatial/chp09_0.html)


---

<!-- #region kernel="R" toc-hr-collapsed=true toc-hr-collapsed=true -->
## <b style="color:orange">Raster data model</b>
<!-- #endregion -->

---

<!-- #region kernel="R" -->
### Schematic <b style="color:green">representation</b> of a raster
<!-- #endregion -->

<!-- #region kernel="R" -->
<img src="../../../artwork/Raster_data_matadata.gif" alt="raster schema">
<!-- #endregion -->

<!-- #region kernel="R" -->
We can distinguish **two blocks** in a raster (also called grid):<br>
 - <b style="color:#0044ff; font-size:16px; font-family:American Typewriter">metadata</b>, such as
   - class, e.g. SpatRaster (&rarr; terra; RasterLayer &rarr; raster)
   - size, e.g. 3264 x 4800 pixels (nrows x ncols)
   - resolution, e.g. 5 meters (synonims are CELLSIZE, PIXELSIZE)
   - extent / bounding box (xmin, xmax, ymin, ymax)
   - crs (a geographic or projected coordinate system, generally in the proj4 format or EPSG code)
   - no data value, e.g. -9999 (synonims are NODATAVALUE, NODATA)
   - source (location of file on hard disk, such as ../docente_Langella/Raster-Data/dem5m_vt.tif)
 - <b style="color:#0044ff; font-size:16px; font-family:American Typewriter">data</b>, that is a matrix (=grid) of cells (=pixels)
   - the grid of cells has size nrows x ncols
   - each cell in a grid store one numeric value (e.g. integer or double number)
   - (we can have multiple layers as depicted in the multidimensional raster data representaion)
<!-- #endregion -->

<!-- #region kernel="R" -->
### import <b style="color:green">raster</b> | example: D.E.M.
<!-- #endregion -->

```R kernel="R"
# The command ?raster search for raster string in the documentation.  If the raster package is not loaded in R, the command below gives a warning that
# nothing was found.
?raster
```

```R kernel="R"
library(raster)  # load the raster package in R
```

```R kernel="R"
# The command below open the documentation of the raster function of the raster package in the help:
?raster
```

```R kernel="R"
getwd()
```

<!-- #region kernel="R" -->
#### Import (i.e. read) a raster
<!-- #endregion -->

<!-- #region kernel="R" -->
One of the most common rasters used worldwide is the one storing the elevation of each point of land surface.<br>
This kind of raster is called D.E.M., that is Digital Elevation Model.<br>
The raster has the data matrix in which each pixel stores the value of elevation of that surface on Earth.
<!-- #endregion -->

```R kernel="R"
dem <- raster("../exercises/docente_Langella/Raster-Data/dem5m_vt.tif")
```

```R kernel="R"
class(dem)
```

```R kernel="R"
hasValues(dem)
```

<!-- #region kernel="R" -->
##### Plot raster
<!-- #endregion -->

```R kernel="R"
spplot(dem, main = "Elevation in Telesina Valley")
```

<!-- #region kernel="R" -->
#### <b style="color:blue">Metadata</b>
<!-- #endregion -->

<!-- #region kernel="R" -->
##### Print the dem <b style="color:blue">metadata</b>
<!-- #endregion -->

```R kernel="R"
dem
```

<!-- #region kernel="R" -->
##### Bounding Box
<!-- #endregion -->

```R kernel="R"
extent(dem)
```

```R kernel="R"
bbox(dem)
```

```R hideCode=true hideOutput=true hidePrompt=true kernel="R"
xmin <- 453000  # metri
ymin <- 4556000  # metri
xmax <- 477000  # metri
ymax <- 4572320  # metri
```

```R hideCode=true jupyter={"source_hidden": true} kernel="MATLAB" tags=["hide-input"]
%get xmin ymin xmax ymax --from R
line( [xmin,xmin],[ymin,ymax], 'color','b' ) % left
line( [xmin,xmax],[ymin,ymin], 'color','b' ) % bottom
line( [xmax,xmax],[ymin,ymax], 'color','b' ) % right
line( [xmin,xmax],[ymax,ymax], 'color','b' ) % bottom
text(xmin+(xmax-xmin)/2,ymin+(ymax-ymin)/2,'Bounding Box','color','b',...
     'HorizontalAlignment','center','VerticalAlignment','bottom',...
     'Fontsize',20)
%text(xmin,ymin+(ymax-ymin)/2,'xmin',...
%     'color','m','Fontsize',12,'HorizontalAlignment','left')
text(xmin,ymin+(ymax-ymin)/2,{'xmin'; num2str(xmin)},...
     'color','m','Fontsize',12,'HorizontalAlignment','right')
text(xmax,ymin+(ymax-ymin)/2,{'xmax';num2str(xmax)},...
     'color','m','Fontsize',12,'HorizontalAlignment','left')
text(xmin+(xmax-xmin)/2,ymin,['ymin ',num2str(ymin)],...
     'color','m','Fontsize',12,'VerticalAlignment','top','HorizontalAlignment','center')
text(xmin+(xmax-xmin)/2,ymax,['ymax ',num2str(ymax)],...
     'color','m','Fontsize',12,'VerticalAlignment','bottom','HorizontalAlignment','center')
axis off
axis equal
% store the external bbox:
xmin_o = xmin;
ymin_o = ymin; 
xmax_o = xmax;
ymax_o = ymax;
```

```R kernel="R"
ymax(dem)
```

```R kernel="R"
res(dem)
```

<!-- #region kernel="R" -->
##### How many rows are in the height of the bounding box?
<!-- #endregion -->

```R kernel="R"
# written using the metadata from the print of dem above:
(4572320 - 4556000)/5
```

```R kernel="R"
# written using the R object dem called by dedicated functions > ymax() , ymin() , res()
(ymax(dem) - ymin(dem))/res(dem)[1] # find the error
```

<!-- #region kernel="R" -->
##### About the Coordinate Reference System$\ldots$
<!-- #endregion -->

```R kernel="R"
# CRS
proj4string(dem)  # {sp}
```

```R kernel="R"
crs(dem)  # {raster}
```

<!-- #region kernel="R" -->
#### <b style="color:blue">Data</b>
<!-- #endregion -->

<!-- #region kernel="R" -->
##### Read the value of the raster in the first row and first column:<br>
(Please note that in this example we have a DEM, but it could be any other variable!!)
<!-- #endregion -->

```R kernel="R"
dem[1, 1]
```

<!-- #region kernel="R" -->
##### Read the value of the raster in the first two rows and first two columns:<br>
<!-- #endregion -->

```R kernel="R"
dem[1:2, 1:2]
```

<!-- #region kernel="R" -->
##### Extract
Exercise: use the geographical coordinates (got from Google maps) and extract the value of elevation from the raster having a different CRS
<!-- #endregion -->

<!-- #region kernel="R" -->
Premise: the DEM is the digital elevation model in Telese Valley having EPSG:32633.<br>
1. go to Google Maps
2. get the geographical coordinates of a point in Telese municipality
3. write the Lat,Lon coordinates with 4 decimal numbers (e.g. 12.1234)
4. create a vector data as simple feature using the sf package (keep in mind the crs definition)
5. project the point according to the raster crs
6. extract from the raster the value of elevation at the geographical location selected in point 
<!-- #endregion -->

<!-- #region kernel="R" -->
### Create <b style="color:green">new raster</b> from scratch
<!-- #endregion -->

<!-- #region kernel="R" -->
##### We must provide Bounding Box, resolution and CRS
<!-- #endregion -->

```R kernel="R"
GRID <- raster(xmn = 453000, 
               xmx = 477000, 
               ymn = 4556000, 
               ymx = 4572320, 
               resolution = 25, 
               crs = crs("+init=epsg:32633"))
```

```R kernel="R"
GRID
```

<!-- #region kernel="R" -->
##### The CRS can be initialised using the <b style="color:magenta">+init</b> instruction and passing a CRS code in EPSG format
<!-- #endregion -->

In this case we use the EPSG code 32633 Remember to provide the EPSG code associated to the coordinates used in xmn, xmx, ymn, ymx

```R kernel="R"
crs("+init=epsg:32633")
```

<!-- #region kernel="R" -->
##### Set random values in the raster (naturally it's a dummy operation to understand how it works)
<!-- #endregion -->

```R kernel="R"
ncol(GRID)
nrow(GRID)
ncell(GRID)
```

```R kernel="R"
hasValues(GRID)
```

```R kernel="R"
values(GRID) <- 1:ncell(GRID)
```

```R kernel="R"
GRID[1, 1] <- NA
```

```R kernel="R"
hasValues(GRID)
```

```R kernel="R"
spplot(GRID, main = "Dummy valorization of the raster")
```

<!-- #region kernel="R" -->
#### ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
<!-- #endregion -->

<!-- #region kernel="R" toc-hr-collapsed=true toc-hr-collapsed=true -->
## Step #1. <b style="color:orange">Coordinates Conversion</b>

<!-- #endregion -->

<!-- #region kernel="R" -->
#### ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
<!-- #endregion -->

<!-- #region kernel="R" -->
### Search in R help | <b style="color:blue">transform</b> and <b style="color:blue">project</b>
<!-- #endregion -->

```R kernel="R"
??transform  # search for string 'transform' in R Help
```

<!-- #region kernel="R" -->
We get few options, which are more related to <b style="color:magenta">vector</b> data: <br>
 - spTransform(), package sp <br>
 - st_tranform(), package sf <br>
<!-- #endregion -->

```R kernel="R"
??project # search for string 'project' in R Help
```

<!-- #region kernel="R" -->
We get above all one option, which is more related to <b style="color:magenta">raster</b> data: <br>
 - projectRaster(), package raster <br>
<!-- #endregion -->

<!-- #region kernel="R" -->
#### Use R
<!-- #endregion -->

<!-- #region kernel="R" -->
The suggestion is to build the required data model (i.e. vector or raster) and then proceed with the transform function in R.
<!-- #endregion -->

<!-- #region kernel="R" -->
##### vector data model
<!-- #endregion -->

<!-- #region kernel="R" -->
Build a simple feature object, and then use st_transform():
<!-- #endregion -->

```R kernel="R"
# The point below is taken from Google Maps, which has EPSG:4326
x <- 14.516343  # Longitude
y <- 41.224083  # Latitude
google_crs <- 4326
```

```R kernel="R"
require(sf)
P_goo <- st_point(c(x, y))
P_goo
```

```R kernel="R"
P_goo_sfc <- st_sfc(P_goo, crs = google_crs)
class(P_goo_sfc)
P_goo_sfc
```

```R kernel="R"
my_crs <- 32633
P_my_sf <- st_transform(P_goo_sfc, my_crs)
P_my_sf
```

```R kernel="R"
P_goo_sf <- st_sf(point = 1, geometry = P_goo_sfc)
class(P_goo_sf)
P_goo_sf$geometry
```

```R kernel="R"
my_crs <- 32633
P_my_sf <- st_transform(P_goo_sf, my_crs)
P_my_sf$geometry
```

<!-- #region kernel="R" -->
##### raster data model
<!-- #endregion -->

<!-- #region kernel="R" -->
Define the coordinates of the Upper-Left and Lower-Right points delimiting the bounding box of the RASTER we want to create:
<!-- #endregion -->

```R kernel="R" tags=[]
#  Click on Google maps on the two points of the bbox and write the coordinates values here
UL <- c(11, 43)  # upper left
LR <- c(17, 38)  # lower right
```

```R kernel="R"
require(raster)
GRID <- raster(xmn = UL[1], xmx = LR[1], ymn = LR[2], ymx = UL[2], resolution = 0.1, crs = crs("+init=epsg:4326"))
#       raster(xmn = UL[1], xmx = LR[1], ymn = LR[2], ymx = UL[2], resolution = 0.1, crs = 4326)
```

```R kernel="R"
GRID
```

```R kernel="R"
values(GRID) <- 1:ncell(GRID)
require(sp)
plot(GRID)
```

```R kernel="R"
GRID_pr <- projectRaster(GRID, crs = "+init=EPSG:32633")
```

<!-- #region kernel="R" -->
Plot: note that it is slightly rotated with respect to the previous one due to reprojection
<!-- #endregion -->

```R kernel="R"
plot(GRID_pr)
```

<!-- #region kernel="R" -->
#### Use epsg.io web application
https://epsg.io/transform
<!-- #endregion -->

```R kernel="R"
s_srs <- 4326
t_srs <- 32633
x <- 14.516343  # Longitude
y <- 41.224083  # Latitude
example_URL <- "https://epsg.io/transform#s_srs=4326&t_srs=32633&x=13.5000000&y=42.5000000"
my_URL <- paste0("https://epsg.io/transform#s_srs=", s_srs, "&t_srs=", t_srs, "&x=", x, "&y=", y)
my_URL
```

```R kernel="R"
xc <- 459461.72
yc <- 4563745.65
```

<!-- #region kernel="R" -->
Vienna, Austria<br>
P1(15.549644, 48.374276)<br>
P2(17.527792, 47.615370)
<!-- #endregion -->

```R kernel="R"
P1 <- st_point(c(15.549644, 48.374276))
P2 <- st_point(c(17.527792, 47.61537))
```

```R kernel="R"
P <- st_sfc(P1, P2, crs = 4326)
```

```R kernel="R"
P_3035 <- st_transform(P, crs = 3035)
P_3035
```

<!-- #region kernel="R" -->
### example using <b style="color:green">D.E.M.</b> raster
<!-- #endregion -->

<!-- #region kernel="R" -->
We can expect the air temperature to decrease by 6.5 degrees Celsius for every 1000 meters you gain in elevation.<br>
It means that for every meter we move up in elevation, the temperature decreases by 6.5/1000 °C:<br>
[ see Wikipedia at https://en.wikipedia.org/wiki/Atmospheric_temperature ]
<!-- #endregion -->

```R kernel="R"
6.5/1000
```

<!-- #region kernel="R" -->
The slope ($\beta$) of the relationship between temperature and elevation is 0.0065 Celsius degrees per each meter:<br>
$\beta = -0.0065 \frac{[°C]}{[m]}$

<!-- #endregion -->

<!-- #region kernel="R" -->
If we assume a temperature of 0 °C at elevation 0 meters,
<!-- #endregion -->

```R kernel="R"
elev <- 0  # a.s.l. above see level
t0 <- 0  # *C
beta <- -0.0065
```

<!-- #region kernel="R" -->
what is the predicted temperature at elevation given in the raster <b style="color:green">dem</b> at index position (1,1)?
<!-- #endregion -->

```R kernel="R"
dem[1, 1]
```

```R kernel="R"
t <- 0 + 217.7 * -0.0065
print(t)
```

<!-- #region kernel="R" -->
which can be written also as
<!-- #endregion -->

```R kernel="R"
t <- t0 + dem[1, 1] * beta
print(t)
```

<!-- #region kernel="R" -->
##### Now, expand our model to make predictions of temperature using the information about elevation
<!-- #endregion -->

<!-- #region kernel="R" -->
We assume a linear regression model of the form:<br>
$y = \alpha + \beta x$
<!-- #endregion -->

<!-- #region kernel="R" -->
Now, assume a temperature of 12.5 °C at elevation 0 meters (the $\alpha$ parameter of the model) for today:<br>
$\alpha = 12.5 \;°C$
<!-- #endregion -->

<!-- #region kernel="R" -->
Calculate / Predict the value of temperature at positions in the DEM where matrix indices are:<br>
(1,1)<br>
(200,700)<br>
(3200,2200)
<!-- #endregion -->

```R kernel="R"
dem[1, 1]
12.5 - 0.0065 * dem[1, 1]
```

```R kernel="R"
dem[200, 700]
12.5 - 0.0065 * dem[200, 700]
```

```R kernel="R"
dem[3200, 2200]
12.5 - 0.0065 * dem[3200, 2200]
```

```R kernel="R"
a <- 12.5  # alpha
b <- -0.0065  # beta
T <- a + b * dem
T
```

```R kernel="R"
spplot(T, main = "Temperature Map on 2020-11-20")
```

<!-- #region kernel="R" -->
##### Save raster | temperature map
<!-- #endregion -->

```R kernel="R"
writeRaster(x = T, filename = "Tair_VT_20201120.tif", overwrite = TRUE)
```

<!-- #region kernel="R" -->
See which [ GDAL raster drivers  ](https://gdal.org/drivers/raster/index.html#raster-drivers) are available out there!
<!-- #endregion -->
