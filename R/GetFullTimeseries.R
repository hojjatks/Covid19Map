GetFullTimeseries <-
  function()
  {
    library(RCurl)
    library(tidyverse)
    library(dplyr)
    library(stringr)
    library(lubridate)

    #' @title Get full Timeseries
    #' @description This function is a without input function that elicit the Covid data time-series from John Hopkins University data center in github, cleans it and returns it to you.
    #' @return A data frame containing Country,Latitude and Longitude, Number of new cases death in each day
    #' @examples
    #'   Covid19Map:: GetFullTimeseries()

    case_raw <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
    case <- read.csv(text = case_raw)
    death_raw<- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
    death<-read.csv(text = death_raw)
    case %>%
      pivot_longer(cols = starts_with("X"),
                   names_to = "Date",
                   values_to = "Num",
                   values_drop_na = TRUE)->tidy_case
    death %>%
      pivot_longer(cols = starts_with("X"),
                   names_to = "Date",
                   values_to = "Num",
                   values_drop_na = TRUE)->tidy_death


    tidy_case %>%
      mutate(Date=mdy(str_sub(Date, 2, -1))) %>%
      mutate(Year=year(Date),Month=month(Date),day=day(Date)) %>%
      group_by(Country.Region,Date) %>%
      select(-Province.State) %>%
      mutate(Type="New Case")->tidy_case2
    tidy_death %>%
      mutate(Date=mdy(str_sub(Date, 2, -1))) %>%
      mutate(Year=year(Date),Month=month(Date),day=day(Date)) %>%
      group_by(Country.Region,Date) %>%
      select(-Province.State) %>%
      mutate(Type="New Death")->tidy_death2
    tidy_case2 %>%
      rbind(tidy_death2)->output
    output %>%
      group_by(Country.Region,Type) %>%
      mutate(dailynum=Num-lag(Num)) ->output1
    output1 %>%
      group_by(Country.Region,Date,Type) %>%
      mutate(dailynum=sum(dailynum),Lat=mean(Lat),Long=mean(Long))->output2
  output=output2

  }
#sticker(subplot = data_path,package = "Covid19Map",filename = file_dest,p_size = 20,p_y=1.5,p_x=1,p_family = "incon",s_height=1*.4,s_width  = 1.44*.4,s_x = 1,s_y=.8,h_fill = "#b4ecec",p_color = "red",h_color = "#2A5773")
