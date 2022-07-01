#This code does the following
#removes extra columns from orders dataset
#adds temp and percipitation to each order
#exports it as "orders_clean.csv"


library(dplyr)
library(lubridate)
library(tidyr)

#read the data
df.orders = read.csv('./data/orders.csv',header=TRUE)
df.vendors = read.csv('./data/vendors.csv',header=TRUE)
df.weather = read.csv('./data/muscat_weather_new.csv',header=TRUE)

#looking at the weather data
head(df.weather)

#selecting variables of interest (date, temp, precip)
df.weather.clean <- df.weather[c("datetime", "temp", "precip")]
class(df.weather.clean$datetime[1])

#convert date to yyyy-mm-dd
df.weather.clean$datetime <- ymd(df.weather.clean$datetime)

#cleaning orders data
df.orders.clean = df.orders[-c(5:10,12,15:21,24,26)]
head(df.orders.clean)

#convert date to yyyy-mm-dd
df.orders.clean$created_at <- ymd_hms(df.orders.clean$created_at)
df.orders.clean$created_at <- as.Date(df.orders.clean$created_at)

#rename columns to match
df.weather.clean$created_at <- df.weather.clean$datetime

#merge columns based on created at
df.orders.clean = merge(x=df.orders.clean, y=df.weather.clean[, names(df.weather.clean) != "datetime"], 
               by="created_at")
head(df.new)


#remove orders where item count == NA
df.orders.clean <- df.orders.clean[which(df.orders.clean["item_count"]>= 0),]

#remove orders where preparation time == NA
df.orders.clean <- df.orders.clean[which(df.orders.clean["preparationtime"] >= 5),]

#did they rate the vendor?
df.orders.clean$rated_vendor <- df.orders.clean$vendor_rating
df.orders.clean$rated_vendor[is.na(df.orders.clean$rated_vendor)] <- -1
df.orders.clean$rated_vendor <- as.factor(ifelse(df.orders.clean$rated_vendor >=0 , 1, 0))

#create a categorical variable for rain or no rain
#0.01 correlates to a "light drizzle"
df.orders.clean$rain<- as.factor(ifelse(df.orders.clean$precip > 0 , 1, 0))

#write to csv
write.csv(df.orders.clean,"./data/orders_clean.csv", row.names = FALSE)

################################################################################
#Looking at the vendors data
#analysis of columns to keep done in excel

#cleaning vendors data
df.vendors.clean = df.vendors[-c(2:4, 9, 13:14, 16:19, 21:50, 53:59)]
head(df.vendors.clean)

#Add a column for revenue
#Let's get revenue for each restaurant
totals <- c()
for (i in df.vendors.clean$id){
  new <- sum(df.orders.clean$grand_total[which(df.orders.clean$vendor_id == i)])
  totals <- c(totals, new)
}

#write it into the dataset under "revenue"
df.vendors.clean$revenue <- totals


#add a column for total items sold
items <- c()
for (i in df.vendors.clean$id){
  item.count <- sum(df.orders.clean$item_count[which(df.orders.clean$vendor_id == i)])
  print(i)
  print(item.count)
  items <- c(items, item.count)
}


df.vendors.clean$total_items <- items
#write to csv
write.csv(df.vendors.clean,"./data/vendors_clean.csv", row.names = FALSE)



