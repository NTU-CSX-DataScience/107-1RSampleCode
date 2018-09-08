### practice_2_answer
### dataframe practice - II

### GetBmi 請複製您於practice_1.R的function GetBmi
GetBmi <- function (my.height.cm, my.weight.kg) {
  my.height.m <- my.height.cm / 100
  my.bmi <- my.weight.kg / (my.height.m) ^ 2  
  return (my.bmi)
}

### Part I - 讀取資料與查看資料框內容 ##############################################
# 使用read.table()讀取test_data.csv
# 請注意sep, header的用途, 以及stringsAsFactors = F的影響
df <- read.table('test_data.csv', sep = ',', header = T, stringsAsFactors = F)

# 使用dim()查看df的維度(列數與欄數)
dim(df)

# 使用head()查看df前6筆資料
head(df)

# 使用tail()查看df後6筆資料
tail(df)

# 使用summary()查看df的描述性統計
summary(df)

# 使用str()查看df的詳細資訊
str(df)

# 將df$School與df$Sex轉為factor型態
df$School <- as.factor(df$School)
df$Sex <- as.factor(df$Sex)

### Part II - 資料框整理技巧I #######################################################
# 請注意vector特性：
# 向量物件只能接受一種類別，若給定多種類別會依[字串>數值>布林]進行自動轉換
# 這使得kobe資料內的型態都被轉存為chr了
Height <- c(179, 165, 158, 165, 172, 170, 168, 163, 169, 155)
Weight <- c(69, 62, 46, 50, 72, 70, 52, 49, 63, 49)
Kobe <- c("Kobe", "A", "M", NA, 39, 198, 96)

# 使用cbind()，新增Height與Weight至df為欄(column)資料
df <- cbind(df, Height, Weight)

# 使用rbind()，新增kobe至df為列(row)資料
df <- rbind(df, Kobe)

# 重新使用str()檢查一次df的結構時...
# Age, Grade, Height, Weight都變成chr型態了?? <- 被kobe資料
str(df)

# kobe的Grade資料出現了NA值，請將其重新設定為990分。
df$Grade[11] <- 990

# 轉換df欄位的資料型態
df$Grade <- as.integer(df$Grade)
df$Age <- as.numeric(df$Age)
df$Height <- as.numeric(df$Height)
df$Weight <- as.numeric(df$Weight)
str(df)

# 使用order()，以df$Grade將df遞減排序
df <- df[order(df$Grade, decreasing = T), ]

# 使用subset()，刪除df$Age欄位(這也是一種方式df$Age <- NULL)
df <- subset(df, select = c(-Age))

# 使用names()，重新將Grade欄位命名為ToeicGrade
names(df)[4] <- "ToeicGrade"

# 使用subset()，篩選出ToeicGrade大於900並且身高大於170的人
# 且欄位只需要Name, ToeicGrade與Height
subset(df, Height > 170 & ToeicGrade > 900, select = c(Name, ToeicGrade, Height))

# 不使用subset()，篩選出df中School A的人。
df[df$School == 'A', ]

### Part III - 資料框整理技巧II #####################################################
df.sport <- data.frame(Name = c("Ali", "Petty", "Kobe"), FavSport = c("basketball", "baseball", "baseketball"))

# 使用cut()，在df中新增一個ToeicLevel欄位，內容為df的ToeicGrade分類後結果
# 分類breaks為c(0, 600, 700, 800, 900, Inf)
# 分類labels為c("E", "D", "C", "B", "A")

df$ToeicLevel <- cut(x = df$ToeicGrade, 
                     breaks = c(0, 600, 700, 800, 900, Inf),
                     labels = c("E", "D", "C", "B", "A"))

# 使用mapply()進行bmi計算[調用GetBmi()，參數分別為df$Height, df$Weight]，回傳結果新增至df$Bmi欄位
# 參考http://blog.fens.me/r-apply/
df$Bmi <- mapply(GetBmi, df$Height, df$Weight)

# 使用merge()，將df.sport資料與df進行連結後更新至df，並設定all.x = T保留所有資料
# 參考https://joe11051105.gitbooks.io/r_basic/content/arrange_data/merge_and_subsetting.html
df <- merge(df, df.sport, by = 'Name', all.x = T)
View(df)
