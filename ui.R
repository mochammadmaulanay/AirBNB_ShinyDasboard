# Home Tab
home_tab <- tabPanel(title = "Home",
                     icon = icon("home"),
                     imageOutput("logo", height = 225),
                     br(),
                     hr(style = "border-top: 1px solid #d1d1d1; margin-left: 30px; margin-right: 30px"),
                     
                     h1(style = "text-align:center",
                        strong("What is", a(style = "color: #ff5a60",
                                            href = "https://www.airbnb.com/", 
                                            "Airbnb"), "?")),
                     
                     p(style = "text-align:justify; font-size: 16px; margin-left: 30px; margin-right: 30px",
                       "Airbnb, originally AirBedandBreakfast, is an American company founded by Brian Chesky, Nathan Blecharczyk, and Joe Gebbia in 2007. It 
                       provides an online marketplace that connects People who want to rent out their properties with people (or tourists) looking for 
                       accomodations. Currently, it has 5.6M listings worldwide covering more than 100.000 cities across 220+ countries and regions. The platform 
                       provided can be accessed via web or mobile app. It enables hosts to accomodate tourists with lodging and tourism-related activities, 
                       while users can search for available lodgings in a specific locale using many filters such as logding types, dates, and price."),
                     
                     br(),
                     
                     h1(style = "text-align:center",
                        strong("About the Data")),
                     
                     p(style = "text-align: justify; font-size: 16px; margin-left: 30px",
                       "The dataset used in this dashboard is the", em("New York City Airbnb Open Data"), "obtained from", 
                       a(style = "color: #ff5a60", href = "https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data", "Kaggle"), ". This dataset describes 
                       the listing activity and metrics of Airbnb in New York City during 2019."))

# Bar Tab
bar_tab <- tabPanel(title = "Top - N Listings",
                    icon = icon("chart-bar"),
                    
                    fluidRow(
                      
                      sidebarPanel(
                        width = 3,
                        h2(strong("Filter")),
                        hr(style = "border-top: 1px solid #000000"),
                        
                        sliderInput(inputId = "top_n",
                                    label = "Number of Listings to Display",
                                    min = 1,
                                    max = 10,
                                    value = 5),
                        
                        checkboxGroupInput(inputId = "borough",
                                           label = "Location (Borough)",
                                           choices = unique(ab_nyc$borough),
                                           selected = unique(ab_nyc$borough)),
                        
                        selectInput(inputId = "room_type",
                                    label = "Room Type",
                                    choices = unique(ab_nyc$room_type)),
                        
                        numericInput(inputId = "price",
                                     label = "Budget ($)",
                                     value = max(ab_nyc$price),
                                     min = min(ab_nyc$price),
                                     max = max(ab_nyc$price),
                                     step = 100),
                        
                        submitButton(text = "Apply Filter"),
                      ),
                      
                      column(
                        width = 9,
                        useShinydashboard(),
                        
                        h1(style = "text-align: center; color: #2c3e50",
                        strong(textOutput("top_listing"))),
                        br(),
                        
                        fluidRow(
                          valueBoxOutput("location"),
                          valueBoxOutput("reviews"),
                          valueBoxOutput("price"),
                        ),
                        
                        box(
                          title = NULL,
                          width = 12,
                          plotlyOutput("bar_plot")
                        )
                      )
                    ))

# Data Tab
data_tab <- tabPanel(title = "Data",
                     icon = icon("table"),
                     dataTableOutput("dataframe"))

# Map Tab
map_tab <- tabPanel(title = "Bubble Map",
                    icon = icon("map-marked-alt"),
                    
                    titlePanel(
                      h1(strong("Airbnb Listings in New York City"), align = "center")
                      ),
                    
                    br(),
                    
                    box(
                      width = "100%",
                      leafletOutput("map", width = "100%", height = 600)
                    ))


# App UI
navbarPage(title = span(tagList(icon("airbnb"), "airbnb")),
           theme = shinytheme("flatly"),
           home_tab,
           bar_tab,
           data_tab,
           map_tab
)