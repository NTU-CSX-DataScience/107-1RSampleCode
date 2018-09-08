### practice_3
### Crawler Example

### Crawler_Example with rvest    #####################################################################
# 參考：https://blog.gtwang.org/r/rvest-web-scraping-with-r/
rm(list = ls())
library(rvest)

# Set url
url <- "https://www.ptt.cc/bbs/NBA/index5720.html"
# Get response
res <- read_html(url)

# Parse the content and extract the titles
raw.titles <- res %>% html_nodes("div.title")

# Extract link
nba.article.link <- raw.titles %>% html_node("a") %>% html_attr('href')

# Extract article
nba.article.title <- raw.titles %>% html_text()

# Create dataframe
nba.df <- data.frame(nba.article.title, nba.article.link)

# Set df's colnames
nba.df.col.names <- c("title", "link")
colnames(nba.df) <- nba.df.col.names


### Crawler_Example with jsonlite #####################################################################\
rm(list = ls())
library(jsonlite)
url <- "https://www.dcard.tw/_api/posts?popular=true"
res <- fromJSON(url)

