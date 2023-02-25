#imports
library(dash)
library(dashCoreComponents)
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
test = df %>%
  ggplot(aes(x=Publisher_grouped, y=Genre)) + 
  geom_bin2d() 
counts = ggplot_build(test)$data[[1]]['count']
df$Platform_grouped = factor(df$Platform_grouped, levels = c("Other", "Xbox", "Sega", "PlayStation", "Nintendo(handheld)", 
                                                             "Nintendo(console)", "Computer", "Atari"))
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


# Create a Dash app
app <- dash_app()

#stylesheet
app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

#sourcing plots
setwd('./plot_functions')
sapply(list.files(), source)
setwd('..')

app %>% set_layout(
  dbcContainer(
    dbcTabs(
      list(
        dbcTab(
          div(
            h1('Video Games: A History'),
            p("Distributions"),
            dccGraph(
              figure = ggplotly(map)
            )
          ), 
          label = 'tab1'
        ),
        dbcTab(
          h1('A heading'),
          p('With a help paragraph'),
          label='tab2'
        )
      )
    )
  )
)

# Run the app
app %>% run_app()
