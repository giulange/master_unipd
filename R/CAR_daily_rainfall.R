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

# list tables
tbl_ls <- dbListTables(connection)
tbl_ls

# query
#   -- original SQL:
# SELECT *
#   FROM production."Daily Measurement"
#               WHERE "Variable Name" = 'Rainfall'
#               AND "Timestamp" = '2022-03-19';
# 
#   -- embedded in R request:
qry_h24 <- "SELECT *
              FROM production.\"Daily Measurement\"
              WHERE \"Variable Name\" = 'Rainfall'
              AND \"Timestamp\" = '2022-03-19';"

# request the data
rain <- dbGetQuery(connection,qry_h24)

# disconnect
dbDisconnect(connection)
rm(connection,drv,dbname,host,port,pswd,qry_h24,tbl_ls,user)

# create a vector geodata model
require(sf)
r <- st_as_sf(rain,coords = c("Station Longitude","Station Latitude"),crs=4326)

require(tmap)
tmap_mode("view")
tm_shape(r) + 
  tm_bubbles(size='Value',col='Value',alpha=0.4) +
  tm_shape(r) + 
  tm_dots() + 
  tm_layout(title="Rainfall on 2022-Mar-19")

st_write(r,"rain_daily.geojson")


