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

# plot 4
png(file = "plot4.png", width = 480, height = 480)
par(mfcol = c(2,2))
# plot topleft
with(cleanedData, plot(DateTime, Global_active_power, type = "l", col = "black", ylab = "Global Active Power (kilowatts)", xlab = ""))

# plot bottomleft
with(cleanedData, plot(DateTime, Sub_metering_1, type = "l", col = "black", ylab = "Energy sub metering", xlab = ""))
with(cleanedData, lines(DateTime, Sub_metering_2, col = "red"))
with(cleanedData, lines(DateTime, Sub_metering_3, col = "blue"))
with(cleanedData, legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")))

# plot topright
with(cleanedData, plot(DateTime, Voltage, type = "l", col = "black", ylab = "Voltage", xlab = "datetime"))

# plot bottomright
with(cleanedData, plot(DateTime, Global_reactive_power, type = "l", col = "black", ylab = "Global Reactive Power (kilowatts)", xlab = "datetime"))
dev.off()
