# codes = read.csv('./plotly_countryCodes.csv')
# codes = codes[,-2]
# df = read.csv('../data/vgsales-cleaned.csv', stringsAsFactors = TRUE)


# #adding sales
# codes$sales = NA
# na = c("Canada", "United States", "Mexico", "Nicaragua", "Honduras", 
#        "Cuba", "Guatemala", "Panama", "Costa Rica", "Dominican Republic", 
#        "Haiti", "Belize", "El Salvador", "Bahamas, The", "Jamaica", 
#        "Trinidad and Tobago", "Dominica", "Saint Lucia", "Antigua and Barbuda", 
#        "Barbados", "Saint Vincent and the Grenadines", "Grenada", 
#        "Saint Kitts and Nevis")
# eu = c('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 
#        'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 
#        'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 
#        'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 
#        'Slovakia', 'Slovenia', 'Spain', 'Sweden')
# codes[codes[,'COUNTRY'] %in% na,'sales'] = sum(df$NA_Sales)
# codes[codes[,'COUNTRY'] %in% eu,'sales'] = sum(df$EU_Sales)
# codes[codes[,'COUNTRY'] == 'Japan','sales'] = sum(df$JP_Sales)
# codes[is.na(codes[,'sales']),'sales'] = sum(df$Other_Sales)
# 
# #adding names
# codes$names = NA
# codes[codes[,'COUNTRY'] %in% na,'names'] = 'North America'
# codes[codes[,'COUNTRY'] %in% eu,'names'] = 'Europena Union'
# codes[codes[,'COUNTRY'] == 'Japan','names'] = 'Japan'
# codes[is.na(codes[,'names']),'names'] = 'Other'



#making map
library(plotly)
map = plot_geo(codes) %>% 
  add_trace(
  z = ~sales, color = ~sales, colors = 'Greens',
  text = ~names, locations = ~CODE, marker = list(line = list(color = toRGB("grey"), width = 0.5))
) %>% 
  colorbar(title = 'Sales', tickprefix = '$') %>% 
  layout(
  title = '',
  geo = list(
    showframe = FALSE,
    showcoastlines = FALSE,
    projection = list(type = 'Mercator')
  )
)


#map
