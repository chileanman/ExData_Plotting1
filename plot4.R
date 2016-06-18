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

p2 <- p + geom_line(mapping = aes(x = dttm, y = Global_active_power)) +
  labs(x = "", y = "Global Active Power (kilowatts)")

p3 <-
  p + geom_line(aes(x = dttm, y = Sub_metering_1, color = "Sub_metering_1")) +
  geom_line(aes(x = dttm, y = Sub_metering_2, color = "Sub_metering_2")) +
  geom_line(aes(x = dttm, y = Sub_metering_3, color = "Sub_metering_3")) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1), legend.position="top") +
  labs(x="",y="Energy sub metering") +
  scale_color_manual(values=c("black", "red", "blue"))

p41<-p + geom_line(aes(x = dttm, y = Voltage)) +
  labs(x="datetime")

p42<-p + geom_line(aes(x = dttm, y = Global_reactive_power)) +
  labs(x="datetime")


# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

#chart
png(filename = "plot4.png", width = 480, height = 480, units = "px")
multiplot(p2,p3,p41,p42, cols = 2)
dev.off()