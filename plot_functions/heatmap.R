# library(ggplot2)
# library(lubridate)
# 
# df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)
# 
# 
# test = df %>%
#   ggplot(aes(x=Publisher_grouped, y=Genre)) + 
#   geom_bin2d() 
# counts = ggplot_build(test)$data[[1]]['count']
# 
# 
# df$Platform_grouped = factor(df$Platform_grouped, levels = c("Other", "Xbox", "Sega", "PlayStation", "Nintendo(handheld)",
#                     "Nintendo(console)", "Computer", "Atari"))

heatmap = function(df, drop1, drop2){
  figure = df %>%
  dplyr::filter(get(drop1) != 'Other') %>%
  dplyr::filter(get(drop2) != 'Other') %>%
  ggplot(aes(x=get(drop1), y=get(drop2))) +
  geom_bin2d(na.rm=TRUE) +
  scale_fill_gradient(low = "white", high = "steelblue") +
  #scale_fill_viridis_c() +
  stat_bin2d(geom = "text", aes(label = after_stat(count)), size=4.75) +
  scale_x_discrete(guide = guide_axis(angle=45)) +
  xlab('Publisher') +
  ylab('Platform') +
  ggthemes::theme_few()
  
  ggplotly(figure)
}
  
  
#in plotly
# counts = df %>% 
#   dplyr::filter(Publisher_grouped != 'other') %>%
#   droplevels(.) %>% 
#   count(Genre, Publisher_grouped)

heatmap2 <- function(counts, drop1, drop2){
  counts = counts
  figure = plot_ly(
  x = counts$drop1,
  y = counts$drop2,
  z = counts$n,
  type = 'heatmap'#,
  #colors = colorRamp(c("white", "darkgreen"))
  )
  ggplotly(figure)
}
