# 
# Source: DPC
# URL: https://github.com/pcm-dpc/COVID-19

library(readr)
# filename <- paste0('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province-latest.csv')
filename <- "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province-latest.csv"
c19 <- read_csv(filename)

class(c19)

names(c19)

head(c19,n=2)
tail(c19)

