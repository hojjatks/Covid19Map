PlotWorldMap <-
  function(DayP=20,MonthP=10,YearP=2020,TypeP="New Death")
  {
    #' @title Plot World map
    #' @description This function is to plot the Covid-19 situation in a specific date, in specific type of data
    #' @param DayP is the day that you want to plot the data
    #' @param MonthP is the month that you want to plot the data
    #' @param YearP is the year that you want to plot the data
    #' @param TypeP is the type of data that you want to show (eg."New Death" or "New Case")
    #' @return A pretty figure
    #' @examples
    #' Covid19Map::PlotWorldMap(DayP=20,MonthP=10,YearP=2020,TypeP="New Death")
    library(ggmap)

    mydata<-Covid19Map::GetFullTimeseries()
    mydata %>%
      filter(Year==YearP,Month==MonthP,day==DayP,Type==TypeP)->dataP
    map.world <- map_data("world")
    country_shapes <- geom_polygon(aes(x = long, y = lat, group = group),
                                   data = map_data('world'),
                                   fill = "#CECECE", color = "#515151",
                                   size = 0.15)
    mapcoords <- coord_fixed(xlim = c(-150, 180), ylim = c(-55, 80))

    theme_transp_overlay <- theme(
      panel.background = element_rect(fill = "transparent", color = NA),
      plot.background = element_rect(fill = "transparent", color = NA)
    )
    maptheme <- theme(panel.grid = element_blank()) +
      theme(axis.text = element_blank()) +
      theme(axis.ticks = element_blank()) +
      theme(axis.title = element_blank()) +
      theme(legend.position = "bottom") +
      theme(panel.grid = element_blank()) +
      theme(panel.background = element_rect(fill = "#596673")) +
      theme(plot.margin = unit(c(0, 0, 0.5, 0), 'cm'))

    p_base <- ggplot() + country_shapes + mapcoords + maptheme+

    geom_point(data = dataP, aes(x=Long, y=Lat, size =dailynum))
    p_base


    }
