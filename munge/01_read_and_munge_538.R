library(rvest)
library(tidyverse)
library(lubridate)
library(here)

#### ingest fivethirtyeight forecast and clean up
# fte_forecast <- read.csv(url("https://projects.fivethirtyeight.com/march-madness-api/2018/fivethirtyeight_ncaa_forecasts.csv"))

fte_forecast <- read_csv(here("data_raw", "fivethirtyeight_ncaa_forecasts.csv"))

fte_forecast <- fte_forecast %>%
  filter(gender == "mens") %>%
  mutate(forecast_date = ymd(forecast_date)) %>%
  filter(forecast_date == max(forecast_date)) %>%
  filter(rd1_win == 1) %>%
  select(team_name, team_region, rd2_win, rd3_win, rd4_win, rd5_win, rd6_win, rd7_win)

colnames(fte_forecast) <- c("team", "team_region", "R32", "R16", "R8", "R4", "NCG", "title")

