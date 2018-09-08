### practice_1_answer
### functions

### function SayHello #####################################################
SayHello <- function (name) {
  print(paste("Hello,", name))
}

SayHello("Pecu")

### function GetBmi #######################################################
GetBmi <- function (my.height.cm, my.weight.kg) {
  
  # Create my.height.m by my.height.cm 
  my.height.m <- my.height.cm / 100
  
  # Create my.bmi with BMI(Body Mass Index) formula
  my.bmi <- my.weight.kg / (my.height.m) ^ 2  
  
  # Return my.bmi
  return (my.bmi)
}

GetBmi(180, 55)

### function CheckBmiLevel ################################################
CheckBmiLevel <- function (my.height.cm, my.weight.kg) {
  # Call the GetBmi function we just made
  my.bmi <- GetBmi(my.height.cm, my.weight.kg)
  
  if (my.bmi >= 35) {
    return(paste("Your bmi: ", my.bmi, ", 重度肥胖!"))
  } else if (my.bmi >= 30) {
    return(paste("Your bmi: ", my.bmi, ", 中度肥胖!"))
  } else if (my.bmi >= 27) {
    return(paste("Your bmi: ", my.bmi, ", 輕度肥胖!"))
  } else if (my.bmi >= 24) {
    return(paste("Your bmi: ", my.bmi, ", 過重!"))
  } else if (my.bmi >= 18.5) {
    return(paste("Your bmi: ", my.bmi, ", 正常範圍"))
  } else {
    return(paste("Your bmi: ", my.bmi, ", 過輕!"))
  }  
}

bmi.level.msg <- CheckBmiLevel(176, 70)
bmi.level.msg

### function GetLargest ###################################################
GetLargest <- function (vector) {
  print(paste("The Largest Number is :", max(vector)))
}

vec_1 <- c(1, 5, 10, 200, 2000, 121)
GetLargest(vec_1)