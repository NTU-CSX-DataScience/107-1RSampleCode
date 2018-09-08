library(httr)
library(rvest)
library(xml2)
library(gsubfn)
library(magrittr)
library(dplyr)
#=========================================================================
# live market's url :
targeturl <- "https://www.buy123.com.tw"

res <- GET(targeturl) %>% content("parse")

xpath = '//*[@id="container"]/div[4]/section[2]'
text1 <- res %>% html_node(xpath=xpath) %>% html_children()

url <- unlist(lapply(as.character(text1), strapplyc, 'href=\"(.*)#?ref'))
url <- paste0('https://www.buy123.com.tw/',url)
#=========================================================================
# set function for lapply :
webpage_parser <- function(x, xpath){
  res_tmp <- GET(x) %>% content("parse")
  res_tmp %>% html_node(xpath=xpath) %>% html_text()
  }
#-------------------------------------------------------------------------
starttime <- Sys.time()

xpath='//*[@id="deal_detail_info"]/div[1]/div/h1'
text1 <- unlist(lapply(url, function(x) webpage_parser(x, xpath=xpath)))

xpath='//*[@id="price"]'
text2 <- unlist(lapply(url, function(x) webpage_parser(x, xpath=xpath)))
text2 <- gsub('[\r\n\t]', '', text2)

xpath='//*[@id="deal_price_detail"]/div[7]'
text3 <- unlist(lapply(url, function(x) webpage_parser(x, xpath=xpath)))

webdata <- paste(text1,text2,text3,sep='__')

runtime <- Sys.time() - starttime
runtime
#=========================================================================
# save data
ws_df <- data.frame(date=starttime, item=webdata)
ws_df <- ws_df %>% separate(item, c('item','price','num_of_people'), sep="__")

save(ws_df, file='C:\\Users\\cby2\\Desktop\\ws.RData')


