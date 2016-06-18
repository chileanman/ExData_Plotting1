library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

rm(list = ls())
setwd(
  "/Users/felipeflores/Desktop/Data Science/Coursera/exdata_data_household_power_consumption/"
)

dt <- fread("household_power_consumption.txt", na.strings = "?")

dt1 <- dt %>% filter(Date == "1/2/2007" | Date == "2/2/2007")

#data prep
dtm <- paste(dt1$Date, dt1$Time, sep = " ")
## df<-as.data.frame.matrix(dt1) ## convert to df (backup)
dt1$dttm <-
  as.POSIXct(strptime(dtm, "%e/%m/%Y %H:%M:%S"), tz = "Australia/Melbourne")
dt1$wday <- wday(dt1$dttm, label = TRUE, abbr = TRUE)

p <- ggplot(data = dt1)

p3 <-
  p + geom_line(aes(x = dttm, y = Sub_metering_1, color = "Sub_metering_1")) +
  geom_line(aes(x = dttm, y = Sub_metering_2, color = "Sub_metering_2")) +
  geom_line(aes(x = dttm, y = Sub_metering_3, color = "Sub_metering_3")) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1), legend.position="top") +
  labs(x="",y="Energy sub metering") +
  scale_color_manual(values=c("black", "red", "blue"))

#chart
png(filename = "plot3.png", width = 480, height = 480, units = "px")
p3
dev.off()
