library(leaflet)
library(raster)

# get crs of points
crs <- crs(shapefile("M:/CRC RISK/Data/ACT/StateWideIgnProb/ign500m.shp"))

# read in the csv

i25 <- read.csv("M:/CRC RISK/Data/ACT/StateWideIgnProb/500m_IGPROB25.csv")
i50 <- read.csv("M:/CRC RISK/Data/ACT/StateWideIgnProb/500m_IGPROB50.csv")
i75 <- read.csv("M:/CRC RISK/Data/ACT/StateWideIgnProb/500m_IGPROB75.csv")
i130 <- read.csv("M:/CRC RISK/Data/ACT/StateWideIgnProb/500m_IGPROB130.csv")

# merge all the data
alldata <- data.frame(i25$xco,i25$yco,i25$prob,i50$prob,i75$prob,i130$prob)
colnames(alldata) <- c("x","y","prob25","prob50","prob75","prob130")

allpoints <- SpatialPointsDataFrame(alldata[,c(1,2)],alldata,proj4string= crs)

shapefile(allpoints,"M:/CRC RISK/Data/ACT/StateWideIgnProb/ignFFDI_all.shp")
write.csv(alldata,"M:/CRC RISK/Data/ACT/StateWideIgnProb/IgnProb_ACT.csv")
#leaflet


ign <- spTransform(allpoints, CRS("+proj=longlat +datum=WGS84 +no_defs"))

pal <- colorNumeric("YlOrRd", domain = c(0,1))

map <- leaflet(countries) %>% addTiles()

map %>% 
  addCircleMarkers(radius = .5, color = ~pal(prob130)
    )%>% 
    addLegend("bottomright", pal = pal, values = c(0,1),
            title = "Ignition Probability",
            opacity = 1)


# leaflet raster


r <- raster("M:/CRC RISK/Data/ACT/StateWideIgnProb/rasters/ign25.tif")
pal <- colorNumeric(c("#7bc3e0","#edd99a", "#ff9b44", "#ff0000","#ba0000"), domain = c(0,1),
                    na.color = "transparent")

leaflet() %>% addTiles() %>%
  addRasterImage(r, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = c(0,1),
            title = "Ignition Probability")



?colorNumeric






