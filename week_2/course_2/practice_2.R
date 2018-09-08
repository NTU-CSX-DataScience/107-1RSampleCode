### practice_2
### dataframe practice - II

### GetBmi 請複製您於practice_1.R的function GetBmi
GetBmi <- function (){
  
}

### Part I - 讀取資料與查看資料框內容 ##############################################
# 使用read.table()讀取test_data.csv
# 請注意sep, header的用途, 以及stringsAsFactors = F的影響
df <- read.table('test_data.csv', sep = ___, header = _, stringsAsFactors = F)

# 使用dim()查看df的維度(列數與欄數)


# 使用head()查看df前6筆資料


# 使用tail()查看df後6筆資料


# 使用summary()查看df的描述性統計


# 使用str()查看df的詳細資訊


# 將df$School與df$Sex轉為factor型態
df$School <- as._____(df$______)
df$Sex <- as._____(df$___)

### Part II - 資料框整理技巧I #######################################################
# 請注意vector特性：
# 向量物件只能接受一種類別，若給定多種類別會依[字串>數值>布林]進行自動轉換
# 這使得kobe資料內的型態都被轉存為chr了
Height <- c(179, 165, 158, 165, 172, 170, 168, 163, 169, 155)
Weight <- c(69, 62, 46, 50, 72, 70, 52, 49, 63, 49)
Kobe <- c("Kobe", "A", "M", NA, 39, 198, 96)

# 使用cbind()，新增Height與Weight至df為欄(column)資料
df <- cbind(__, ______, ______)

# 使用rbind()，新增kobe至df為列(row)資料
df <- rbind(__, ____)

# 重新使用str()檢查一次df的結構時...
# Age, Grade, Height, Weight都變成chr型態了?? <- 被kobe資料
str(__)

# kobe的Grade資料出現了NA值，請將其重新設定為990分。
df$Grade[__] <- ___

# 轉換df欄位的資料型態 # Grade: integer, Age, Height, Weight: numeric
df$Grade <- as._______(df$Grade)
df$Age <- as._______(df$Age)
df$Height <- as._______(df$Height)
df$Weight <- as._______(df$Weight)

# 查看df結構，是否是轉換完畢結果
str(__)

# 使用order()，以df$Grade將df遞減排序
df <- df[order(________, decreasing = _), ]

# 使用subset()，刪除df$Age欄位(另一種方式df$Age <- NULL)
df <- subset(df, select = c(-___))

# 使用names()，重新將Grade欄位命名為ToeicGrade
names(df)[_] <- "ToeicGrade"

# 使用subset()，篩選出ToeicGrade大於900並且身高大於170的人
# 且欄位只需要Name, ToeicGrade與Height
subset(df, Height > ___ & ToeicGrade > ___, select = c(____, _________, ______))

# 不使用subset()，篩選出df中School A的人。
df[df$School == ___, ]

### Part III - 資料框整理技巧II #####################################################
df.sport <- data.frame(Name = c("Ali", "Petty", "Kobe"), FavSport = c("basketball", "baseball", "baseketball"))

# 使用cut()，在df中新增一個ToeicLevel欄位，內容為df的ToeicGrade分類後結果
# 分類breaks為c(0, 600, 700, 800, 900, Inf)
# 分類labels為c("E", "D", "C", "B", "A")

df$ToeicLevel <- cut(x = df$ToeicGrade, 
                     breaks = _________________________,
                     labels = _____________________)

# 使用mapply()進行bmi計算[調用GetBmi()，參數分別為df$Height, df$Weight]，回傳結果新增至df$Bmi欄位
# 參考http://blog.fens.me/r-apply/
df$Bmi <- mapply(______, _________, _________)

# 使用merge()，將df.sport資料與df進行連結後更新至df，並設定all.x = T保留所有資料
# 參考https://joe11051105.gitbooks.io/r_basic/content/arrange_data/merge_and_subsetting.html
df <- merge(df, df.sport, by = 'Name', all.x = T)
View(df)