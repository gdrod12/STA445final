#packages
library(tidyverse)
library(janitor)
library(readxl)
library(rvest)
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

#World cup
#url for page
url<-'https://en.wikipedia.org/wiki/FIFA_World_Cup'
#reading html for url
page <- read_html(url)
#reading in table
table<-page %>%
  html_nodes('table') %>%
  #fourth table is the right one
  .[[4]] %>%
  html_table( fill=TRUE) %>%
  row_to_names(row_number=1)
World_Cup <- table %>%
  reframe(Year=as.numeric(Year), Hosts, Matches=as.numeric(Matches),
          #removing commas and converting to numeric data type
          Totalattendance=as.numeric(str_remove_all(`Totalattendance †`, ',')),
          Averageattendance=as.numeric(str_remove_all(Averageattendance, ','))) %>%
  #filtering years
  filter(Year<=2024)
head(World_Cup)
World_Cup <- World_Cup %>%
  reframe(WorldCup=paste(Year, Hosts, sep=""),
          Matches,
          Totalattendance,
          Averageattendance) %>%
  mutate(WorldCup=str_remove_all(WorldCup, " "))
usethis::use_data(World_Cup, overwrite=TRUE)
?RodriguezWorldPopulation
