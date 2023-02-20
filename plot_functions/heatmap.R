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

heatmap = df %>%
  dplyr::filter(Publisher_grouped != 'other') %>%
  ggplot(aes(x=Publisher_grouped, y=Platform_grouped)) + 
  geom_bin2d(na.rm=TRUE) + 
  scale_fill_gradient(low = "white", high = "steelblue") +
  #scale_fill_viridis_c() + 
  stat_bin2d(geom = "text", aes(label = after_stat(count)), size=4.75) + 
  scale_x_discrete(guide = guide_axis(angle=45)) + 
  xlab('Publisher') + 
  ylab('Platform') +
  ggthemes::theme_few()
  
