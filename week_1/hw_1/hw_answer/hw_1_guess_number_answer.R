# 猜數字遊戲
# 1. 請寫一個由電腦隨機產生不同數字的四位數(1A2B遊戲)
# 2. 玩家可重覆猜電腦所產生的數字，並提示猜測的結果(EX:1A2B)
# 3. 一旦猜對，系統可自動計算玩家猜測的次數
# 關於print和cat的差異：http://kliangh.blogspot.tw/2016/03/r-1.html

# 無註解版
ans <- sample(0:9, 4)
guess.count <- 0

repeat {
  print("Please input 4 non-repetitive numbers.[integers between 0 to 9, aka c(0:9)")
  guess <- scan(nmax = 4)
  
  a <- b <- 0
  
  if (!any(duplicated(guess))){
    guess.count <- guess.count + 1
    
    for (i in 1:4) {
      if (guess[i] == ans[i]) {
        a <- a + 1
      } else {
        for (j in 1:4) {
          if (guess[i] == ans[j]) {
            b <- b + 1
          }
        }
      }
    }
    
    cat("==== Your guess :", guess, ", Match : ", a, "A", b, "B\n")
    
    if (a == 4) {
      cat("==== CORRECT! You guess for", guess.count, "times")
      break
    }
    
  } else {
    cat("==== Input Error: Please input 4 <non-repetitive> numbers.\n")
  }
}


# 註解版
# Real answer 
ans <- sample(0:9, 4)

# Record times of guessing
guess.count <- 0

# Repeat loop for guessing
repeat {
  # Hint message
  print("Please input 4 non-repetitive numbers.[integers between 0 to 9, aka c(0:9)")
  
  # Scan for input 
  guess <- scan(nmax = 4)
  
  # The matchs hint, correct-a and correct-b  
  a <- b <- 0
  
  # Check if the guess has duplicated numbers.
  if (!any(duplicated(guess))){
    
    # Guessing time plus 1
    guess.count <- guess.count + 1
    
    for (i in 1:4) {
      # Check for correct-a
      if (guess[i] == ans[i]) {
        a <- a + 1
      } else {
        # Check for correct-b
        for (j in 1:4) {
          if (guess[i] == ans[j]) {
            b <- b + 1
          }
        }
      }
    }
    # Hint message
    cat("==== Your guess :", guess, ", Match : ", a, "A", b, "B\n")
    
    # Game over situation
    if (a == 4) {
      cat("==== CORRECT! You guess for", guess.count, "times")
      break
    }
    
  } else {
    # The guess has duplicated numbers.
    cat("==== Input Error: Please input 4 <non-repetitive> numbers.\n")
  }
}