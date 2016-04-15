library(data.table)
library(dplyr)
library(ggplot2)
library(scales)

# setwd('/Users/nicholas/Dropbox/Election_data') # FOR MAC
setwd('C:\\Users\\ngarcia\\Dropbox\\Election_data') # FOR PC

#Souce: http://fec.gov/disclosurep/PDownload.do
Clinton <- read.csv('Clinton.csv', header = FALSE,
                    stringsAsFactors=FALSE)[,-19]
names(Clinton) <- Clinton[1,]
Clinton %>% head
Clinton <- data.table(Clinton[-1,])


Clinton$amount <- Clinton$contb_receipt_amt %>% as.numeric()
Clinton_states = Clinton %>% 
  group_by(contbr_st) %>%
  summarize(total = sum(amount),
            aver  = mean(amount),
            median = median(amount),
            number= length(amount),
            unique= length(unique(contbr_nm))
  )

#Souce: http://fec.gov/disclosurep/PDownload.do
Sanders <- read.csv('Sanders.csv', header = FALSE,
                    stringsAsFactors=FALSE)[,-19]
names(Sanders) <- Sanders[1,]
Sanders %>% head
Sanders <- data.table(Sanders[-1,])

Sanders$amount <- Sanders$contb_receipt_amt %>% as.numeric()
Sanders_states = Sanders %>% 
  group_by(contbr_st) %>%
  summarize(total = sum(amount),
            aver  = mean(amount),
            median = median(amount),
            number= length(amount),
            unique= length(unique(contbr_nm))
  )

states = merge(Sanders_states,Clinton_states, by = 'contbr_st',incomparables = 0)
uniques_ratio = data.frame(state = states$contbr_st, ratio_sanders = states$unique.x/( states$unique.x+ states$unique.y))

write.table(uniques_ratio, 'ratio-of-unique-donors-by-state-apr.csv',sep=',',row.names = FALSE)
