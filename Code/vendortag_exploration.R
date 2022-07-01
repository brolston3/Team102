
df.orders = read.csv('./data/orders.csv',header=TRUE)
df.vendors = read.csv('./data/vendors.csv',header=TRUE)

#converting vendor category to a factor
df.vendors$vendor_category_en <- as.factor(df.vendors$vendor_category_en)

#What columns do we want to keep from orders?
tokeep_orders = c('akeed_order_id',
                  'item_count',
                  'grand_total',
                  'vendor_rating',
                  'deliverydistance',
                  'preparationtime',
                  'delivery_time',
                  'picked_up_time',
                  'delivered_time',
                  'vendor_id',
                  'LOCATION_TYPE')

df.new =df.orders[tokeep_orders]
summary(df.new)
df.new$avgcost = df.new$grand_total/df.new$item_count
head(df.new)

#Combine all the vendor tags into one big list
vendortag = paste(df.vendors$vendor_tag_name,collapse=",")

#install.packages('stringr')
library('stringr')
library('dplyr')

#Split the list by comma
vendortag = c(str_split(vendortag,','))
vendortagsum = data.frame(vendortag)
colnames(vendortagsum) = 'tags'

#count number of occurrences of each tag
counttags = vendortagsum %>% count(tags, sort=TRUE)
head(counttags,10)
