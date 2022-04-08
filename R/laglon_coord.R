suppressPackageStartupMessages(library(sf))
e = cbind(-90:90,0) # equator
f1 = rbind(cbind(0, -90:90)) # 0/antimerid.
f2 = rbind(cbind(90, -90:90), cbind(270, 90:-90))# +/- 90
eq = st_sfc(st_linestring(e), st_linestring(f1), st_linestring(f2), crs=4326)

geoc = st_transform(eq, "+proj=geocent")
cc = rbind(geoc[[1]], NA, geoc[[2]], NA, geoc[[3]])
from3d = function(x, offset, maxz, minz) {
  x = x[,c(2,3,1)] + offset # move to y right, x up, z backw
  x[,2] = x[,2] - maxz      # shift y to left
  d = maxz
  z = x[,3] - minz + offset
  x[,1] = x[,1] * (d/z)
  x[,2] = x[,2] * (d/z)
  x[,1:2]
}
maxz = max(cc[,3], na.rm = TRUE)
minz = min(cc[,3], na.rm = TRUE)
offset = 3e7
circ = from3d(cc, offset, maxz, minz)
mx = max(cc, na.rm = TRUE) * 1.1
x = rbind(c(0, 0, 0), c(mx, 0, 0))
y = rbind(c(0, 0, 0), c(0, mx, 0))
z = rbind(c(0, 0, 0), c(0, 0, mx))
ll = rbind(x, NA, y, NA, z)
l0 =  from3d(ll, offset, maxz, minz)
mx = max(cc, na.rm = TRUE) * 1.2
x = rbind(c(0, 0, 0), c(mx, 0, 0))
y = rbind(c(0, 0, 0), c(0, mx, 0))
z = rbind(c(0, 0, 0), c(0, 0, mx))
ll = rbind(x, NA, y, NA, z)
l =  from3d(ll, offset, maxz, minz)

par(mfrow = c(1, 2))
par(mar = rep(0,4))
plot.new()
plot.window(xlim = c(min(circ[,1],na.rm = TRUE), 3607103*1.02), 
            ylim = c(min(circ[,2],na.rm = TRUE), 2873898*1.1), asp = 1)
lines(circ)
lines(l0)
text(l[c(2,5,8),], labels = c("x", "y", "z"), col = 'red')
# add POINT(60 47)
p = st_as_sfc("POINT(60 47)", crs = 4326) %>% st_transform("+proj=geocent")
p = p[[1]]
pts = rbind(c(0,0,0), c(p[1],0,0), c(p[1],p[2],0), c(p[1],p[2],p[2]))
ptsl = from3d(pts, offset, maxz, minz)
lines(ptsl, col = 'blue', lty = 2, lwd = 2)
points(ptsl[4,1], ptsl[4,2], col = 'blue', cex = 1, pch = 16)

plot.new()
plot.window(xlim = c(min(circ[,1],na.rm = TRUE), 3607103*1.02), 
            ylim = c(min(circ[,2],na.rm = TRUE), 2873898*1.1), asp = 1)
lines(circ)

p = st_as_sfc("POINT(60 47)", crs = 4326) %>% st_transform("+proj=geocent")
p = p[[1]]
pts = rbind(c(0,0,0), c(p[1],p[2],p[3]))
pt =  from3d(pts, offset, maxz, minz)
lines(pt)
points(pt[2,1], pt[2,2], col = 'blue', cex = 1, pch = 16)

p0 = st_as_sfc("POINT(60 0)", crs = 4326) %>% st_transform("+proj=geocent")
p0 = p0[[1]]
pts = rbind(c(0,0,0), c(p0[1],p0[2],p0[3]))
pt =  from3d(pts, offset, maxz, minz)
lines(pt)

p0 = st_as_sfc("POINT(0 0)", crs = 4326) %>% st_transform("+proj=geocent")
p0 = p0[[1]]
pts = rbind(c(0,0,0), c(p0[1],p0[2],p0[3]))
pt =  from3d(pts, offset, maxz, minz)
lines(pt)

p0 = st_as_sfc("POINT(0 90)", crs = 4326) %>% st_transform("+proj=geocent")
p0 = p0[[1]]
pts = rbind(c(0,0,0), c(p0[1],p0[2],p0[3]))
pt =  from3d(pts, offset, maxz, minz)
lines(pt, lty = 2)

p0 = st_as_sfc("POINT(90 0)", crs = 4326) %>% st_transform("+proj=geocent")
p0 = p0[[1]]
pts = rbind(c(0,0,0), c(p0[1],p0[2],p0[3]))
pt =  from3d(pts, offset, maxz, minz)
lines(pt, lty = 2)

f1 = rbind(cbind(0:60, 0))
arc = st_sfc(st_linestring(f1), crs=4326)
geoc = st_transform(arc, "+proj=geocent")
cc = rbind(geoc[[1]])
circ = from3d(cc, offset, maxz, minz)
lines(circ, col = 'red', lwd = 2, lty = 2)

f1 = rbind(cbind(60, 0:47))
arc = st_sfc(st_linestring(f1), crs=4326)
geoc = st_transform(arc, "+proj=geocent")
cc = rbind(geoc[[1]])
circ = from3d(cc, offset, maxz, minz)
lines(circ, col = 'blue', lwd = 2, lty = 2)

text(pt[1,1]+100000, pt[1,2]+50000, labels = expression(phi), col = 'blue') # lat
text(pt[1,1]+20000, pt[1,2]-50000, labels = expression(lambda), col = 'red') # lng


