library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(tidyverse)
library(glue)
library(scales)
library(DT)
library(plotly)

# Data
ab_nyc <- read.csv("AB_NYC_2019.csv")

ab_nyc <- ab_nyc %>% 
  select(-c(id, host_id, last_review, reviews_per_month)) %>% 
  rename(borough = neighbourhood_group) %>% 
  
  mutate(across(c(borough, neighbourhood, room_type),
                factor)) %>% 
  
  mutate(room_type = recode(room_type, 
                            "Entire home/apt" = "Entire Home/Apartment",
                            "Private room" = "Private Room",
                            "Shared room" = "Shared Room"))