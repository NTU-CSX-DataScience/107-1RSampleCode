### example_1_twitterR
### Refs:
## Package manual https://cran.r-project.org/web/packages/twitteR/twitteR.pdf
## Mapping Twitter Followers in R https://www.r-bloggers.com/mapping-twitter-followers-in-r/
## Twitter API : https://apps.twitter.com/
## Check followthehashtag to inspire some idea http://followthehashtag.com/

# BASIC REQUIRED PACKAGES
rm(list=ls(all.names=TRUE)) #remove the list
library(devtools)
library(twitteR)
library(data.table)

# STEP 1 : SET TWITTER API FOR USING twitteR PACKAGE"

consumerKey <- ""
consumerSecret <- ""
accessToken <- ""
accessSecret <- ""
options(httr_oauth_cache=T) # This will enable the use of a local file to cache OAuth access credentials between R sessions.
setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessSecret)


# STEP 2: GET THE  TAGGED TWEETS DATA LIST
# GET THE '#___________" TAGGED TWEETS
tweets <- searchTwitter('#airbnb', 
                        n=50, 
                        since = '2018-03-13', 
                        until = '2018-03-18')
tweets.list <- twListToDF(tweets)
names.list <-  rbindlist(lapply(tweets.list$screenName, 
                                as.data.frame))
names(names.list)[1] <- "Name" #CHANGE THE COLUMNS NAME

##STEP 3:GET EACH PERSON
alldata <- data.frame()

for (i in 1:3){ #Cursor
  tryCatch(
    {
      # get name from '#_______' users list
      tag.user <- names.list$Name[i]
      
      # print query location
      print(paste(i, tag.user))
      
      # get User's twitter account
      tag.user.account <- getUser(tag.user)
      
      # get account's friend (if accessible)
      user.friends <- tag.user.account$getFriends(retryOnRateLimit=180)
      print(length(user.friends))
      
      # limit
      if (length(user.friends) < 3000){

        # Make data.table of user's friends data list.
        friends.df <- rbindlist(lapply(user.friends, as.data.frame))
        
        # Get the only friends name column.
        friends.name.df <- data.frame(tempname=c(friends.df$name))
        
        # Change column name
        colname <- toString(tag.user)
        setnames(friends.name.df, c(colname))
        
        # Write table
        write.table(friends.name.df, file = paste(colname, ".csv"))
        
        # bind data in the same data.frame
        alldata <- rbind.fill(alldata, friends.name.df)
        #data <- cbind(list(data, friends.name.df))
      }
      else{
        print(paste(i, tag.user, "<== friends count > 500"))
      }
    },
    warning = function(w){},
    error = function(e){
      #ERROR (need to store it?)
      print(paste("ERROR", tag.user))
    },
    finally = {
      print("End Try&Catch")
    })
  
  i = i+1
}
