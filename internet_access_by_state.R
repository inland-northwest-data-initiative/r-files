
library(tidycensus)
library(ggplot2)
library(dplyr)
library(reshape2)
library(mapview)

#Get the shape file
census_api_key("4b8e206a26dcf3fb692e924c9b2dcf67d3ec030a")
Sys.getenv("CENSUS_API_KEY")
spok_shapes <- get_acs(geography = "state",
                       variables = "B00001_001",
                       geometry = TRUE)
v17 <- load_variables(2017, "acs5", cache = FALSE)
unique(v17$concept)

##datasets to get by concept
concepts <- c("PRESENCE AND TYPES OF INTERNET SUBSCRIPTIONS IN HOUSEHOLD")
v17sub2 <- v17[v17$concept %in% concepts, ]
spok <- get_acs(geography = "state",
                variables = v17sub2$name)
spok2 <- merge(spok, v17sub2, by.x = "variable", by.y = "name", all.x = TRUE)
spok2a <- subset(spok2, concept == "PRESENCE AND TYPES OF INTERNET SUBSCRIPTIONS IN HOUSEHOLD")
spok2b <- select(spok2a, c(2:6))
spok_cast <- spok2b %>% dcast(GEOID + NAME ~ label, value.var = "estimate")
spok_cast$have_internet <- (spok_cast$`Estimate!!Total!!With an Internet subscription`/spok_cast$`Estimate!!Total`)*100
spok_cast$have_broadband <- (spok_cast$`Estimate!!Total!!With an Internet subscription!!Broadband of any type`/spok_cast$`Estimate!!Total`)*100
spok_cast$have_highspeed <- (spok_cast$`Estimate!!Total!!With an Internet subscription!!Broadband such as cable fiber optic or DSL`/spok_cast$`Estimate!!Total`)*100
spok_shapes2 <- select(spok_shapes, GEOID, geometry)
spok3 <- merge(spok_shapes2, spok_cast, by = "GEOID", all.x = TRUE)

##Plot the data
#mapview(spok3, zcol = "have_internet", legend = TRUE)
#mapview(spok3, zcol = "have_broadband", legend = TRUE)
mapview(spok3, zcol = "have_highspeed", legend = TRUE)