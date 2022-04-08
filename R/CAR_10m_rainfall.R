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
#    WHERE "Variable Name" = 'Rainfall'
#    AND "Timestamp" >= '2022-03-19 00:00:00'
#    AND "Timestamp" <= '2022-03-19 23:55:00'
#    ORDER BY "Timestamp","Value" DESC

qry_m10 <- "SELECT \"Timestamp\",\"Name\",\"Longitude\",\"Latitude\",\"Elevation\",\"Value\"
              FROM production.\"Measurement\" M JOIN production.\"Station\" S
              ON M.\"Station Longitude\" = S.\"Longitude\" AND M.\"Station Latitude\" = S.\"Latitude\"
              WHERE \"Variable Name\" = 'Rainfall'
              AND \"Timestamp\" >= '2022-03-19 00:00:00'
              AND \"Timestamp\" <= '2022-03-19 23:55:00'
              ORDER BY \"Timestamp\",\"Value\" DESC"


# request the data
r_m10 <- dbGetQuery(connection,qry_m10)

# disconnect
dbDisconnect(connection)
rm(connection,drv,dbname,host,port,pswd,qry_m10,tbl_ls,user)

# save dataset
write.csv(r_m10,"rain_m10.csv",row.names=FALSE)

# read csv
# r_m10 <- read.csv("rain_m10.csv")

# explore dataset
class(r_m10)
names(r_m10)
head(r_m10)

plot(r_m10$Value)

hist(r_m10$Value)

barplot(r_m10$Value)

plot(density(r_m10$Value))


# explore date format as read from PSQL DB
class(r_m10$Timestamp)

r_m10$Timestamp[250]
format(r_m10$Timestamp[250],"%Y-%m-%d %H:%M")

require(dplyr)

# Select specific time:
r_sel <- r_m10 %>% 
  filter(Timestamp == as.POSIXct("2022-03-19 00:10:00"))

head(r_sel)
hist(r_sel$Value)

# Select all values for that day greater than zero:
r_sel <- r_m10 %>% 
  filter(Value>0)

hist( r_sel$Value )

# total rainfall per station:
names(r_m10)
r_tot <- r_m10 %>%
  group_by(Name) %>%
  summarise( lon = mean(Longitude), lat = mean(Latitude), elev = mean(Elevation), tot = sum(Value) )
head(r_tot)

r_tot %>% 
  filter(tot > 4.0)

staz1 <- r_m10 %>% 
  filter(Name=="Forio")
  
staz2 <- r_m10 %>% 
  filter(Name=="Monte Epomeo")

staz3 <- r_m10 %>% 
  filter(Name=="Rofrano")


# plot
plot(staz1$Value,type='l',col='red',lwd=2,main="Rainfall [mm]",xlab = "10-min",ylab="Measurements")
lines(staz2$Value,col='green',lwd=2)
lines(staz3$Value,col='blue',lwd=2)

sum(staz1$Timestamp - staz2$Timestamp)
sum(staz1$Timestamp - staz3$Timestamp)

r_sel <- data.frame( Timestamp=staz1$Timestamp,
       Forio = staz1$Value,
       MonteEpomeo = staz2$Value,
       Rofrano = staz3$Value)

summary(r_sel)

?plot.ts
plot.ts(r_sel[,2:4],main="Rainfall")
