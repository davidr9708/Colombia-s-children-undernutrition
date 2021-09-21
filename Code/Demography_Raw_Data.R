# Packages
library(tidyverse)
library(rvest) 


# Links
url <- "http://microdatos.dane.gov.co/index.php/catalog/643/get_microdata" 

Links <-
  read_html(url) %>% 
  html_nodes('input') %>% html_attr("title")

Links <- Links[!is.na(Links)]


## File's location
File.names <- 
  str_replace(str_match(Links, "[:digit:]+_[:alpha:]+.zip"), "_","")

Zip.location <- paste("RawData/", File.names, sep = "")

Folder.location <- str_match(Zip.location, ".+(?=.zip)")


# Download and read
Demography <- data.frame()

if (!dir.exists("RawData"))
  {
  dir.create("RawData")
  }

for(i in 1:length(Links))
  {
  if(!dir.exists(Folder.location[i]))
    {
     download.file(url = Links[i], destfile = Zip.location[i], mode = "wb")
     unzip(zipfile = Zip.location[i], exdir ="RawData")
    }
  
  People.zip <- str_subset(list.files(Folder.location[i]), ".*CSV.zip$")
  
  People.location <- paste0(Folder.location, "/", People.zip)
  
  unzip(zipfile = People.location[i], exdir = Folder.location[i])
  
  
  ## Reading the file
  People.CSV <- str_subset(list.files(Folder.location[i]), ".+PER.+")
  
  Demography.location <- paste0(Folder.location, "/", People.CSV, sep = "")
  
  Demography.department <- 
    read.csv(Demography.location[i]) %>% 
    select(U_DPTO, U_MPIO, P_SEXO, P_EDADR, PA1_GRP_ETNIC)
  
  Demography <- rbind(Demography,Demography.department)
  
  
  ## Remove zip
  unlink(Zip.location[i], recursive = TRUE)
  }


# Remove folders and variables
unlink(Folder.location, recursive = TRUE)

rm(list = setdiff(ls(), c("Undernutrition", "Demography")))


# Save data frame   
if(!file.exists("Rdata"))
  {
   dir.create("Rdata")
  }

save(Demography, file = "Rdata/Demography.rda")
