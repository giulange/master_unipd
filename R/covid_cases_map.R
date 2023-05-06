# L'obiettivo è creare una funzione in grado di generare la mappa dei contagi
# aggiornata ad una determinata data.
# Nel caso in cui non forniamo una data specifica, la funzione vogliamo che 
# restituisca i dati del monitoraggio relativi alla data più recente
# disponibile (latest).
plot_today_c19_totcases <- function(Date='latest'){
  
  library(tmap)
  library(readr)
  require(sf)
  
  filename <- paste0('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province-',
                     Date, '.csv')
  
  c19 <- read_csv(filename)
  na_idx <- which(is.na(c19$long))
  c19_na <- c19[-na_idx,]
  c19_sf <- st_as_sf( c19_na, coords = c("long","lat"), crs=4326 )
  
  tmap_mode("view")
  tm_shape(c19_sf) + 
    tm_bubbles(size=0.3,col = "totale_casi") + 
    tm_layout(title=Date )
  
}

# creare la mappa geospaziale dei contagi per un giorno specifico:
plot_today_c19_totcases("20200420")

# creare la mappa geospaziale dei contagi alla situazione più recente:
plot_today_c19_totcases()