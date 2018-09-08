---
title       : Web Crawler
subtitle    : 生活市集
author      : Bigmoumou
job         : NTU Econ
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## 分享主軸 :

### 爬取生活市集商品資訊


---

## Target Website : 生活市集

<iframe src="https://www.buy123.com.tw" height=600 width=800></iframe>

---

## 生活市集爬蟲思路 :
```
● 方法 1 :
由於該網站所有商品都在首頁，只要不斷向下捲就會出現，
但因為沒有捲到的商品爬不到，故第一個想法是透過動態捲動捲到底(約1hr)，
再把資料 parse 下來一次抓完。
```
```
● 缺點 : 
很容易漏抓，像下捲動過多時(過1/5)就會開始出現一些商品並沒有被讀入，
總商品約 3500 件，通常只抓的到 1800 ~ 2500 的區間。
```
```
● 方法 2 : (也是使用課堂上教的基本方法!)
尋找所有商品的 url，這樣絕對不會漏抓，只是時間上可能要做些處理。
```



---

## 生活市集爬蟲流程 : 
```
● Input Necessary Packages : 
```

```r
library(httr)     # for web crawler
library(RCurl)    # for web crawler
library(XML)      # for web crawler
library(gsubfn)   # for regular expression
```
```
● Set target URL : 
```

```r
# live market's url 
targeturl <- "https://www.buy123.com.tw/site"
```

---

## 生活市集爬蟲流程 :
```
● 將生活市集首頁的資訊 parse 下來 :
```

```r
res <- getURL(targeturl, encoding="utf-8")
res <- htmlParse(res)
res
```
```
{xml_document}
<div class='\"user-rating\"'>
<span class='\"rating-star\"'><span class='\"fa' fa-lg gold fa-star></span><span class='\"fa...
```

---

## 尋找資料所在地 :

<iframe src="https://www.buy123.com.tw" height=600 width=800></iframe>

---

## 觀察 xpath 規律 :
```
● 前幾項商品的 xpath 如下，很明顯能看出規律 :
```
```
//*[@id="container"]/div[4]/section[2]/a[1]/figure/figcapion/h3
//*[@id="container"]/div[4]/section[2]/a[2]/figure/figcapion/h3
//*[@id="container"]/div[4]/section[2]/a[3]/figure/figcapion/h3
...
//*[@id="container"]/div[4]/section[2]/a[n]/figure/figcapion/h3
```
```
這邊我大膽猜測商品資訊都放在下方路徑的子層的 a 標籤:
`//*[@id="container"]/div[4]/section[2]//a`
```

---

## 抓取所有商品 url :
```
● 抓取前述 xpath 下的 href(鏈接) :
```

```r
xpath <- '//*[@id="container"]/div[4]/section[2]//a'
urls <- xpathSApply(res, path=xpath, xmlGetAttr, 'href')
urls
```
```
[1] "/site/sku/2042380/%E5%8A%A0%E7%B2%97%E4%B8%8D%E9%8..."
[2] "/site/sku/2039310/%E5%BA%B7%E4%B9%83%E9%A6%A8Hi-wat..."
...
...
[1000] "/site/item/123284/%E7%8E%87%E6%80%A7%E8%96%84%E6..."     
[ reached getOption("max.print") -- omitted 3793 entries ]
```
```
可以看到已經抓到個商品的 href 資訊，總共有 3000 多筆商品。
```

---

## 整理出所有商品真正的 URL :
```
● 使用 paste0 方法整理出所有商品真正的 url :
```

```r
tmp = "https://www.buy123.com.tw"
urls <- paste0(tmp, urls)
urls
```
```
[1] "/site/sku/2042380/%E5%8A%A0%E7%B2%97%E4%B8%8D%E9..."
[2] "/site/sku/2039310/%E5%BA%B7%E4%B9%83%E9%A6%A8Hi-..."                   
...
[1000] "https://www.buy123.com.tw/site/item/129849/%E..."               
[ reached getOption("max.print") -- omitted 3798 entries ]
```
```
所有商品的 url 都整理完成了 :)
```

---

## 開始進入各商品網頁把資料爬下來囉 !
```
● 由於在 R 中能避免使用迴圈就避免，取而代更多使用的是 apply 家族。
```
```
由於後續每個網頁都會重複以下動作，故先寫成 function 以簡化代碼數。
```



```r
# set function for lapply :
# 詳細說明如下 :
webpage_parser <- function(x, xpath){
  # 進到各商品 url 把網頁資訊 parse 下來
  res_tmp <- getURL(x, encoding="utf-8")
  res_tmp <- htmlParse(res_tmp, encoding="UTF-8")
  # 使用後續指定的 xpath 取得文字 (text) 資料
  textdata <- xpathSApply(res_tmp, path = xpath, xmlValue)
}
```

---

## 開始進入各商品網頁把資料爬下來囉 !

<div style='text-align: left;'>
    <img height='500' src='.\img\p1.png' />
</div>

---

## 開始進入各商品網頁把資料爬下來囉 !
```
這邊僅抓取商品名稱(title)和商品銷售量(sales)為例子
```

```r
# 抓取商品名稱 :
xpath='//*[@id="item-main-content"]/figure/figcaption/h1'
titles <- unlist(lapply(urls[1:10], function(x) webpage_parser(x, xpath=xpath)))
# 抓取商品購買人數 :
xpath='//*[@id="item-main-content"]/div/div[6]/div[2]/span'
sales <- unlist(lapply(urls[1:10], function(x) webpage_parser(x, xpath=xpath)))
# 先以 vector 形式儲存資料，後續再做 split 處理 :
webdata <- paste(titles, sales, sep='__')
```

---

## 等待資料爬下來... `\(^.^)/`

```
上述 code 在 i7-2600 單線程下執行時間大約需要 : 1.5 hr
```
```
如果用 R 的 for loop 的話，大約需要到 >= 2.5 hr 的時間 =.=
```

---

## 等待資料爬下來... `\(^.^)/`

```
上述 code 在 i7-2600 單線程下執行時間大約需要 : 1.5 hr
```
```
如果用 R 的 for loop 的話，大約需要到 >= 2.5 hr 的時間 =.=
```
<div style='text-align: left;'>
    <img height='300' src='.\img\catwait.png' />
</div>

---

## Q : 課後小任務
```
請大家抓取任意 100 筆資料的 titles、sales 以及 prices !
```





