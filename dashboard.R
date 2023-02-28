#imports
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(tidyverse)
library(ggplot2)
library(plotly)
library(lubridate)

#import data
df = read.csv('./data/vgsales-cleaned.csv', stringsAsFactors = TRUE)

#R specific data cleaning
#top games
df[, 'Name_short'] = substr(df[, "Name"], 1, 20)
N = 5
#pie chart
bars = data.frame(
  'counts' = unname(summary(df$Genre)),
  'category' = levels(df$Genre)
)
bars$percentage = round(bars$counts*100 / sum(bars$counts))
#heatmap
df$Platform_grouped = factor(df$Platform_grouped, levels = c("Other", "Xbox", "Sega", "PlayStation", "Nintendo(handheld)", 
                                                             "Nintendo(console)", "Computer", "Atari"))
counts = df %>% 
  dplyr::filter(Publisher_grouped != 'other') %>%
  droplevels(.) %>% 
  count(Genre, Publisher_grouped)
#sales_hist
#   none
#sales_time
df[,'Year'] = year(as.Date(df[,'Year']))
CI = df %>%
  group_by(Year) %>%
  summarize(
    low = sum(Global_Sales) - length(Global_Sales)*qt(0.999,df=nrow(df)-1)*sd(Global_Sales)/sqrt(nrow(df)),
    mean = mean(Global_Sales),
    sum = sum(Global_Sales),
    high = sum(Global_Sales) + length(Global_Sales)*qt(0.999,df=nrow(df)-1)*sd(Global_Sales)/sqrt(nrow(df)),
    row = length(Global_Sales)
  )

#map
codes = read.csv('./data/plotly_countryCodes.csv')
codes = codes[,-2]
#adding sales
codes$sales = NA
na = c("Canada", "United States", "Mexico", "Nicaragua", "Honduras", 
       "Cuba", "Guatemala", "Panama", "Costa Rica", "Dominican Republic", 
       "Haiti", "Belize", "El Salvador", "Bahamas, The", "Jamaica", 
       "Trinidad and Tobago", "Dominica", "Saint Lucia", "Antigua and Barbuda", 
       "Barbados", "Saint Vincent and the Grenadines", "Grenada", 
       "Saint Kitts and Nevis")
eu = c('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 
       'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 
       'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 
       'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 
       'Slovakia', 'Slovenia', 'Spain', 'Sweden')
codes[codes[,'COUNTRY'] %in% na,'sales'] = sum(df$NA_Sales)
codes[codes[,'COUNTRY'] %in% eu,'sales'] = sum(df$EU_Sales)
codes[codes[,'COUNTRY'] == 'Japan','sales'] = sum(df$JP_Sales)
codes[is.na(codes[,'sales']),'sales'] = sum(df$Other_Sales)

#adding names
codes$names = NA
codes[codes[,'COUNTRY'] %in% na,'names'] = 'North America'
codes[codes[,'COUNTRY'] %in% eu,'names'] = 'European Union'
codes[codes[,'COUNTRY'] == 'Japan','names'] = 'Japan'
codes[is.na(codes[,'names']),'names'] = 'Other'






#########################
## APPLICATION
#########################
#https://dash-bootstrap-components.opensource.faculty.ai/docs/components/layout/


# Create a Dash app
app <- dash_app()

#stylesheet
app <- Dash$new(external_stylesheets = dbcThemes$YETI)

#sourcing plots
setwd('./plot_functions')
sapply(list.files(), source)
setwd('..')

app %>% set_layout(
  dbcContainer(
    dbcTabs(
      id='all-tabs',
      children=list(
        dbcTab(children=list(
          #htmlDiv(
          #id='tab1-div',
          #children=list(
            h1('Video Games: A History'),
            h3('Geographic Sales Distribution'), 
            dbcRow(children=list(
              dbcCol(children=list(
                dccGraph(
                figure = ggplotly(map),
                style = list("height" = '40vh', width='65vw')
                )
              ), 
              md=12
              ),
              dbcCol(children = list(
                dccGraph(
                  figure = ggplotly(sales_time),
                  style = list("height" = '35vh', width='65vw')
                ),
                dccRangeSlider(
                  id='yearslider',
                  max=1980, 
                  min=2016, 
                  value=list(1980,2016),
                  step=1, 
                  allowCross = FALSE,
                  vertical=FALSE
                )
                ), 
                md=12
                )
              )
            )),
            #align = "center"
          #)), 
          label = 'Geography'
        ),
        dbcTab(children = list(
          #htmlDiv(children=list(
            h1('Video Games: A History'),
            h3('Categorical Breakdown'),
            dbcRow(children=list(
              dbcCol(
                dccGraph(
                  figure = heatmap2,
                  style = list("height" = '70vh', width='65vw')
                  #)
                )#,
                #md = 8
              ),
              dbcCol(children=list(
                dccDropdown(
                id='hm-dropdown1',
                options=list(
                  list(label = "Genre", value = "Genre"),
                  list(label = "Publisher", value = "Publisher"),
                  list(label = "Platform", value = "Platform")
                ),
                value="Genre"
                ),
                dccDropdown(
                  id='hm-dropdown2',
                  options=list(
                    list(label = "Genre", value = "Genre"),
                    list(label = "Publisher", value = "Publisher"),
                    list(label = "Platform", value = "Platform")
                  ),
                  value="Platform"
                )
                )#,
                #md = 4
              )
            )#),
          )),
          label='Breakdown'
        ),
        dbcTab(children = list(
          #htmlDiv(children = list(
            h1('Video Games: A History'),
            h3('Top Games'),
            dbcCol(children = list(
              dccGraph(
                figure = ggplotly(topgames),
                style = list("height" = '70vh', width='65vw')
              )
            ), 
            md = 6
            ),
            dbcCol(children = list(
              h3('Filters:'),
              p('Region'),
              dccDropdown(
                id='top-dropdown1', 
                options=list(
                  list(label = "Global", value = "Global_Sales"),
                  list(label = "North America", value = "NA_Sales"),
                  list(label = "European Union", value = "EU_Sales"),
                  list(label = "Japan", value = "JP_Sales"),
                  list(label = "Other", value = "Other_Sales")
                ),
                value="Global_Sales"
              ),
              p('Genre'),
              dccDropdown(
                id='top-dropdown2', 
                options=list(
                  list(label = "All", value = "??"),
                  list(label = "Action", value = "Action"),
                  list(label = "Adventure", value = "Adventure"),
                  list(label = "Fighting", value = "Fighting"),
                  list(label = "Platform", value = "Platform"),
                  list(label = "Puzzle", value = "Puzzle"),
                  list(label = "Racing", value = "Racing"),
                  list(label = "Role-Playing", value = "Role-Playing"),
                  list(label = "Shooter", value = "Shooter"),
                  list(label = "Simulation", value = "Simulation"),
                  list(label = "Sports", value = "Sports"),
                  list(label = "Strategy", value = "Strategy"),
                  list(label = "Misc", value = "Misc")
                ),
                value="All"
              ),
              p('Publisher'),
              dccDropdown(
                id='top-dropdown3', 
                options=list(
                  list(label = "All", value = "??"),
                  list(label = "Activision", value = "Activision"),
                  list(label = "Electronic", value = "Electronic"),
                  list(label = "Konami", value = "Konami"),
                  list(label = "Namco", value = "Namco"),
                  list(label = "Nintendo", value = "Nintendo"),
                  list(label = "Sega", value = "Sega"),
                  list(label = "Sony", value = "Sony"),
                  list(label = "THQ", value = "THQ"),
                  list(label = "Ubisoft", value = "Ubisoft"),
                  list(label = "Other", value = "other")
                ),
                value="All"
              ),
              dccDropdown(
                id='top-dropdown4', 
                options=list(
                  list(label = "All", value = "??"),
                  list(label = "Atari", value = "Atari"),
                  list(label = "Personal Computer", value = "Computer"),
                  list(label = "Nintendo Console", value = "Nintendo(console)"),
                  list(label = "Nintendo Handheld", value = "Nintendo(handheld)"),
                  list(label = "PlayStation", value = "PlayStation"),
                  list(label = "Sega", value = "Sega"),
                  list(label = "Xbox", value = "Xbox"),
                  list(label = "Other", value = "Other")
                ),
                value="All"
              ),
              dccRangeSlider(
                id='yearslider',
                max=1980, 
                min=2016, 
                value=list(1980,2016),
                step=1, 
                allowCross = FALSE,
                vertical=FALSE
              )
            ),
            md = 4
            )),
          #)),
          label='Top Games'
        ),
        dbcTab(children = list(
          h1('Video Games: A History'),
          h3('Sales Count and Categorical Proportions'),
          dbcRow(children = list(
            dbcCol(children = list(
              dccDropdown(
                id='count-dropdown1', 
                options=list(
                  list(label = "Global", value = "Global_Sales"),
                  list(label = "North America", value = "NA_Sales"),
                  list(label = "European Union", value = "EU_Sales"),
                  list(label = "Japan", value = "JP_Sales"),
                  list(label = "Other", value = "Other_Sales")
                ),
                value="Global_Sales"
              ),
              dccGraph(
                figure = ggplotly(sales_hist),
                style = list("height" = '50vh')
              )
            )),
            dbcCol(children = list(
              dccDropdown(
                id='count-dropdown2',
                options=list(
                  list(label = "Genre", value = "Genre"),
                  list(label = "Publisher", value = "Publisher"),
                  list(label = "Platform", value = "Platform")
                ),
                value="Genre"
              ),
              dccGraph(
                figure = ggplotly(piechart, dynamicTicks = FALSE),
                style = list("height" = '50vh')
              )
            ))
          ))
        ),
        label='Count'
        )
      )
    )
  )
)


#callbacks

#app %>% add_callback(
#  
#)


# Run the app
app %>% run_app()
