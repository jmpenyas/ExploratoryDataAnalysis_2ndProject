### This script wants to show if the total emissions of PM2.5 have decreased since 1999
### thanks to the plot generation of the evolution of those emisions within the study years
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
# classCodes = readRDS("Source_Classification_Code.rds")
summaryPM25 = readRDS("summarySCC_PM25.rds")
# Aggregating it by year and storing in new dataset
totalByYear = aggregate(summaryPM25$Emissions,by=list(summaryPM25$year),FUN = sum, na.rm=T)
rm(summaryPM25)
# Adding column names
names(totalByYear) = c("Year","Total.Emissions")
# Generating the plot
barplot(
        totalByYear$Total.Emissions,
        names.arg=totalByYear$Year,
        col = "red",
        ylab = "PM2.5 Total Emissions",
        xlab = "Years"
)
# Copying the result to the Png device and saving it
dev.copy(png,
         "plot1.png",
         width = 480,
         height = 480,
         units = "px")
# Closing the device
dev.off()
rm(totalByYear)