### This script wants to show if the total emissions of PM2.5 have decreased since 1999 to 2008
### from vehicle sources in Baltimore(MD) and LA County
### thanks to the plot generation of the evolution of those emisions within the study years
require(data.table)
require(ggplot2)
# Dowloading the zip file and saving it on working folder
download.file(
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
        "dataNEI.zip"
)
# Unzipping it
unzip(
        "dataNEI.zip"
)
# Reading and loading on a dataset the emission file
classCodes = readRDS("Source_Classification_Code.rds")
summaryPM25 = readRDS("summarySCC_PM25.rds")
# Analyzing the data shows the best column to search by vehicle is SCC.Level.Two in order to not leave out
# mobile sources that are not typical cars. The baltimore condition is added 
baltimoreVehicle = subset(summaryPM25, SCC %in% as.vector(classCodes[grep("vehicle", classCodes$SCC.Level.Two, value =FALSE, ignore.case=TRUE),1]) & (fips=="24510" | fips=="06037"))
rm(summaryPM25)
rm(classCodes)
# Creating County Column and loading the county name instead of using fips code
baltimoreVehicle$county="" 
baltimoreVehicle[baltimoreVehicle$fips=="24510", ]$county = "Baltimore"
baltimoreVehicle[baltimoreVehicle$fips=="06037", ]$county = "L.A. County"
# Aggregating it by year and storing in new dataset
totalByYear = aggregate(baltimoreVehicle$Emissions,by=list(baltimoreVehicle$year,baltimoreVehicle$county),FUN = sum, na.rm=T)
rm(baltimoreVehicle)
# Adding column names
names(totalByYear) = c("Year","County","Total.Emissions")
# Generating the plot
ggplot(totalByYear, aes(Year, Total.Emissions, color = County))  +  geom_line() + labs(title = "Comparison Baltimore(MD) & L.A County Vehicle Emissions") + theme(legend.text = element_text(size = 5))
# Copying the result to the Png device and saving it
dev.copy(png,
         "plot6.png",
         width = 480,
         height = 480,
         units = "px")
# Closing the device
dev.off()
rm(totalByYear)
