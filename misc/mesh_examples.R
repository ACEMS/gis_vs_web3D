

## volcano is a staple

library(raster)
rvolcano <- raster(volcano)
library(quadmesh)
qm_volcano <- quadmesh(rvolcano)
library(rgl)
rgl.clear()
shade3d(qm_volcano, col = "grey"); aspect3d(1, 1, 0.25); rglwidget()


## 
data("etopo", package = "quadmesh")
qm_etopo <- quadmesh(crop(etopo, extent(80, 160, -50, 10)))
qm_etopo$material$col <- colourvalues::colour_values(qm_etopo$vb[3, qm_etopo$ib])
rgl.clear()
shade3d(qm_etopo); aspect3d(1, 1, .2); rglwidget()


## polygons (only on Github)

library(sf)
north_carolina <- read_sf(system.file("gpkg/nc.gpkg", package = "sf"))
north_carolina <- st_transform(north_carolina, 
                               "+proj=laea +lon_0=-80 +lat_0=35 +datum=WGS84")

library(silicate)
library(anglr)
data("gebco1", package = "anglr")
mesh_nc <- DEL(north_carolina, max_area = 1e9)
## copy down values from a raster (continuous measure)
mesh_nc <- copy_down(mesh_nc, gebco1)

## plot it
rgl.clear()
plot3d(mesh_nc); aspect3d(1, 1, .2); rglwidget()


## another example, copy feature attributes (discrete measure)
rgl.clear()
mesh_sid <- copy_down(DEL(north_carolina, max_area = 1e9), "SID79")
plot3d(mesh_sid); aspect3d(1, 1, .2); rglwidget()

# Create and texture a 3D mesh in R from a variety of spatial data sources (e.g.
# Shapefile + digital elevation model + satellite raster).


library(quadmesh)
library(raster)
bm_url <- "https://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73909/world.topo.bathy.200412.3x5400x2700.jpg"
bm_file <- basename(bm_url)
if (!file.exists(bm_file)) download.file(bm_url, bm_file)

bm_rgb <- raster::setExtent(raster::brick(bm_file), raster::extent(-180, 180, -90, 90))
projection(bm_rgb) <- "+proj=longlat +datum=WGS84"

bm_rgb <- raster::aggregate(bm_rgb, fact = 10)
south <- quadmesh(etopo, texture = bm_rgb)
south$vb[3, ] <- south$vb[3, ] * 20
south$vb[1:3, ] <- t(llh2xyz(t(south$vb[1:3, ])))
rgl.clear() 
shade3d(south)
aspect3d(1, 1, 0.5)
rglwidget()
