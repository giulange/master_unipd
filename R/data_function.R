
# == mtcars =======
data("mtcars")
View(mtcars)
?mtcars
# https://rstudio-pubs-static.s3.amazonaws.com/46951_74a502b74e5645049c2d7d5c5a136394.html

# == iris =======
data(iris)
View(iris)
?iris
# https://www.statology.org/iris-dataset-r/

# == meuse =======
detach("package:sp", unload = TRUE)

data(meuse)

require(sp)

data(meuse)

summary(meuse)

?meuse

# https://cran.r-project.org/web/packages/gstat/vignettes/gstat.pdf

