### This script wants to show if the total emissions of PM2.5 have decreased since 1999 to 2008
### from could sources across the US
### thanks to the plot generation of the evolution of those emisions within the study years
require(data.table)
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
#Getting Coal emissions from the codes vector obtained from classCodes that contains the word Coal
coalEmissions = subset(summaryPM25, SCC %in% as.vector(classCodes[grep("Coal", classCodes$EI.Sector, value =FALSE),]$SCC))
rm(summaryPM25)
rm(classCodes)
# Aggregating it by year and storing in new dataset
totalByYear = aggregate(coalEmissions$Emissions,by=list(coalEmissions$year),FUN = sum, na.rm=T)
rm(coalEmissions)
# Adding column names
names(totalByYear) = c("Year","Total.Emissions")
# Generating the plot
barplot(
        totalByYear$Total.Emissions,
        names.arg=totalByYear$Year,
        col = "Green",
        ylab = "PM2.5 Total Emissions",
        xlab = "Years",
        main = "PM2.5 Emissions Evolution 1999-2008 from Coal Sources"
)
# Copying the result to the Png device and saving it
dev.copy(png,
         "plot4.png",
         width = 480,
         height = 480,
         units = "px")
# Closing the device
dev.off()
rm(totalByYear)
