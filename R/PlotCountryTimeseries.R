PlotCountryTimeseries <-
  function(FromDate,
           ToDate,
           Country="Iran",TypeP="New Death")
  {
    #' @title Plot Country Time-series
    #' @description This function is to plot the time-series of a the Covid-19 in a specific country, within specific days and type of data
    #' @param FromDate is the starting date (eg. "1.1.2020").
    #' @param ToDdate is the Finishing date.
    #' @param country is the country that you want to see the time-series of the data
    #' @param TypeP is the type of data that you want to show (eg."New Death" or "New Case")
    #' @return A pretty figure
    #' @examples
    #'Covid19Map::PlotCountryTimeseries(FromDate="2020.2.1",
    #'                                  ToDate="2020.8.1",
    #'                                  Country="Iran",TypeP="New Death")
    #'

    mydata<-Covid19Map::GetFullTimeseries()
    mydata %>%
      filter(Country.Region==Country,Type==TypeP) %>%
      filter(ymd(Date) %within% interval(ymd(FromDate),ymd(ToDate))) %>%
      arrange(Date) ->dataP

    dataP %>%
      ggplot(aes(x = Date, y = dailynum)) +
      geom_line( size = 1)+
      geom_smooth(method = "gam")

    }
