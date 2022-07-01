#import cleaned datasets
library(corrplot)
df.orders = read.csv('./data/orders_clean.csv',header=TRUE)
df.vendors = read.csv('./data/vendors_clean.csv',header=TRUE)

model1 <- lm(revenue~total_items+vendor_rating, data = df.vendors)

summary(model1)

cor(df.vendors[,c("revenue", "total_items", "vendor_rating", "prepration_time", "serving_distance")])
