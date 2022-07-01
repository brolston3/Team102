library(dplyr)
library(lubridate)

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

#select just the dates/id of orders table
df.order.date <- df.orders[c("akeed_order_id", "created_at")]

#convert date to yyyy-mm-dd
df.order.date$created_at <- ymd_hms(df.order.date$created_at)
df.order.date$created_at <- as.Date(df.order.date$created_at)

#rename columns to match
df.weather.clean$created_at <- df.weather.clean$datetime

df.new = merge(x=df.order.date, y=df.weather.clean, by="created_at")

#cleaning orders data
orders_clean = df.orders[-c(5:10,12,15:21,24,26)]
dim(orders_clean)

#item_Count column - Removed all rows associated with blank cells (N/A) in item count. 
#Removed 5.1% of the data. I.e From 135303 columns to 128378
orders_clean = orders_clean[!(is.na(orders_clean$item_count) | orders_clean$item_count==""), ]
dim(orders_clean)

#vendor_rating has 86710 NA columns. Should we replace with -1?
summary(orders_clean$vendor_rating)

#preparation_time has 48635 NA columns. Should we replace with -1?
summary(orders_clean$preparationtime)

#preparation_time has 48635 NA columns. Should we replace with -1?
summary(orders_clean$created_at)
View(orders_clean)
