### This script wants to show if the total emissions of PM2.5 of the city of Baltimore
### have decreased since 1999 to 2008 per every type,
### thanks to the plot generation of the evolution of those emisions within the study years
# Loading ggplot2
require(ggplot2)
# Dowloading the zip file and saving it on working folder
download.file(
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
        "dataNEI.zip"
)
# Unzipping it
unzip("dataNEI.zip")
# Reading and loading on a dataset the emission file
# classCodes = readRDS("Source_Classification_Code.rds")
summaryPM25 = readRDS("summarySCC_PM25.rds")
# Subsetting for Baltimore
baltimore = subset(summaryPM25, fips == "24510")
rm(summaryPM25)
# Aggregating it by year and type and storing in new dataset
totalByYear = aggregate(
        baltimore$Emissions,
        by = list(baltimore$year, baltimore$type),
        FUN = sum,
        na.rm = T
)
rm(baltimore)
# Adding column names
names(totalByYear) = c("Year", "Type", "Total.Emissions")
# Generating the plot
ggplot(totalByYear, aes(Year, Total.Emissions, color = Type))  +  geom_line() + labs(title = "Baltimore(MD) PM2.5 Emission per year & type") + theme(legend.text = element_text(size = 5))
# Copying the result to the Png device and saving it
dev.copy(png,
         "plot3.png",
         width = 480,
         height = 480,
         units = "px")
# Closing the device
dev.off()
rm(totalByYear)