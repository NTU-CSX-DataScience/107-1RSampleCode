### practice_3_answer
### ptt_info_book

# 基本變數資訊
person.name <- c("Jiyuian", "Shawnroom", "Bigmoumou")
person.sex <- c("F", "M", "M")
person.id <- c("jiyuian520", "shawnn520", "moumou123")
person.days <- c(201, 37, 99)

# 使用data.frame()，並以上述4個向量建立person.df
person.df <- data.frame(person.name, person.sex, person.id, person.days)

# 查看person.df結構
str(person.df)

# 查看person.df summary
summary(person.df)

# 印出person.df
person.df

# 印出person.df第一列
person.df[1, ]

# 印出person.df第二列第三欄
person.df[2, 3]

# 使用$ 指定出person.df中person.id欄位
person.df$person.id

# 使用order(), 將person.df$person.days排序後, 建立days.position
days.postion <- order(person.df$person.days)

# 使用days.postion, 排序person.df
person.df[days.postion, ]

# 使用grepl()，找出person.df$person.id中有520精神的
spirit.520 <- grepl("520", person.df$person.id)

# 篩選出520家族的成員
person.df[spirit.520, ]
