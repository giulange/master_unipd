# Operazioni da eseguire in R:

version

# 01. Operazioni algebriche (+, -, *, /)
2 + 3
2 - 3
2 * 3
2 / 3


# 02. Ctrl + C (interrompere l’esecuzione del comando)


# 03. Ctrl + L (pulire la console)


# 04. Freccia «su» per recuperare la history


# 05. Creazione di un oggetto, operatore : , creazione di un vettore (die), ls()
a <- 2 + 3
b = 2 + 3
c = 1:6
ls()


# 06. Stampa di un oggetto
c
print(c)


# 07. Rimuovere un oggetto
a1 <- c
ls()
rm('a1')
ls()


# 08. Moltiplicazione per elemento e matriciale (inner, outer)
# ...skip


# 09. Funzioni, built-in
#     c()
c(1,3,6,9,11)

birth <- c(30,08,1977)

# y = a + b*x
a = 0.04
b = 1.06
x = 1:100
y = a + b*x

plot(x,y)

#     generatore di "n" valori da una distribuzione normale, con media "mean" e dev.st. "sd"
rnorm(n=100, mean=0, sd=1)

#     istrogramma
hist(rnorm(50,0,1))
hist(rnorm(100,0,1))
hist(rnorm(500,0,1))
hist(rnorm(5000,0,1))
hist(rnorm(50000,0,1))

#     seed
set.seed(123)
hist(rnorm(50,0,1))

#     mean, min, max, sum, round, sqrt, log10, 
samples <- rnorm(n=100, mean=0, sd=1)
samples
mean(samples)
sd(samples)
min(samples)
max(samples)
sum(samples)
round(samples,1)
sqrt(samples)
log10(samples)

samples <- rnorm(n=50000, mean=0, sd=1)
mean(samples)
sd(samples)

#     sample( x, size), replicate(N, expr)
# ...skip

#     help (?, ??)
?sd
??replicate

#     Funzioni nidificate, es. round(mean())
round(mean(samples),4)

#     Argomenti di una funzione, args()
args(round)


# 10. Script, esecuzione codice per linea o per blocco


# 11. Funzioni, creazione dall’utente: esempi sui dati covid


# 12. Packages
#     install.packages()
install.packages("rgdal")

#     require / library
require(rgdal)


# 13. Tipi di dati

#     Double
v1 <- c(1,2,5)
class(v1)
typeof(v1)

#     Integer
v2 <- c(1L,2L,5L)
class(v2)
typeof(v2)

#     Character
v3 <- c("Hello","World")
v3
typeof(v3)
#     Logical
v4 <- c(TRUE,FALSE,FALSE,FALSE)
v4
typeof(v4)
#     Mixed
v5 <- c(1,2L,"Hello")
v5
class(v5)

v5 <- c(1,2L,"Hello")
v6 = c(1,2L,"Hello")

#     Coercion
v4
as.numeric( v4 )

v1
as.character(v1)

v2
as.logical(v2)

