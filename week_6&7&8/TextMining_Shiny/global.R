library(shiny)
library(rsconnect)
library(shinythemes)
library(showtext)
library(ggplot2)
library(tidyverse)
library(tm)
library(jiebaR)
library(jiebaRD)
library(Matrix)
library(wordcloud)
library(ggbiplot)
library(factoextra)
library(plotly)

# FUNCTIONS
# mixseg = worker()
mixseg = worker(dict="./dict/jieba.dict.utf8", hmm="./dict/hmm_model.utf8",
                user="./dict/user.dict.utf8", idf = "./dict/idf.utf8",
                stop_word ="./dict/stop_words.utf8")
jieba_tokenizer = function(d)
{
  unlist( segment(d[[1]], mixseg) )
}

count_token = function(d)
{
  as.data.frame(table(d))
}

idfCal <- function(word_doc, n)
{ 
  log2( n / nnzero(word_doc) ) 
}

#Cosine Similiarity
cos <- function(x, y){
  return (x %*% y / sqrt(x %*% x * y %*% y))[1, 1]
}