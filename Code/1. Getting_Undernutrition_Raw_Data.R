# Packages
library(tidyverse)
library(rvest) 

# Links
Link <- "http://portalsivigila.ins.gov.co/Microdatos/Datos_2018_113.csv"

## File location
Location <- "RawData/Malnutrition.csv"

# Download
if(!dir.exists("RawData"))
   {
    dir.create("RawData")
   }

if(!file.exists(Location))
   {
    download.file(Link, destfile = Location, mode = "wb")
   }

# Read   
Malnutrition <- read.csv(Location)

# Remove 
rm(list = setdiff(ls(), c("Undernutrition", "Demography")))

# Save data frame   
if(!file.exists("Rdata"))
   {
    dir.create("Rdata")
   }
   
save(Undernutrition, file = "Rdata/Undernutrition.rda")
   
   