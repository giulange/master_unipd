# Import from PSQL ====
require(RPostgreSQL)

#   -- URCoFi PROD
drv    <- dbDriver("PostgreSQL")
host   <- '192.168.20.40'
port   <- '65434'
user   <- 'CAR_admin'
pswd   <- 'Car2019'
dbname <- 'CAR'

# connection #
try( connection  <- dbConnect(drv,
                              host = host,
                              port = port, 
                              user = user,
                              password = pswd,
                              dbname = dbname) # schema = 'public'
)

# SQL query:
#  SELECT "Timestamp","Name","Longitude","Latitude","Elevation","Value"
#    FROM production."Measurement" M JOIN production."Station" S
#    ON M."Station Longitude" = S."Longitude" AND M."Station Latitude" = S."Latitude"
#    WHERE "Variable Name" = 'Air temperature'
#    AND "Timestamp" >= '2022-03-19 00:00:00'
#    AND "Timestamp" <= '2022-03-19 23:55:00'
#    ORDER BY "Timestamp","Value" DESC

qry_m10 <- "SELECT \"Timestamp\",\"Name\",\"Longitude\",\"Latitude\",\"Elevation\",\"Value\"
              FROM production.\"Measurement\" M JOIN production.\"Station\" S
              ON M.\"Station Longitude\" = S.\"Longitude\" AND M.\"Station Latitude\" = S.\"Latitude\"
              WHERE \"Variable Name\" = 'Air temperature'
              AND \"Timestamp\" >= '2022-03-19 00:00:00'
              AND \"Timestamp\" <= '2022-03-19 23:55:00'
              ORDER BY \"Timestamp\",\"Value\" DESC"

# request the data
t_m10 <- dbGetQuery(connection,qry_m10)

# disconnect
dbDisconnect(connection)
rm(connection,drv,dbname,host,port,pswd,qry_m10,user)

# save dataset
write.csv(t_m10,"AirTemperature_m10.csv",row.names=FALSE)

# Read / Write PSQL extracted data ====
t_m10 <- read.csv("AirTemperature_m10.csv")

# EDA | 10-min measurements  ====
class(t_m10)
names(t_m10)
head(t_m10)

y <- t_m10$Value

plot(y,pch='.',col='blue',main="Questo plot non è molto utile")

boxplot(y~t_m10$Name)
hist(y)
hist(log(y))

# simple:
qqnorm(y) # normal QQ plot
qqline(y)
# custom:
qqnorm(y, pch = '.', col='red', frame = FALSE)
qqline(y, col = "steelblue", lwd = 3)


# dplyr | aggregate to daily measurements  ====
require(dplyr)
#   https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

# Select specific time:
t_sel <- t_m10 %>% 
  filter(Timestamp == as.POSIXct("2022-03-19 00:10:00"))

head(t_sel)
hist(t_sel$Value)

# daily average temperature per station:
names(t_m10)
t_day <- t_m10 %>%
  group_by(Name) %>%
  summarise( lon  = mean(Longitude),
             lat  = mean(Latitude), 
             elev = mean(Elevation), 
             mean = mean(Value,na.rm=F),
             min  = min(Value,na.rm=F),
             max  = max(Value,na.rm=F),
             N    = length(Value)
           )
head(t_day)

# WRITE
write.csv(t_day,"AirTemperature_day.csv",row.names=FALSE)


# EDA | daily temperatures ====
rm(list=ls())
t_day <- read.csv("AirTemperature_day.csv")
setwd("/didattica/docente_Langella/env/master_unipd/")
t_day <- read.csv("/didattica/docente_Langella/env/master_unipd/AirTemperature_day.csv")

y <- t_day$mean

boxplot(y,main="Boxplot of Mean Air Temperature [°C]",ylab="Temperature [°C]")
hist(y)
# Transforming Data:
#   -- roots
hist(sqrt(y))
hist(y^(1/3))
hist(y^(1/4))
#   -- log
hist(log(y))
#   -- reciprocals
hist(1/y)
#   -- power
hist(y^2)
hist(y^3)
hist(y^4)

# Standardization | in particular to compare variables
z_score <- (y - mean(y)) / sd(y)
hist(z_score)

# Moments of a random variable
require(e1071)
hist(y)
# 1 mean
# 2 variance
# 3 skewness (sign vs tail, width  departure from symmetric distribution)
skewness(y) # --> coda a sinistra
# 4 kurtosis (<3 | >3,      height departure from symmetric distribution)
kurtosis(y) # --> PLATYKURTIC, <3

# qq-plot
qqnorm(y, pch = '.', col='red', frame = FALSE)
qqline(y, col = "steelblue", lwd = 3)

# Normality test
#  DESCRIPTION
# It’s possible to use a significance test comparing the sample distribution to 
# a normal one in order to ascertain whether data show or not a serious 
# deviation from normality.
# There are several methods for normality test such as Kolmogorov-Smirnov (K-S) 
# normality test and Shapiro-Wilk’s test.

# shapiro test:
shapiro.test(y)
#  DESCRIPTION
#    The null hypothesis of this test is that “sample distribution is normal”. 
#    If the test is significant, the distribution is non-normal.
#    Indeed, it means that the data distribution is significantly different from
#    the (normal) distribution of the null hypothesis.


y1 = y[y<10]
# qq-plot
qqnorm(y1, pch = '.', col='red', frame = FALSE)
qqline(y1, col = "steelblue", lwd = 3)
shapiro.test(y1)
# From the output, the p-value=~0.05 implies that the distribution of the data
# is not significantly different from normal distribution given in the null hypothesys.
# In other words, we can assume the normality.

# Gaussian anamorphosys | skip ====
# The process of fitting the raw data to obtain a transformed function is called
# Gaussian anamorphosis. Subsequently a model expanded in terms of Hermite 
# polynomials is fitted to the experimental anamorphosis and this function gives 
# the correspondence between each of the sorted raw data and the corresponding 
# frequency quantiles in the standardized Gaussian scale. The transformed data
# will be used later in the simulation process to represent the sample values on 
# the multivariate Gaussian function of probability and then to estimate the
# probability function at all unsampled locations (Goovaerts, 1997).
require(sp)
require(RGeostats)
data(meuse)

#01. Fit Gaussian Anamorphosis 
mdb = meuse[,c("x","y","zinc")] #must be 3 columns: x,y,z
mdb.rgdb = db.create(mdb,ndim=2,autoname=F)
mdb.herm = anam.fit(mdb.rgdb,name="zinc",type="gaus")
mdb.hermtrans =
  anam.z2y(mdb.rgdb,names=db.getname(mdb.rgdb,"z",1),anam=mdb.herm)
zinc.trans = mdb.hermtrans@items$Gaussian.zinc

#02. Variogram fit to gaussian transformed data using gstat 
meuse$zn.trans= zinc.trans
coordinates(meuse) = ~x+y
zn.svgm <- variogram(zn.trans~1,data=meuse)
vgm1 = vgm(1.17,"Sph",1022, 0.0925)
plot(zn.svgm,vgm1)
meuse.gstat <- gstat(id="zn.trans", formula=zn.trans~1, model=vgm1,
                     data=meuse,nmin=2, nmax=30)

#03. Kriging predictions with 4 simulations for simplicity (gstat)
data(meuse.grid)
coordinates(meuse.grid) = ~x+y
gridded(meuse.grid)=T
nsim = 4
zntrans.ok = predict(meuse.gstat,meuse.grid,nsim=nsim) #multiple simulations

#04. Back transform using RGeostats
zn.bts = cbind(coordinates(zntrans.ok),zntrans.ok@data)
zn.bts.db = db.create(zn.bts,autoname = F)
transout = zn.bts
transout[,3:length(transout)]=NA

#This loops through each  item in the RGeostats DB and backtransform it
for(i in 4:(nsim+4)){
  
  sim = db.getname(zn.bts.db,rank = i)
  simtrans = paste("Raw.",sim,sep="")
  tempdb = anam.y2z(zn.bts.db,names=sim,anam = mdb.herm)
  transout[,i-1] = eval(parse(text =
                                paste("tempdb at items$",simtrans,sep="")))
}


# Further data analysis =====

# rischio gelate:
t_day %>% 
  filter(min < 0.0)

t_day %>% 
  filter(min < 1.0)

t_day %>% 
  filter(min < 1.5)

# selezionare alcune stazioni:
staz1 <- t_m10 %>% 
  filter(Name=="Greci 641")

staz2 <- t_m10 %>% 
  filter(Name=="Montella 528")

staz3 <- t_m10 %>% 
  filter(Name=="Eboli-Improsta 17")


# plot | time series by station ====
MaxT = max(staz1$Value,staz2$Value,staz3$Value)
plot(staz1$Value,type='l',col='red',lwd=5,
     main="Air Temperature [°C]",
     xlab = "10-min",ylab="Measurements",
     ylim = c(0,MaxT))
lines(staz2$Value,col='green',lwd=5)
lines(staz3$Value,col='blue',lwd=5)
legend(1,3,legend = c("Greci 641","Montella 528","Eboli-Improsta 17"),
       col = c('red','green','blue'),lty=1,lwd=3,cex=0.8)

sum(staz1$Timestamp - staz2$Timestamp)
sum(staz1$Timestamp - staz3$Timestamp)

t_sel <- data.frame( Timestamp=staz1$Timestamp,
                     Greci = staz1$Value,
                     Montella = staz2$Value,
                     Eboli = staz3$Value)

summary(t_sel)

?plot.ts
plot.ts(t_sel[,2:4],main="Air Temperature")

# $
# [row,col]
# [c(1,8,12), 2:4]



# Geospatial Analysis ====
# (Geospatial) Explorative Data Analysis (EDA)
#  [√] observe the pattern of temperature with latitude
#  [√] observe the pattern of temperature with altitude
#  [x] apply for a transformation to set all the stations at sea level
# Variography
#  [√] spatial relationship -> variogram
#  [√] cloud variogram analysis: outlier removal
#  [√] experimental variogram fitting
#  [x] directional variograms ~ anisotropy
#  [x] variogram map
# Kriging
#  [√] kriging

# (Geospatial) Explorative Data Analysis (EDA) ====
#  [√] observe the pattern of temperature with latitude
#  [√] observe the pattern of temperature with altitude
#  [x] apply for a transformation to set all the stations at sea level
rm(list=ls())

dir(pattern = "csv")

t_day <- read.csv("AirTemperature_day.csv")
require(sf)
head(t_day)
td <- st_as_sf(t_day,coords = c("lon","lat"),crs=4326)
class(td)

# Campania Region
require(sf)
ca_pol <- st_read("/didattica/docente_Langella/Vector-Data/Ca.geojson")
plot(ca_pol$geometry)


require(tmap)
tmap_mode("view")
tm_shape(ca_pol) + 
  tm_polygons(alpha=0.3) +
  tm_shape(td) + 
  tm_bubbles(col="elev",size="mean")

# GCS --> PCS and GEDA
names(td)
st_crs(td)
td <- st_transform(td,32633)
st_crs(td)
td
class(td)
y <- st_coordinates(td)[,2]
plot(y,td$mean,type='p',
     xlab="Northing [m]",
     ylab="Mean Air Temperature [°C]",
     main="Effect of Latitude on Air Temperature")

attach(td)
plot(elev,mean,type="p",
     xlab="Elevation [m]",
     ylab="Mean Air Temperature [°C]",
     main="Effect of Elevation on Air Temperature")

lr_n <- lm(mean~elev,td)
summary(lr_n)
abline( lr_n )

lr_ne <- lm(mean~elev+st_coordinates(td)[,2],td)
summary(lr_ne)
detach(td)

# compare the two linear models, in terms of adjusted R2 and significance.


# Variography ====
#  [√] spatial relationship -> variogram
#  [√] experimental variogram fitting
#  [x] directional variograms ~ anisotropy
#  [x] variogram map
#  [√] cloud variogram analysis: outlier removal

require(gstat)
# variogram , fit.variogram , krige

# gstat -> (sp) + (sf , raster)

require(sp)

# Variogram
#   We have to write a formula such as in linear regression model using lm(y~x)
#   CLOUD
cvgm_n <- variogram(mean~1,td,cloud=TRUE)
plot(cvgm_n)
head(cvgm_n)

#   EXPERIMENTAL
vgm_n <- variogram(mean~1,td)
vgm_n
class(vgm_n)
plot(vgm_n)

# Fitting
vgm_fn <- fit.variogram( 
                          vgm_n,
                          vgm(6.2,'Exp',5e+04,0.8)
                      )
vgm_fn
plot(vgm_n,vgm_fn)

vgm_fn_s <- fit.variogram(vgm_n, vgm(8.0,"Sph",60000,0.2) )
vgm_fn_s
plot(vgm_n,vgm_fn_s)

# Fitting manuale
plot( vgm_n , vgm(8.0,"Sph",60000,0.2) )

# Directional variogram
vgm_nd <- variogram(mean~1,td,alpha=c(45,90,135,180))
plot(vgm_nd)
vgm_nd <- variogram(mean~1,td,alpha=c(22,67,112,157))
plot(vgm_nd)
vgm_nd <- variogram(mean~1,td,alpha=c(90,180))
plot(vgm_nd)

# Variogram map
vgm_map <- variogram(mean~1,td,map=TRUE,cutoff=6e+04,width=10000)
plot(vgm_map)

# Filter the pairs according to the cloud variogram, 
# where high variance values are found at short distance
vgm_c <- variogram(mean~1,td,cloud=TRUE)
plot(vgm_c)

names(vgm_c)
shortDist <- 17000
highGamma <- 22

plot(vgm_c$dist,vgm_c$gamma,type='p',col="blue",
     xlab="Distance [m]", ylab="Semivariance")
abline(v=shortDist,col="red",lwd=4,lty=2)
abline(h=highGamma,col="red",lwd=4,lty=2)

selD <- vgm_c$dist  < shortDist
selG <- vgm_c$gamma > highGamma

outL <- vgm_c[ which(selD & selG), ]
points(outL$dist,outL$gamma,col="magenta",pch=16)
# view outL and retrieve possible outliers
td[c(48,98),]

tmap_mode("view")
# students: please, search for possible hot spots which can be outliers
tm_shape(td) +
  tm_bubbles(size="mean",col="mean") + 
  tm_shape(td) + 
  tm_dots()

# highlight the two points select in the cloud variogram analysis before:
tm_shape(td) +
  tm_bubbles(size="mean",col="mean") +
  tm_shape(td[c(98,48),]) +
  tm_bubbles(size="mean",col="magenta")

# remove the two geospatial points considered as hot spots
# and do variography again. Finally, compare the kriging maps of
# both variograms, the one with all data and the other without 2 locations.

td_sel <- td[-c(98,48),] # mask out hotspots / outliers
td_sel <- td # no

# Kriging ====
#  [√] kriging

require(raster)

ca_pol <- st_read("/didattica/docente_Langella/Vector-Data/Ca.geojson")
st_crs(td)
ca_pol_proj <- st_transform(ca_pol,32633)
BB = st_bbox(ca_pol_proj)
BB

ca_rl <- raster(xmn=BB[1],ymn=BB[2],xmx=BB[3],ymx=BB[4],resolution=500,crs=32633)
ca_rl
hasValues(ca_rl)
ca_rl[120,200]

names(td_sel)
krige(mean~1,td_sel,newdata=ca_rl,model=vgm_fn) # <-- error, need the SpatialPixels

# convert SpatialPoints
td_sel_sp <- as_Spatial(td_sel)

# convert SpatialPixels
ca_sp <- SpatialPoints(ca_rl)
class(ca_sp)
head(ca_sp)
gridded(ca_sp) <- TRUE
proj4string(ca_sp) <- CRS("+init=epsg:32633")

# 1. SpatialPointsDataFrame : tabella dati / misure
# 2. SpatialPixels : punti incogniti di interpolazione
# 3. crs(obj) <- NA

head(ca_sp)
map.tmean <- krige(mean~1,td_sel_sp,newdata=ca_sp,model=vgm_fn) # <-- issue on the crs
spplot(map.tmean)

# force the two objects to the same CRS
proj4string(td_sel_sp) <- proj4string(ca_sp)
proj4string(ca_sp) <- proj4string(td_sel_sp)
map.tmean <- krige(mean~1,td_sel_sp,newdata=ca_sp,model=vgm_fn) # <-- issue on the crs solved!
spplot(map.tmean)

map.tmean.pred <- mask(raster(map.tmean["var1.pred"]),ca_pol_proj)
spplot(map.tmean.pred,main="Mean Air Temperature - 2022-03-19")

map.tmean.var <- mask(raster(map.tmean["var1.var"]),ca_pol_proj)
spplot(map.tmean.var,main="Mean squared prediction error")

writeRaster(map.tmean.pred,"map_tmean_pred.tif")



