library('dplyr')
library('leaflet')
library('exifr')
library('leafpop')
library('sf')

souls <- read.csv(file = "LostSouls/souls.csv", header=TRUE)
Images<-as.character(souls$name)
Images0<-normalizePath(Images)
dat <- read_exif(Images0, tags = c("FileName", "GPSLatitude", "GPSLongitude"))
soulMap<-data.frame(souls$icon, souls$name, dat$GPSLatitude, dat$GPSLongitude)

projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
dat2 <- st_as_sf(x = dat,
                coords = c("GPSLongitude","GPSLatitude"),
                crs = projcrs)

SoulIcons <- iconList(
  soul0 = makeIcon("LostSouls/Soul0.png", iconRetinaUrl = NULL, 40,40),
  soul1 = makeIcon("LostSouls/Soul1.png", iconRetinaUrl = NULL, 40, 40),
  rose = makeIcon("LostSouls/Rose.png", iconRetinaUrl = NULL, 40, 40),
  soul2 = makeIcon("LostSouls/soul2.png", iconRetinaUrl = NULL, 40, 40),
  soul3 = makeIcon("LostSouls/soul3.png", iconRetinaUrl = NULL, 40, 40)
)

m<-leaflet(soulMap) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(icon=~SoulIcons[souls.icon],
             lat = soulMap$dat.GPSLatitude,
             lng = soulMap$dat.GPSLongitude,
             clusterOptions = markerClusterOptions()
 )
  


m
