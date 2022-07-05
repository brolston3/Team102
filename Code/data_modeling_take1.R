library(corrplot)
library(tidyr)
library(dplyr)

#import cleaned datasets
df.orders = read.csv('./data/orders_clean.csv',header=TRUE)
df.vendors = read.csv('./data/vendors_clean.csv',header=TRUE)

#look at the orders data
head(df.orders)

#get a list of unique days
days <- unique(df.orders["created_at"])

#loop through each day and sum total number of items
#add each total to days df
item_totals <- c()
for (day in days$created_at){
  
  total_items <- sum(df.orders[which(df.orders$created_at == day),4])
  item_totals <- c(item_totals, total_items)
  
}

#write to item totals
days$total_items <- item_totals

#merge in weather and precipitation
days <- left_join(x = days, y = df.orders[,c("created_at", "temp", "precip", "rain")], by = "created_at")
days <- distinct(days)

#run a model looking at item count based on rain and temp

model1 <- lm(item_totals~temp+precip, data = days)
summary(model1)  

#find outliers
cook = cooks.distance(model1)
plot(cook,
     type="h",
     lwd=3,
     col="darkred",
     ylab = "Cook's Distance",
     main="Cook's Distance")

#find the max
cook[cook == max(cook)]


#Residual analysis
resids = rstandard(model1)
fits = model1$fitted

plot(days$temp,
     resids,
     xlab="temp",
     ylab="Residuals",
     main=" ",
     col="darkblue")
    #not terrible, centered significantly around 0 

plot(days$precip,
     resids,
     xlab="precip",
     ylab="Residuals",
     main="",
     col="darkblue")
    #extremely varied based on whether it rained or not. Seems to be centered around 0.


plot(fits,
     resids,
     xlab="Fitted",
     ylab="Residuals",
     main="",
     col="darkblue")
    #Centered around 0, one point with a really high residual error




