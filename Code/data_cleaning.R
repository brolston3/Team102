#This code does the following
#removes extra columns from orders dataset
#adds temp and percipitation to each order
#exports it as "orders_clean.csv"

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

#cleaning orders data
df.orders.clean = df.orders[-c(5:10,12,15:21,24,26)]
head(df.orders.clean)

#convert date to yyyy-mm-dd
df.orders.clean$created_at <- ymd_hms(df.orders.clean$created_at)
df.orders.clean$created_at <- as.Date(df.orders.clean$created_at)

#rename columns to match
df.weather.clean$created_at <- df.weather.clean$datetime

#merge columns based on created at
df.new = merge(x=df.orders.clean, y=df.weather.clean[, names(df.weather.clean) != "datetime"], 
               by="created_at")
head(df.new)

write.csv(df.new, './data/orders_clean.csv')

#############################cleaning orders dataset###############################
orders_clean = df.orders[-c(5:10,12,15:21,24,26)]
dim(orders_clean)

#item_Count column - Removed all rows associated with blank cells (N/A) in item count. 
#Removed 5.1% of the data. I.e From 135303 columns to 128378
orders_clean = orders_clean[!(is.na(orders_clean$item_count) | orders_clean$item_count==""), ]
dim(orders_clean)

#vendor_rating has 86710 NA columns. 
summary(orders_clean$vendor_rating)

#preparation_time has 48635 NA columns. 
summary(orders_clean$preparationtime)

#preparation_time has 48635 NA columns.
summary(orders_clean$created_at)

#separating created_at into a date column (created_at_date) and time column (created_at_time)
orders_clean$created_at_date <- as.Date(orders_clean$created_at)
orders_clean$created_at_time <- format(as.POSIXct(orders_clean$created_at), format = "%H:%M:%S")


#############################cleaning vendors dataset###############################
