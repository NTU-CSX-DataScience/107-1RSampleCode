#用 各個城市的位置去做查詢設定
#以 LA 為例

#0基本設定
rm(list=ls(all.names=TRUE)) #remove the list
library(devtools)
library(twitteR)
library(data.table)
library(maps)
library(mapproj)
library(plyr)
library(reshape2)

#1載入API
consumer_key <- ""
consumer_secret <- ""
access_token <- ""
access_secret <- ""
options(httr_oauth_cache=T) #This will enable the use of a local file to cache OAuth access credentials between R sessions.
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#1找尋設定
tweets <- searchTwitter('#airbnb', n=1000, since = '2018-03-11', until = '2018-03-25')
#經度設定ex  geocode = '39.599976, -101.013914, 2000mi'