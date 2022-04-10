a = 1 + 2




# leggere shp
require(sf)
st_read("DigitalSoilMap_Improsta.shp")
dsm_imp <- st_read("DigitalSoilMap_Improsta.shp")

plot(dsm_imp)

require(tmap)
tmap_mode("view")
tm_shape(dsm_imp) +
  tm_polygons("SIGLA_UC",alpha=0.4)


library(raster)

dem <- raster("../Raster-Data/dem20m_campania.tif")

# parametri MLR semplice, per un certo giorno, in Regione Campania
a <- 0.02
b <- 0.001

T <- a + b*dem
require(sp)
spplot(T)
spplot(dem)


