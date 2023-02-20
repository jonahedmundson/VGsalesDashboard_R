#imports
library(dash)
library(dashCoreComponents)
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



#########################
## APPLICATION
#########################


# Create a Dash app
app <- dash_app()

#sourcing plots
setwd('./plot_functions')
sapply(list.files(), source)
setwd('..')

app %>% set_layout(
  h1('Video Games: A History'),
  div("Distributions"),
  dccGraph(
    figure = ggplotly(sales_hist)
  )
)

# Run the app
app %>% run_app()
