### example_3_taipeiApi
# Taipei api http://oops.gov.taipei/
##########################################################ˇ

library(jsonlite)

# The TPE Bike opendata json url
url <- 'http://data.ntpc.gov.tw/od/data/api/54DDDC93-589C-4858-9C95-18B2046CC1FC;jsessionid=3D59D691A89C50D9BD6763C844C777CD?$format=json'

#Get it with jsonlite package
jsonData <- fromJSON(url, flatten = TRUE)

#Write it into csv.
# write.csv(file = 'test.csv', jsonData , fileEncoding = 'utf-8')


