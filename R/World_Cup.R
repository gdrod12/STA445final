#'World_Cup
#'
#'This dataset contains the number of matches, attendance, and average attendance for
#'every Fifa World Cup. The data was acquired from Wikipedia
#url for page
#' @format A data frame with 22 observations with 4 columns.
#' \describe{
#'      \item{WorldCup}{Identification of world cup with year and host}
#'      \item{Matches}{Number of matches played}
#'      \item{Totalattendance}{Total people attended}
#'      \item{Averageattendance}{Average per match attendance}
#'}
#' @source \url{https://en.wikipedia.org/wiki/FIFA_World_Cup}
"World_Cup"

library(tidyverse)
library(janitor)
library(rvest)
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
