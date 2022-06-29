
#read the data
df.orders = read.csv('./data/orders.csv',header=TRUE)
df.vendors = read.csv('./data/vendors.csv',header=TRUE)

#converting vendor category to a factor
df.vendors$vendor_category_en <- as.factor(df.vendors$vendor_category_en)

head(df.vendors)

#examine distribution of ratings
ratings <- df.vendors$vendor_rating
hist(ratings)
max(ratings)
min(ratings)

#pull preparation time
prep.times <- df.vendors$prepration_time
hist(prep.times)
max(prep.times)
min(prep.times)

#examine serving distance
hist(df.vendors$serving_distance)
max(df.vendors$serving_distance)
min(df.vendors$serving_distance)

#discerning trends from variables of concern
#serving_distance
plot(vendor_rating~serving_distance, 
     data = df.vendors[df.vendors$vendor_category_en == "Restaurants",], 
     main = "", 
     col = "grey")
#prep_time
plot(vendor_rating~prepration_time, 
     data = df.vendors[df.vendors$vendor_category_en == "Restaurants",],
     main = "", 
     col = "grey")
#vendor rating
plot(vendor_rating~vendor_category_en, 
     data = df.vendors, 
     main = "", 
     col = "grey")


#########################################################################

#Examining the orders dataset
head(df.orders)

#list of import factors for determining sales
sales.factors <- c("customer_id", "item_count", "grand_total", "vendor_id")

hist(df.orders$vendor_id)

#are there vendors who weren't ordered from?
length(unique(df.orders$vendor_id))

#Yes, all vendors were ordered from at least once
#Let's get revenue for each restaurant
totals <- c()
for (i in df.vendors$id){
  new <- sum(df.orders$grand_total[which(df.orders$vendor_id == i)])
  totals <- c(totals, new)
}

#write it into the dataset under "revenue"
df.vendors$revenue <- totals
hist(df.vendors$revenue)

# re-analyze based on revenue
plot(revenue~serving_distance, 
     data = df.vendors[df.vendors$vendor_category_en == "Restaurants",], 
     main = "", 
     col = "grey")
#prep_time
plot(revenue~prepration_time, 
     data = df.vendors[df.vendors$vendor_category_en == "Restaurants",],
     main = "", 
     col = "grey")
#vendor rating
plot(revenue~vendor_category_en, 
     data = df.vendors, 
     main = "", 
     col = "grey")


#Examine item count
hist(df.orders$item_count)
max(df.orders$item_count)
min(df.orders$item_count)

#Let's get total items sold for each restaurant
total.items <- c()
for (i in df.vendors$id){
  new <- sum(df.orders$item_count[which(df.orders$vendor_id == i)])
  total.items <- c(total.items, new)
}

#write it in under total_items
df.vendors$total_items <- total.items

hist(df.vendors$total_items)

#does this have an effect on ratings?
plot(vendor_rating~total_items, 
     data = df.vendors, 
     main = "", 
     col = "grey")
#more items seems to equate to better ratings

#do more items result in more revenue?
plot(df.vendors$revenue~df.vendors$total_items, 
     data = df.vendors, 
     main = "", 
     col = "grey")



