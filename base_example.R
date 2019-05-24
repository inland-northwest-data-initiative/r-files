library(tidycensus)
library(mapview)

census_api_key("4b8e206a26dcf3fb692e924c9b2dcf67d3ec030a")
Sys.getenv("CENSUS_API_KEY")

spok_shapes <- get_acs(geography = "tract",
                       variables = "B00001_001",
                       state = "WA",
                       county = "Spokane",
                       geometry = TRUE)

mapview(spok_shapes, zcol = "estimate", legend = TRUE)
