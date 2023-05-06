# == EDA (Explorative Data Analysis) =============
require(sf)
r <- st_read("rain_daily.geojson")

# explore dataset

#      general
View(r)

class(r)

names(r)

dim(r)

r
print(r)

head(r, n=2)
tail(r,n=1)

#      geospatial
#     > https://www.esri.com/arcgis-blog/products/arcgis-pro/mapping/gcs_vs_pcs/
#       The geographic coordinate system (GCS) is a coordinate system that defines the
#       location of objects on earth, assuming a spherical shape [degree].
#       The projected coordinate system (PCS) is flat.
#       It contains a GCS but uses mathematics (projection algorithm) and other parameters
#       to turn the GCS into a plane, usually [meter].
st_crs(r) # go to https://epsg.io
st_bbox(r)

plot(st_bbox(r))

bbox2map( st_bbox(r), st_crs(r) )

#      create R function to plot bbox
bbox2map <- function(bbox,CRS){

  Xc1 <- as.double( bbox[1] )
  Xc2 <- as.double( bbox[3] )
  Yc1 <- as.double( bbox[2] )
  Yc2 <- as.double( bbox[4] )
  
  formatC(Xc1, digits = 15, format = "f")
  
  require(sf)
  
  # create POINT
  Points <- st_sfc(
    st_point( c(Xc1, Yc1) ),
    st_point( c(Xc2, Yc1) ),
    st_point( c(Xc2, Yc2) ),
    st_point( c(Xc1, Yc2) ),
    crs = CRS
  )
  class(Points)
  Points <- st_sf(Points)
  
  # create POLYGON
  Polygon <- st_sfc( st_polygon( 
                list( rbind(
                        c(Xc1, Yc1), 
                        c(Xc2, Yc1), 
                        c(Xc2, Yc2), 
                        c(Xc1, Yc2), 
                        c(Xc1, Yc1)
                      )
                    )
                ), crs = CRS
  )
  
  require(tmap)
  tmap_mode('view')
  tm_shape(Points) + 
    tm_bubbles() +
    tm_shape(Polygon) +
    tm_polygons(alpha = 0.4)
}


#      statistics
r$Value
min(r$Value)
max(r$Value)
mean(r$Value)
sd(r$Value)
var(r$Value)

summary(r)
quantile(r$Value,c(0.25,0.50,0.75))

summary(factor(r$Range.check))

#      plot
plot(r$Value)

barplot(r$Value)

hist(r$Value)
hist(sqrt(r$Value))

boxplot(r$Value)

require(dplyr)
r_sel <- r %>%
  filter(Value>0)
boxplot(r_sel$Value)

#      list the sorted and unique values available 
r$Value
unique(r$Value)
sort(unique(r$Value))
barplot(sort(unique(r$Value)))

#      create a logical variable using a threshold
r$Value
r$Value>0.0

val_ind = r$Value>0.0
val_ind
as.numeric(val_ind)
sum(val_ind) # what are you getting?



# == Variography, basic operations =============
r <- st_read("rain_daily.geojson")

require(gstat)

#   -- experimental variogram
r.var <- variogram(Value~1,r)
r.var
plot(r.var)

#   -- variogram model
r.fit <- fit.variogram(r.var,model=vgm(0.8,'Exp',35,0.1))
plot(r.var,r.fit)
r.fit

#   -- cutoff
r.varc <- variogram(Value~1,r,cutoff=50)
plot(r.varc)
r.fitc <- fit.variogram(r.varc,model=vgm(0.8,'Exp',35,0.1))
plot(r.varc,r.fitc)

#   -- indicator variable
val_ind = r$Value>0
r = cbind( r, val_ind )
names(r)

#   -- experimental variogram
r.vari <- variogram(val_ind~1,r)
plot(r.vari)
#   -- variogram model
r.fiti <- fit.variogram(r.var,model=vgm(0.10,'Exp',20,0.13))
plot(r.vari,r.fiti)
r.fiti
#   -- Nugget-to-Sill Ratio (NSR)
r.fiti$psill[1] / sum(r.fiti$psill)

# kriging
require(sf)
r_sp <- as_Spatial(r)
ca_pol <- st_read("/didattica/docente_Langella/Vector-Data/Ca.geojson")
ca_pol_proj <- st_transform(ca_pol,32633)
BB = st_bbox(ca_pol_proj)
ca_rl <- raster(xmn=BB[1],ymn=BB[2],xmx=BB[3],ymx=BB[4],resolution=500,crs=32633)
ca_sp <- SpatialPoints(ca_rl)
gridded(ca_sp) <- TRUE
proj4string(ca_sp) <- CRS("+init=epsg:32633")
summary(ca_sp)
proj4string(r_sp) <- proj4string(ca_sp)
proj4string(ca_sp) <- proj4string(r_sp)

names(r_sp)
map.rain <- krige(Value~1,r_sp,newdata=ca_sp,model=r.fitc,nmin=4,nmax=12)
head(map.rain)
spplot(map.rain)

map.prain <- krige(val_ind~1,r_sp,newdata=ca_sp,model=r.fiti,nmin=4,nmax=12)
head(map.rain)
spplot(map.rain)

