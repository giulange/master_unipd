# L'obiettivo è creare una funzione in grado di generare la mappa dell'incremento
# di contagi, aggiornata ad una determinata data.

plot_todayDiff_c19_totcases <- function(Date){
  
  # Date : date with format "%Y%m%d"
  library(tmap)
  library(readr)
  require(sf)
  require(dplyr)
  
  today <- Date
  yesterday <- format( as.Date(Date,"%Y%m%d")-1, "%Y%m%d" )
  
  # filename for today:
  filename_t <- paste0('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province-',
                       Date, '.csv')
  # filename for yesterday:
  filename_y <- paste0('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province-',
                       yesterday, '.csv')
  c19_t <- read_csv(filename_t)
  c19_y <- read_csv(filename_y)
  
  na_idx <- which(is.na(c19_t$long))
  c19_na <- c19_t[-na_idx,]
  c19_sf_t <- st_as_sf( c19_na, coords = c("long","lat"), crs=4326 )
  
  na_idx <- which(is.na(c19_y$long))
  c19_na <- c19_y[-na_idx,]
  c19_sf_y <- st_as_sf( c19_na, coords = c("long","lat"), crs=4326 )
  
  # inner_join(c19_sf_t,c19_sf_y,by="sigla_provincia")
  c19_sf <- c19_sf_t %>%
    mutate(diff = totale_casi - c19_sf_y$totale_casi)
  
  tmap_mode("view")
  tm_shape(c19_sf) + 
    tm_bubbles(size=0.3,col = "diff") + 
    tm_layout(title = as.character(as.Date(Date,"%Y%m%d")),
              title.position = 'center')
}


plot_todayDiff_c19_totcases("20200225")
plot_todayDiff_c19_totcases("20200226")
plot_todayDiff_c19_totcases("20200227")
plot_todayDiff_c19_totcases("20200228")
plot_todayDiff_c19_totcases("20200229")
plot_todayDiff_c19_totcases("20200301")
