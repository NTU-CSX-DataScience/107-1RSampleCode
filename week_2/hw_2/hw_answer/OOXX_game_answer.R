player.A <- 0  #sign O
player.B <- 0  #sign X
counter <- 0
player <- ""
user.input <- ""
position <- c(" ", " ", " ", " ", " ", " ", " ", " ", " ", " ")


# Input function
readInput <- function(){
  user.input <<- readline(paste("Player", player, "input(1~9) : "))
  return(user.input)
}

# Winning checking condition
WinningChecking <- function(){
  if ((position[1] == "O" & position[2] == "O" & position[3] == "O") |
      (position[4] == "O" & position[5] == "O" & position[6] == "O") |
      (position[7] == "O" & position[8] == "O" & position[9] == "O") |
      (position[1] == "O" & position[4] == "O" & position[7] == "O") |
      (position[2] == "O" & position[5] == "O" & position[8] == "O") |
      (position[3] == "O" & position[6] == "O" & position[9] == "O") |
      (position[1] == "O" & position[5] == "O" & position[9] == "O") |
      (position[3] == "O" & position[5] == "O" & position[7] == "O")) {
    cat("Player A wins!!! \n")
    return(TRUE)
  } 
  if ((position[1] == "X" & position[2] == "X" & position[3] == "X") |
      (position[4] == "X" & position[5] == "X" & position[6] == "X") |
      (position[7] == "X" & position[8] == "X" & position[9] == "X") |
      (position[1] == "X" & position[4] == "X" & position[7] == "X") |
      (position[2] == "X" & position[5] == "X" & position[8] == "X") |
      (position[3] == "X" & position[6] == "X" & position[9] == "X") |
      (position[1] == "X" & position[5] == "X" & position[9] == "X") |
      (position[3] == "X" & position[5] == "X" & position[7] == "X")) {
    cat("Player B wins!!! \n")
    return(TRUE)
  }
  if (position[1] != " " & position[2] != " " & position[3] != " " & 
      position[4] != " " & position[5] != " " & position[6] != " " & 
      position[7] != " " & position[8] != " " & position[9] != " " ) {
    cat("End in a draw!!! \n")
    return(TRUE)
  }
  return(FALSE)
}

# Check valid function
checkValid <- function(user.input){
  if(position[user.input] == " ") {
    if (player == "A") {
      position[user.input] <<- "O"
    } else if (player == "B") {
      position[user.input] <<- "X"
    }
    cat(paste0(position[1], "|", position[2], "|", position[3],"\n_____\n", position[4], "|", position[5], "|", position[6],"\n_____\n", position[7],"|", position[8],"|", position[9],"\n"))
    cat("**************\n")
    # Update player information !
    if (player == "A") {
      player.A <<- player.A + 1  #sign O
    } else {
      player.B <<- player.B + 1  #sign O
    }
  } else {
    cat("This position is already occupied!\n")
  }
}

flag <- TRUE
while(flag) {
  cat(paste0("Round ", player.A + player.B, "\n"))
  if (!(player.A + player.B)%%2) {
    cat("Now is player A's term! : \n")
    player <- "A"
  } else {
    cat("Now is player B's term! : \n")
    player <- "B"
  }
  cat(paste(readInput(), "\n"))
  if(user.input %in% seq(1, 9)){
    user.input <- strtoi(user.input)
    checkValid(user.input)
  } else if (user.input == "exit") {
    cat("Bye-Bye!!\n")
    break
  } else {
    cat("Invalid input! Please re-enter! \n")
  }
  # Winnig checking 
  if (WinningChecking()) {
    break
  }
}

