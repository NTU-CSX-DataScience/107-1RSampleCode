library(httr)
library(rvest)
library(xml2)
library(doParallel)
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

core <- detectCores()-1
Split_df <- split(url, 1:core)

(cl <- (detectCores() - 1) %>%  makeCluster) %>% registerDoParallel

starttime <- Sys.time()

ws <- foreach(i = 1:length(Split_df), .combine = 'c', .packages = c("rvest", "magrittr", "xml2","httr")) %dopar% {
  # set function for lapply :
  webpage_parser <- function(x, xpath){
    res_tmp <- GET(x) %>% content("parse")
    res_tmp %>% html_node(xpath=xpath) %>% html_text()
  }
  
  xpath='//*[@id="deal_detail_info"]/div[1]/div/h1'
  text1 <- unlist(lapply(Split_df[[i]], function(x) webpage_parser(x, xpath=xpath)))
  
  xpath='//*[@id="price"]'
  text2 <- unlist(lapply(Split_df[[i]], function(x) webpage_parser(x, xpath=xpath)))
  text2 <- gsub('[\r\n\t]', '', text2)
  
  xpath='//*[@id="deal_price_detail"]/div[7]'
  text3 <- unlist(lapply(Split_df[[i]], function(x) webpage_parser(x, xpath=xpath)))
  
  paste(text1,text2,text3,sep='__')
  
}

stopCluster(cl)

runtime <- Sys.time() - starttime
runtime

