setwd("C:/Users/LotteDerks/OneDrive - LevelUp Group/Documents/R cursus/ExploratoryDataAnalysis")

rm(list = ls())
library(data.table)

# read text file & remove NAs
textFile <- "./household_power_consumption.txt"

readTextFile <- read.table(textFile, sep = ";", header = TRUE, stringsAsFactors = FALSE)
powerConsumptionData <- na.omit(readTextFile)

# add an extra column to the dataset, which combines date + time
DateTime <- with(powerConsumptionData, paste(Date, Time))
DateTime <- strptime(DateTime, "%d/%m/%Y %H:%M:%S")
powerConsumptionData <- cbind(DateTime, powerConsumptionData)

# convert column 2 & 3 from character to date format 
powerConsumptionData$Date <- strptime(powerConsumptionData$Date, format = "%d/%m/%Y")
powerConsumptionData$Time <- strptime(powerConsumptionData$Time, format = "%H:%M:%S")

# convert column 3 until 9 from character to numeric format
powerConsumptionData[,3:9] <- lapply(powerConsumptionData[,3:9], as.numeric)

# only keep data from selected date: the first and second day of February 2007
cleanedData <- powerConsumptionData[which(powerConsumptionData$Date >= "2007-02-01" & powerConsumptionData$Date <= "2007-02-02"), ]
str(cleanedData)

# plot 2
png(file = "plot2.png", width = 480, height = 480)
par(mfrow = c(1,1))
with(cleanedData, plot(DateTime, Global_active_power, type = "l", col = "black", ylab = "Global Active Power (kilowatts)", xlab = ""))
dev.off()