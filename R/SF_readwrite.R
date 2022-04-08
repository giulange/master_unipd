# Three main operations are managed:
#   1. create a SF from scratch having POINT geometry
#   2. read a shapefile / geojson file in R
#   3. export a SF object using common driver and format

# 1. create a SF from scratch having POINT geometry ####
require(sf)
# ...

# template ---------------
# P <- st_point( c(21.618961,-33.387604) ) # of format XY in 2D, i.e. (Lon,Lat)
# P_sfc <- st_sfc(P,crs=4326)
# P_sf <- st_sf(P_sfc)
# require(tmap)
# tmap_mode("view")
# tm_shape(P_sf) + 
#   tm_bubbles()
#


# 2. read a shapefile / geojson file in R ####

# template ---------------
# pol <- st_read("map.geojson")
# plot(pol)
# tm_shape(pol) + 
#   tm_polygons(alpha=0.5)


# 3. export a SF object using common driver and format ####


# template ---------------
# P_proj <- st_transform(P_sf,32633)
# st_crs(P_proj)
# st_write(P_proj,"P_proj.geojson")


