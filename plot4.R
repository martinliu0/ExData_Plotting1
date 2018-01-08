file_path <- paste(getwd(), "/household_power_consumption.txt", sep="")
if (files.exists(file_path)){
    hpc_data <- fread(file_path)
}

#filter data, only keep data from 2/1/2007 - 2/2/2007
hpc_data <- hpc_data[grepl("^[12]\\/2\\/2007$", Date)]

#convert columns to numeric values
idx <- names(hpc_data[,Global_active_power: Sub_metering_3])
hpc_data[, (idx) := lapply(.SD, as.numeric), .SDcols=idx]

#converting to date values and adding date time column
hpc_data[, Date := as.Date(Date, format="%d/%m/%Y"]
hpc_data[, DateTime := as.POSIXct(paste(Date, Time))]

#plot data
plot4 <- function(){
    png(filename="plot4.png", width=480, height=480)
    par(mfrow=c(2,2))
    #plot 1
    plot(hpc_data$DateTime, hpc_data$Global_active_power, type="l", xlab="", ylab="Global Active Power")
    #plot 2
    plot(hpc_data$DateTime, hpc_data$Voltage, type="l", xlab="datetime", ylab="Voltage")
    #plot 3
    plot(hpc_data$DateTime,hpc_data$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
    lines(hpc_data$DateTime,hpc_data$Sub_metering_2,col="red")
    lines(hpc_data$DateTime,hpc_data$Sub_metering_3,col="blue")
    legend("topright", col=c("black","red","blue"), c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),lty=c(1,1), lwd=c(1,1))
    #plot 4
    plot(hpc_data$DateTime,hpc_data$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
    dev.off()
}

plot4()
