#' Plot a country's population in a time series
#'
#'This function takes a country name as an input and graphs its
#' population from 1950-2020. Countries not within the dataset return
#' an error.
#'
#'
#' @param name Desired country's name
#' @return A plot of the country's population over time
#' @examples
#' CountryPopulation("Mexico")
#' @export
CountryPopulation <- function(name) {
  title <- paste("Population of", name, "over time", sep=" ")
  if (nrow(WorldPopulation %>%
           filter(countryName==name))>0) {
  ggplot(data=WorldPopulation %>%
           filter(countryName==name), aes(x=Year, y=Population)) +
    geom_point() +
    scale_x_discrete(breaks=c(1950, 1960, 1970, 1980, 1990, 2000, 2010, 2020)) +
    theme_classic()+
    ggtitle(title)
  }
  else {
    errormessage <- paste(name, " is not in the dataset", sep="")
    print(errormessage)
  }
}
