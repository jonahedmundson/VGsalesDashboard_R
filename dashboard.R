#imports
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(dplyr)
library(ggplot2)
library(plotly)
library(lubridate)

#import data
df = read.csv('./data/vgsales-cleaned.csv', stringsAsFactors = TRUE)

#R specific data cleaning
#top games
df[, 'Name_short'] = substr(df[, "Name"], 1, 24)
#pie chart
#
#heatmap
#
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







#########################
## APPLICATION
#########################
#https://dash-bootstrap-components.opensource.faculty.ai/docs/components/layout/


# Create a Dash app
app <- dash_app()

#stylesheet
app <- Dash$new(external_stylesheets = dbcThemes$LUX)

#sourcing plots
setwd('./plot_functions')
sapply(list.files(), source)
setwd('..')

app %>% set_layout(
  dbcContainer(children = list(
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
                #figure = map,
                id = 'map-figure',
                style = list("height" = '40vh', width='65vw')
                )
              ), 
              md=12
              ),
              dbcCol(children = list(
                dccGraph(
                  #figure = ggplotly(sales_time),
                  id='sales-time-figure',
                  style = list("height" = '35vh', width='65vw')
                ),
                htmlBr(),
                dccRangeSlider(
                  id='yearslider',
                  min=1980, 
                  max=2016, 
                  value=list(1980,2016),
                  step=1, 
                  marks=as.list(1980:2016),
                  allowCross = FALSE,
                  vertical=FALSE,
                  tooltip = list(
                    'always_visible' = TRUE,
                    'placement' = 'bottom'
                  )
                ),
                htmlBr()
                )#, 
                #md=12
                )
              )
            )),
            #align = "center"
          #)), 
          label = 'Geography'
        ),
        # dbcTab(children = list(
        #   #htmlDiv(children=list(
        #     h1('Video Games: A History'),
        #     h3('Categorical Breakdown'),
        #     dbcRow(children=list(
        #       dbcCol(
        #         dccGraph(
        #           #figure = heatmap2,
        #           id='heatmap-figure',
        #           style = list("height" = '70vh', width='65vw')
        #           #)
        #         )#,
        #         #md = 8
        #       ),
        #       dbcCol(children=list(
        #         h3('Text'),
        #         dccDropdown(
        #         id='hm-dropdown1',
        #         options=list(
        #           list(label = "Genre", value = "Genre"),
        #           list(label = "Publisher", value = "Publisher_grouped"),
        #           list(label = "Platform", value = "Platform_grouped")
        #         ),
        #         value="Genre"
        #         ),
        #         dccDropdown(
        #           id='hm-dropdown2',
        #           options=list(
        #             list(label = "Genre", value = "Genre"),
        #             list(label = "Publisher", value = "Publisher_grouped"),
        #             list(label = "Platform", value = "Platform_grouped")
        #           ),
        #           value="Platform_grouped"
        #         )
        #         )#,
        #         #md = 4
        #       )
        #     )#),
        #   )),
        #   label='Breakdown'
        # ),
        # dbcTab(children = list(
        #   #htmlDiv(children = list(
        #   h1('Video Games: A History'),
        #   h3('Breakdown2'),
        #   #dbcCol(children = list(
        #     dccGraph(
        #       figure = heatmap2,
        #       style = list("height" = '70vh', width='65vw')
        #     )
        #   ),
        #   #)),
        #   #)),
        #   label='Breakdown2'
        # ),
        dbcTab(children = list(
          #htmlDiv(children = list(
            h1('Video Games: A History'),
            h3('Top Games'),
            htmlBr(),
            dbcRow(children = list(
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
                  list(label = "All", value = "All"),
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
              )
              )),
            dbcCol(children = list(
              h3('⠀'),
              p('Publisher'),
              dccDropdown(
                id='top-dropdown3', 
                options=list(
                  list(label = "All", value = "All"),
                  list(label = "Activision", value = "Activision"),
                  list(label = "Electronic", value = "Electronic"),
                  list(label = "Konami", value = "Konami"),
                  list(label = "Namco", value = "Namco"),
                  list(label = "Nintendo", value = "Nintendo"),
                  list(label = "Sega", value = "Sega"),
                  list(label = "Sony", value = "Sony"),
                  list(label = "THQ", value = "THQ"),
                  list(label = "Ubisoft", value = "Ubisoft"),
                  list(label = "Other", value = "Other")
                ),
                value="All"
              ),
              p('Platform'),
              dccDropdown(
                id='top-dropdown4', 
                options=list(
                  list(label = "All", value = "All"),
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
              )
              ))
              )),
              p('Year'),
              dccRangeSlider(
                id='yearslider2',
                min=1980, 
                max=2016, 
                value=list(1980,2016),
                step=1, 
                marks=as.list(1980:2016),
                allowCross = FALSE,
                vertical=FALSE,
                tooltip = list(
                  'always_visible' = TRUE,
                  'placement' = 'bottom'
                )
              ),
            #)
            #),
            dbcCol(children = list(
              dccGraph(
                #figure = ggplotly(topgames),
                id='topgames-figure',
                style = list("height" = '55vh', width='65vw')
              )
            )
            )
            ),
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
                #figure = ggplotly(sales_hist),
                id = 'sales-hist-figure',
                style = list("height" = '50vh')
              ),
              dccChecklist(
                id = "checklist-input",
                options=list(
                  list("label" = "Log Scale", "value" = "Logarithmic")
                  ),
                value = list("Logarithmic"),
                persistence = TRUE
              )
            )),
            dbcCol(children = list(
              dccDropdown(
                id='count-dropdown2',
                options=list(
                  list(label = "Genre", value = "Genre"),
                  list(label = "Publisher", value = "Publisher_grouped"),
                  list(label = "Platform", value = "Platform_grouped")
                ),
                value="Genre"
              ),
              dccGraph(
                #figure = ggplotly(piechart, dynamicTicks = FALSE),
                id='pie-figure',
                style = list("height" = '50vh')
              )
            ))
          ))
        ),
        label='Count'
        )
      )
    )
  ))
)


#callbacks

app %>% add_callback(
  list(
  output(id = 'sales-time-figure', property = 'figure'),
  output(id = 'map-figure', property = 'figure')
  ),
  input(id = 'yearslider', property = 'value'),
  function(selected_year_index){ 
    #line
    CI_temp <- CI[which(CI$Year %in% c(selected_year_index[[1]]:selected_year_index[[2]])),]
    #sales_time(CI_temp)
    #map
    df_filtered = df[which(df$Year %in% c(selected_year_index[[1]]:selected_year_index[[2]])),]
    codes[codes[,'COUNTRY'] %in% na,'sales'] = sum(df_filtered$NA_Sales)
    codes[codes[,'COUNTRY'] %in% eu,'sales'] = sum(df_filtered$EU_Sales)
    codes[codes[,'COUNTRY'] == 'Japan','sales'] = sum(df_filtered$JP_Sales)
    codes[is.na(codes[,'sales']),'sales'] = sum(df_filtered$Other_Sales)
    list(sales_time(CI_temp), map(codes))
  }
)

# app %>% add_callback(
#   output(id = 'heatmap-figure', property = 'figure'),
#   list(
#     input(id = 'hm-dropdown1', property = 'value'),
#     input(id = 'hm-dropdown2', property = 'value')
#   ),
#   function(drop1, drop2){
#     counts = df %>%
#       dplyr::filter(Publisher_grouped != 'other') %>%
#       droplevels(.) %>%
#       count(get(drop1), get(drop2))
#     names(counts) <- c("drop1", "drop2", "n")
#     heatmap2(counts, drop1, drop2)
#     #df$Platform_grouped = factor(df$Platform_grouped, levels = c("Other", "Xbox", "Sega", "PlayStation", "Nintendo(handheld)",
#     #                                                             "Nintendo(console)", "Computer", "Atari"))
#     #heatmap(df, drop1, drop2)
#   }
# )

app %>% add_callback(
  output(id = 'topgames-figure', property = 'figure'),
  list(
    input(id = 'yearslider2', property = 'value'),
    input(id = 'top-dropdown1', property = 'value'),
    input(id = 'top-dropdown2', property = 'value'),
    input(id = 'top-dropdown3', property = 'value'),
    input(id = 'top-dropdown4', property = 'value')
  ),
  function(selected_year_index, drop1, drop2, drop3, drop4){ 
    df_temp <- df[which(df$Year %in% c(selected_year_index[[1]]:selected_year_index[[2]])),]
    if (drop2 != "All"){
      df_temp = df_temp[df$Genre == drop2,]
    }
    if (drop3 != "All"){
      df_temp = df_temp[df$Publisher_grouped == drop3,]
    }
    if (drop4 != "All"){
      df_temp = df_temp[df$Platform_grouped == drop4,]
    }
    topgames(df_temp, drop1)
  }
)

app %>% add_callback(
  output(id = 'sales-hist-figure', property = 'figure'),
  list(
    input(id = 'checklist-input', property = 'value'),
    input(id = 'count-dropdown1', property = 'value')
  ),
  function(selection, drop1){
    suppressWarnings(sales_hist(df, selection, drop1))
  }
)

app %>% add_callback(
  output(id = 'pie-figure', property = 'figure'),
  input(id = 'count-dropdown2', property = 'value'),
  function(category){ 
  bars = data.frame(
    'counts' = unname(summary(df[,category])),
    'category' = levels(df[,category])
  )
  bars$percentage = round(bars$counts*100 / sum(bars$counts))
  
  piechart(bars)
  }
)



# Run the app
app %>% run_app(host = '0.0.0.0')
