########################################################### Task 5

# 猜數字遊戲
# 1. 請寫一個由電腦隨機產生不同數字的四位數(1A2B遊戲)
# 2. 玩家可重覆猜電腦所產生的數字，並提示猜測的結果(EX:1A2B)
# 3. 一旦猜對，系統可自動計算玩家猜測的次數
# 關於print和cat的差異：http://kliangh.blogspot.tw/2016/03/r-1.html

# 我的假設：電腦隨機產生數字不可以重複
#           使用者可以輸入重複數字

# Global variable for counting guessing times
counter <- 0

# Random number!(4 digit)
random_number <- sample(0:9, 4)
random_number

repeat{
  a_count <- 0
  b_count <- 0
  input_number <- readline("請輸入猜測數字：");
  if (input_number == "exit") {
    cat("已經離開了遊戲！！\n")
    break
  }
  if (nchar(input_number) != 4) {
    cat("輸入長度不對！ 請從新輸入！！\n")
  } else {
    input_number_1 <- strtoi(substr(input_number, start = 1, stop = 1))
    input_number_2 <- strtoi(substr(input_number, start = 2, stop = 2))
    input_number_3 <- strtoi(substr(input_number, start = 3, stop = 3))
    input_number_4 <- strtoi(substr(input_number, start = 4, stop = 4))
    if (!(input_number_1 %in% seq(0, 9)) | 
        !(input_number_2 %in% seq(0, 9)) | 
        !(input_number_3 %in% seq(0, 9)) | 
        !(input_number_4 %in% seq(0, 9))) {
      cat("你的輸入有錯，請重新輸入！！\n")
    } else {
      ## 輸入正確才算一次猜測！
      counter <<- counter + 1
      user_input_list <- c(input_number_1, 
                           input_number_2, input_number_3, input_number_4) 
      for (a in 1:4) {
        if (random_number[a] == user_input_list[a]) {
          a_count <- a_count + 1
        }
        for (b in 1:4) {
          if (a == b) {
            next
          }
          if (user_input_list[a] == random_number[b]) {
            b_count <- b_count + 1
          }
        }
      }
      cat(paste(a_count, 'A, ', b_count, 'B'))
      cat('\n')
      # 成功猜到條件
      if (a_count == 4 && b_count == 0) {
        cat("你成功猜到了！總共輸入了: ", counter, "次")
        break
      }
    }
  }
}
