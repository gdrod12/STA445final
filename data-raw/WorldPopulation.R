#'WorldPopulation
#'
#'This dataset contains the yearly population of countries since 1950 in long form.
#' @format A data frame with 16685 observations with 3 columns.
#' \describe{
#'      \item{countryName}{Name identification of country}
#'      \item{Year}{Year of measurement}
#'      \item{Population}{Population of country in given year}
#'}
#' @source \item{World_Population.xlsx}
"WorldPopulation"
#packages
library(tidyverse)
library(readxl)
#World population
data<-read_xlsx("data-raw/World_Population.xlsx", sheet="ESTIMATES", skip=14) %>%
  row_to_names(row_number=1)
WorldPopulation <- data %>%
  filter(Type=="Country/Area")
colnames(WorldPopulation)[3] <- "countryName"
WorldPopulation$Index <- NULL
WorldPopulation$Variant <- NULL
WorldPopulation$Notes <- NULL
WorldPopulation$`Country code` <- NULL
WorldPopulation$`Parent code` <- NULL
WorldPopulation$Type <- NULL
WorldPopulation<-pivot_longer(WorldPopulation, cols=2:72, names_to="Year")
WorldPopulation <- WorldPopulation %>%
  reframe(countryName, Year, Population=as.numeric(value))
usethis::use_data(WorldPopulation, overwrite = TRUE)



