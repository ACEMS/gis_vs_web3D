#devtools::install_github('thomasp85/ambient')

## Thomas Pederson's example of noise-based terrain
library(ambient)
e <- new("Extent", xmin = -399385, xmax = -395571, 
         ymin = -44988, ymax = -42439) + 1500
uluru_dem <- raster("data/ELVIS_CLIP.tif")

## the noise field shares the extent with the original CLIP domain, but with an arbitrary resolution
noise <- setExtent(raster(noise_simplex(c(500, 600), fractal = "none")), extent(uluru_dem))
qm <- quadmesh(crop(uluru_dem, e))
qm$material$col <- viridis::viridis(36)[scales::rescale(raster::extract(noise, t(qm$vb[1:2, ]), 
                                                                        method = "bilinear"), 
                                                        c(1, 36))][qm$ib]
rgl.clear()
shade3d(qm); aspect3d(1, 1, 0.2) ; rglwidget()


plot(noise, col = viridis::viridis(36))
contour(uluru_dem, add = TRUE)

