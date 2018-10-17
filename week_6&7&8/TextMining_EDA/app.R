
##Packages =====
library(shiny)
library(ggplot2)
library(tidyverse)
library(tm)
library(jiebaR)
library(Matrix)
library(wordcloud)
library(ggbiplot)
library(factoextra)
library(plotly)

##Program ==================================================================

# 讀檔
dta <- read.csv(file = "data/tang300/tang300_utf-8.csv", fileEncoding = "UTF-8",
                stringsAsFactors=F)
#轉成類別型態
dta[,'author'] = as.factor(dta[,'author'])
dta[,'style'] = as.factor(dta[,'style'])

# LISTS
author_list = list(unique(dta$author))[[1]]
tag_list = c('寫景', '思鄉', '抒情', '送別', '友情', '思念', '樂府', '女子', '寫人', '邊塞', '懷古', '生活', '山水',
             '戰爭', '秋天', '哲理', '孤獨', '月亮', '愛情', '懷人', '宮怨', '詠史懷古', '離別', '閨怨', '冬天', '抒懷', '詠物')

# FUNCTIONS
mixseg = worker()
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

###
# EXAMPLE A (唐詩三百首中 各tag詩數量統計) (畫長條圖)
# parameters: None
###

tag_count <- dta$tag %>% strsplit('，') %>% unlist %>% count 
tag_count = tag_count[rev(order(tag_count$freq)),]
#只取有在tag_list中的
tag_count = tag_count[tag_count$x %in%  tag_list, ]

ggplot(tag_count, aes(x = reorder(x,-freq), y = freq)) + 
  geom_bar(stat = "identity", fill='lightblue') + 
  labs(x='tag',title='唐詩三百首數量統計') + 
  theme(panel.background = element_blank(),
        axis.title = element_text(color = '#2d2d2d'),
        axis.text.x = element_text(hjust = 1, size=15),
        axis.text.y = element_text(hjust = 1, size=15),
        strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
        plot.title = element_text(hjust=0.5,face='bold',size=15))

###
# EXAMPLE B1 (唐詩三百首各tag中 各作者詩數量統計) (畫直方圖)
# parameters: input.tag
###

# 選擇tag類別
input.tag = '愛情'
tag_author_count <- dta %>% filter(str_detect(tag, input.tag)) %>% select(author) %>% 
  unlist() %>% count

ggplot(tag_author_count, aes(x = reorder(x,-freq), y = freq)) + 
  geom_bar(stat = "identity", fill='lightblue') + 
  labs(x='作者',title=paste('Tag: ',input.tag)) + 
  theme(panel.background = element_blank(),
        axis.title = element_text(color = '#2d2d2d'),
        strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
        plot.title = element_text(hjust=0.5,face='bold',size=15))

###
# EXAMPLE B2 
# parameters: input.tag
###

#1. 建立文本資料結構與基本文字清洗
d.corpus_tag <- Corpus(DirSource("./data/tang300/by_tag", encoding = "UTF-8"))
d.corpus_tag <- tm_map(d.corpus_tag, stripWhitespace) #消除空格
d.corpus_tag <- tm_map(d.corpus_tag, removeNumbers) #移除數字
d.corpus_tag <- tm_map(d.corpus_tag, removePunctuation) #移除標點符號
d.corpus_tag <- tm_map(d.corpus_tag, function(word) { # 移除英數
  gsub("[A-Za-z0-9]", "", word)
})

#2. 進行斷詞，並建立文本矩陣 TermDocumentMatrix
seg_tag = lapply(d.corpus_tag, jieba_tokenizer)
tokens_tag = lapply(seg_tag, count_token)

#TDM
n_tag = length(seg_tag)
TDM_tag = tokens_tag[[1]]
tagNames <- list.files('./data/tang300/by_tag')
tagNames <- gsub(".txt", "", tagNames) #取代
for( id in c(2:n_tag) )
{
  TDM_tag = merge(TDM_tag, tokens_tag[[id]], by="d", all = TRUE)
  names(TDM_tag) = c('d', tagNames[1:id])
}
TDM_tag[is.na(TDM_tag)] <- 0 #將NA填0

#3. 將已建好的 TDM 轉成 TF-IDF
tf_tag <- apply(as.matrix(TDM_tag[,2:(n_tag + 1)]), 2, sum) #直向相加計算總數
idf_tag <- apply(as.matrix(TDM_tag[,2:(n_tag + 1)]), 1, idfCal, n <- n_tag)
doc.tfidf_tag <- TDM_tag

tempY_tag = matrix(rep(c(as.matrix(tf_tag)), each = length(idf_tag)), 
                   nrow = length(idf_tag))
tempX_tag = matrix(rep(c(as.matrix(idf_tag)), each = length(tf_tag)), 
                   ncol = length(tf_tag), byrow = TRUE)
doc.tfidf_tag[,2:(n+1)] <- (doc.tfidf_tag[,2:(n +1)] / tempY_tag) * tempX_tag

#4. 畫各tag前(十)多用字 (input.tag)

words_count_tag = TDM_tag[,c('d', input.tag)]
colnames(words_count_tag) = c('word', 'count')
words_count_tag = words_count_tag[rev(order(words_count_tag$count)),]
rownames(words_count_tag)=NULL


ggplot(words_count_tag[1:20,], aes(x = reorder(word, count), y =count)) + 
  geom_bar(stat = "identity", fill='lightblue') + 
  coord_flip()+
  labs(x='word', y='count', title=paste('Tag: ', input.tag)) +
  theme(panel.background = element_blank(),
        axis.title = element_text(color = '#2d2d2d'),
        axis.text.x = element_text(hjust = 1, size=15),
        axis.text.y = element_text(hjust = 1, size=15),
        strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
        plot.title = element_text(hjust=0.5,face='bold',size=15))


#5. 找前10相似 (input.tag)
rownames(doc.tfidf_tag) = doc.tfidf_tag$d
doc.tfidf_tag <- doc.tfidf_tag[,1:n_tag+1]
docs.cos.sim_tag <- apply(doc.tfidf_tag, 2, cos, y = doc.tfidf_tag[, c(input.tag)])
sort(docs.cos.sim_tag, decreasing = TRUE)[1:10]

#6. 唐詩三百首文字雲 (所有tag相加)

#BY tf-idf
f_tag <- sort(rowSums(doc.tfidf_tag), decreasing = T)
docs.df_tag <- data.frame(
  word = names(f_tag),
  freq = f_tag
)
row.names(docs.df_tag)=NULL
wordcloud(docs.df_tag$word, docs.df_tag$freq, scale=c(3,0.1),max.words=50,
          random.order=FALSE, random.color=TRUE, 
          rot.per=.1, colors=brewer.pal(8,"Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)

#7. PCA
pcat_tag = prcomp(t(doc.tfidf_tag))
g <- ggbiplot(pcat_tag, obs.scale = 1, var.scale = 1, ellipse = TRUE, circle = TRUE)

fviz_eig(pcat_tag)
fviz_pca_ind(pcat_tag, geom= c("point","text","arrow"), col.ind = "cos2")
fviz_pca_var(pcat_tag, col.var = "contrib")

#8. Kmeans
# parameter: k_tag

k_tag = 5

kmeansData_tag = pcat_tag$x[,1:2]
# kmeansData = kmeansData[kmeansData[,1] > -0.05, ]

cl_tag <- kmeans(kmeansData_tag, k_tag)
kmeansData_tag <- as.data.frame(kmeansData_tag) 
kmeansData_tag$cl <- as.factor(cl_tag$cluster)

plot_ly(kmeansData_tag, x= ~PC1, y=~PC2, type='scatter',
        mode='text', text=paste0("<b>",rownames(kmeansData_tag),"</b>"), 
        color = ~cl, colors="Set1", textfont = list(size = 14) )

###
# EXAMPLE C 
# parameters: input.author
###

#1. 建立文本資料結構與基本文字清洗
d.corpus_author <- Corpus(DirSource("./data/tang300/by_author", encoding = "UTF-8"))
d.corpus_author <- tm_map(d.corpus_author, stripWhitespace) #消除空格
d.corpus_author <- tm_map(d.corpus_author, removeNumbers) #移除數字
d.corpus_author <- tm_map(d.corpus_author, removePunctuation) #移除標點符號
d.corpus_author <- tm_map(d.corpus_author, function(word) { # 移除英數
  gsub("[A-Za-z0-9]", "", word)
})

#2. 進行斷詞，並建立文本矩陣 TermDocumentMatrix
seg_author = lapply(d.corpus_author, jieba_tokenizer)
tokens_author = lapply(seg_author, count_token)

#TDM
n_author = length(seg_author)
TDM_author = tokens_author[[1]]
authorNames <- list.files('./data/tang300/by_author')
authorNames <- gsub(".txt", "", authorNames) #取代
for( id in c(2:n_author) )
{
  TDM_author = merge(TDM_author, tokens_author[[id]], by="d", all = TRUE)
  names(TDM_author) = c('d', authorNames[1:id])
}
TDM_author[is.na(TDM_author)] <- 0 #將NA填0

#3. 將已建好的 TDM 轉成 TF-IDF
tf_author <- apply(as.matrix(TDM_author[,2:(n_author + 1)]), 2, sum) #直向相加計算總數
idf_author <- apply(as.matrix(TDM_author[,2:(n_author + 1)]), 1, idfCal, n=n_author)
doc.tfidf_author <- TDM_author

tempY_author = matrix(rep(c(as.matrix(tf_author)), each = length(idf_author)), 
                      nrow = length(idf_author))
tempX_author = matrix(rep(c(as.matrix(idf_author)), each = length(tf_author)), 
                      ncol = length(tf_author), byrow = TRUE)
doc.tfidf_author[,2:(n+1)] <- (doc.tfidf_author[,2:(n+1)] / tempY_author) * tempX_author

#4. 畫各author前(十)多用字 (input.author)
input.author <- "李白"
words_count_author = TDM_author[,c('d', input.author)]
colnames(words_count_author) = c('word', 'count')
words_count_author = words_count_author[rev(order(words_count_author$count)),]
rownames(words_count_author)=NULL

ggplot(words_count_author[1:20,], aes(x = reorder(word, count), y =count)) + 
  geom_bar(stat = "identity", fill='lightblue') + 
  coord_flip()+
  labs(x='word', y='count', title=paste('Author: ', input.author)) +
  theme(panel.background = element_blank(),
        axis.title = element_text(color = '#2d2d2d'),
        axis.text.x = element_text(hjust = 1, size=15),
        axis.text.y = element_text(hjust = 1, size=15),
        strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
        plot.title = element_text(hjust=0.5,face='bold',size=15))


#5. 找前10相似 (input.author)
rownames(doc.tfidf_author) = doc.tfidf_author$d
doc.tfidf_author <- doc.tfidf_author[,1:n_author+1]
docs.cos.sim_author <- apply(doc.tfidf_author, 2, cos, y = doc.tfidf_author[, c(input.author)])
sort(docs.cos.sim_author, decreasing = TRUE)[1:10]

#6. 唐詩三百首文字雲 (所有author相加)

#BY tf-idf
f_author <- sort(rowSums(doc.tfidf_author), decreasing = T)
docs.df_author <- data.frame(
  word = names(f_author),
  freq = f_author
)
row.names(docs.df_author)=NULL
wordcloud(docs.df_author$word, docs.df_author$freq, scale=c(3,0.1),max.words=50,
          random.order=FALSE, random.color=TRUE, 
          rot.per=.1, colors=brewer.pal(8,"Dark2"),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)

#7. PCA
pcat_author = prcomp(t(doc.tfidf_author))
g <- ggbiplot(pcat_author, obs.scale = 1, var.scale = 1, ellipse = TRUE, circle = TRUE)

fviz_eig(pcat_author)
fviz_pca_ind(pcat_author, geom= c("point","text","arrow"), col.ind = "cos2")
fviz_pca_var(pcat_author, col.var = "contrib")

#8. Kmeans
# parameter: k_author

k_author = 5

kmeansData_author = pcat_author$x[,1:2]
# kmeansData = kmeansData[kmeansData[,1] > -0.05, ]

cl_author <- kmeans(kmeansData_author, k_author)
kmeansData_author <- as.data.frame(kmeansData_author) 
kmeansData_author$cl <- as.factor(cl_author$cluster)

plot_ly(kmeansData_author, x= ~PC1, y=~PC2, type='scatter',
        mode='text', text=paste0("<b>",rownames(kmeansData_author),"</b>"), 
        color = ~cl, colors="Set1", textfont = list(size = 14) )

##UI =======================================================================
ui <- navbarPage(
  
   theme = shinythemes::shinytheme("flatly"),
   
   # Application title
   "唐詩分析",
   
   tabPanel(
     "簡介",
     tags$h2("簡介"),br(),
     tags$h3("組員： 林奕均/王姿嵐/陳麒業"),br(),br(),
     tags$h4("詩詞曲向來被視為文學上的瑰寶；"),br(),
     tags$h4("本次專題透過資料分析找出【唐詩】中："),br(),
     tags$h4("【詞彙之間】、【詞彙與詩人之間】的相關性"),br(),
     tags$h4("以探討詞彙之間的關聯程度，"),br(),
     tags$h4("及作者生平、性格與常用字詞的關係。"),br()
   ),
   tabPanel(
     "文字雲",
     tags$h2("唐詩三百首文字雲"),br(),
     sidebarPanel(
       sliderInput("wc_max",
                   "字詞數量",
                   min = 1,
                   max = 50,
                   value = 30)
     ),
     mainPanel(
       plotOutput("WordCloud_1")
     )
   ),
   tabPanel(
     "詩人常用字",
     tags$h2("詩人常用字統計"),br(),
     sidebarPanel(
       selectInput("author_1", "詩人:", 
                   choices=author_list),
       hr(),
       helpText("列出這位詩人最常用的詞")
         
     ),
     mainPanel(
       plotOutput("Plot_1")
     )
   ),
   tabPanel(
     "以詩作類別分析",
     tags$h2("以詩作類別統計"),br(),
     sidebarPanel(
       selectInput("tag_1", "詩作類別:", 
                   choices=tag_list),
       hr(),
       helpText("列出此類別的詩作最常用的詞，以及詩人的詩作數量")
       
     ),
     mainPanel(
       plotOutput("Plot_2"),
       plotOutput("Plot_3"),
       plotOutput("Plot_4")
     )
   ),
   tabPanel(
     "詩人間的關聯性",
     tags$h1("詩人間的關聯性"),
       sidebarPanel(
         tags$h4("使用PCA及K-means分群，我們可以將風格類似的詩人們分群"),
         numericInput("k1",
                      "Number of k:",
                      min = 1,
                      max = nrow(kmeansData_author) - 1,
                      value = 5)
       ),
       # Show a plot of the generated distribution
       mainPanel(
         plotlyOutput("Plotly_KM1")
       )
   ),
   tabPanel(
     "類別間的關聯性",
     tags$h1("詩作類別間的關聯性"),
     sidebarPanel(
       tags$h4("使用PCA及K-means分群，我們可以將相似的詩作類型分群"),
       numericInput("k2",
                    "Number of k:",
                    min = 1,
                    max = nrow(kmeansData_tag) - 1,
                    value = 10)
     ),
     # Show a plot of the generated distribution
     mainPanel(
       plotlyOutput("Plotly_KM2")
     )
   )
)

##SERVER =====================================================================
server <- function(input, output) {
  output$Plot_1 <- renderPlot({
    input.author <- input$author_1
    words_count_author = TDM_author[,c('d', input.author)]
    colnames(words_count_author) = c('word', 'count')
    words_count_author = words_count_author[rev(order(words_count_author$count)),]
    rownames(words_count_author)=NULL
    ggplot(words_count_author[1:20,], aes(x = reorder(word, count), y =count)) + 
      geom_bar(stat = "identity", fill='lightblue') + 
      coord_flip() +
      labs(x='word', y='count', title=paste('Author: ', input.author)) +
      theme(panel.background = element_blank(),
            axis.title = element_text(color = '#2d2d2d'),
            axis.text.x = element_text(hjust = 1, size=15),
            axis.text.y = element_text(hjust = 1, size=15),
            strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
            plot.title = element_text(hjust=0.5,face='bold',size=15))
  })
  output$WordCloud_1 <- renderPlot({
    wordcloud(docs.df_author$word, docs.df_author$freq, scale=c(5,0.8),max.words=input$wc_max,
              random.order=FALSE, random.color=TRUE, 
              rot.per=.1, colors=brewer.pal(8,"Dark2"),
              ordered.colors=FALSE,use.r.layout=FALSE,
              fixed.asp=TRUE)
  })
  output$Plot_2 <- renderPlot({
    input.tag = input$tag_1
    
    words_count_tag = TDM_tag[,c('d', input.tag)]
    colnames(words_count_tag) = c('word', 'count')
    words_count_tag = words_count_tag[rev(order(words_count_tag$count)),]
    rownames(words_count_tag)=NULL
    
    ggplot(words_count_tag[1:20,], aes(x = reorder(word, count), y =count)) + 
      geom_bar(stat = "identity", fill='lightblue') + 
      coord_flip()+
      labs(x='word', y='count', title=paste('此類別的常用字 Tag: ', input.tag)) +
      theme(panel.background = element_blank(),
            axis.title = element_text(color = '#2d2d2d'),
            axis.text.x = element_text(hjust = 1, size=15),
            axis.text.y = element_text(hjust = 1, size=15),
            strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
            plot.title = element_text(hjust=0.5,face='bold',size=15))
  })
  output$Plot_3 <- renderPlot({
    input.tag = input$tag_1
    tag_author_count <- dta %>% filter(str_detect(tag, input.tag)) %>% select(author) %>% 
      unlist() %>% count
    
    ggplot(tag_author_count, aes(x = reorder(x, freq), y = freq)) + 
      geom_bar(stat = "identity", fill='lightblue') + 
      coord_flip()+
      labs(x='作者',title=paste('此類別的詩人及詩作數量 Tag: ',input.tag)) + 
      theme(panel.background = element_blank(),
            axis.title = element_text(color = '#2d2d2d'),
            axis.text.x = element_text(hjust = 1, size=15),
            axis.text.y = element_text(hjust = 1, size=15),
            strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
            plot.title = element_text(hjust=0.5,face='bold',size=15))
  })
  output$Plot_4 <- renderPlot({
    ggplot(tag_count, aes(x = reorder(x, freq), y = freq)) + 
      geom_bar(stat = "identity", fill='lightblue') + 
      coord_flip() + 
      labs(x='tag',title='各類別唐詩數量統計') + 
      theme(panel.background = element_blank(),
            axis.title = element_text(color = '#2d2d2d'),
            axis.text.x = element_text(hjust = 1, size=15),
            axis.text.y = element_text(hjust = 1, size=15),
            strip.text.x = element_text(color='#2d2d2d',face='bold',size=10),
            plot.title = element_text(hjust=0.5,face='bold',size=15))
  })
  output$Plotly_KM1 <- renderPlotly({
    k_author = input$k1
    
    cl_author <- kmeans(kmeansData_author, k_author)
    kmeansData_author <- as.data.frame(kmeansData_author) 
    kmeansData_author$cl <- as.factor(cl_author$cluster)
    
    plot_ly(kmeansData_author, x= ~PC1, y=~PC2, type='scatter',
            mode='text', text=paste0("<b>",rownames(kmeansData_author),"</b>"), 
            color = ~cl, colors="Set1", textfont = list(size = 14) )
  })
  output$Plotly_KM2 <- renderPlotly({
    k_tag = input$k2
    
    kmeansData_tag = pcat_tag$x[,1:2]
    # kmeansData = kmeansData[kmeansData[,1] > -0.05, ]
    
    cl_tag <- kmeans(kmeansData_tag, k_tag)
    kmeansData_tag <- as.data.frame(kmeansData_tag) 
    kmeansData_tag$cl <- as.factor(cl_tag$cluster)
    
    plot_ly(kmeansData_tag, x= ~PC1, y=~PC2, type='scatter',
            mode='text', text=paste0("<b>",rownames(kmeansData_tag),"</b>"), 
            color = ~cl, colors="Set1", textfont = list(size = 14) )
  })
  
}
fviz_eig(pcat_author)
fviz_pca_ind(pcat_author, geom= c("point","text","arrow"), col.ind = "cos2")
fviz_pca_var(pcat_author, col.var = "contrib")
# Run the application 
shinyApp(ui = ui, server = server)

