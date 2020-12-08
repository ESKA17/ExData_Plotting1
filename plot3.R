library(tibble)

## Checking if code was run before
if (file.exists("extrData.txt")) {
        extrData <- read.table("extrData.txt", header = T, sep = ";")
} else {
        ## Downloading and unzipping file if it does not exist
        if (!file.exists("household_power_consumption.zip") & 
            !file.exists("household_power_consumption.txt")) {
                myURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                download.file(myURL, destfile = "household_power_consumption.zip")
                unzip("household_power_consumption.zip")
        }
        
        ## Reading data
        data <- read.table("household_power_consumption.txt", sep = ";", header = T,
                           na.strings = "?")
        ## Subseting required dates and removing stored data
        extrData <- subset(data, data$Date == "1/2/2007" | data$Date == "2/2/2007")
        rm(list = "data")
        
        ## Writing new table
        write.table(extrData, file = "extrData.txt", row.names = F, sep = ";")
}

## Adding  date with time column
Date_Time <- paste(extrData$Date, extrData$Time, sep = " ") %>% 
        strptime(format = "%d/%m/%Y %H:%M:%S")
extrData <- add_column(extrData, Date_Time = Date_Time)
rm(list = "Date_Time")

## writing to png file "plot3.png"
png(file="plot3.png", width=480, height=480)
plot(extrData$Date_Time, extrData$Sub_metering_1, xlab = "",  
     ylab = "Energy sub metering", type = "l")
lines(extrData$Date_Time, extrData$Sub_metering_2, type = "l", col = "red")
lines(extrData$Date_Time, extrData$Sub_metering_3, type = "l", col = "blue")
legend("topright", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1, lwd  = 2, box.lty = 1)
dev.off()