##  Downloading and Analysis Quiz for Week 1
##  Refer to Coursera Getting and Cleaning Data course from John Hopkins

############################
#### Q1 - Idaho Housing ####
############################
# 
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() 
# from here:
#   
#      https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
#  and load the data into R. The code book, describing the variable names is here:
#   
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
#   How many properties are worth $1,000,000 or more?
#

if (!file.exists("data")){      #  if "data" directory does not exist in the code location
  dir.create("data")            #  create the "data" directory
}

#  Housing Data CSV link
IdahoCSV <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

#  Download CSV data
download.file(IdahoCSV,destfile = "./data/IDdata.csv")

#  Housing Parameter Descriptions (PDF) - VAL is the property value parameter
#IDinfo <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"

#  Download the parameter info PDF
#download.file(IDinfo,destfile = "./data/IDInfo.pdf")

#  Download Date
IDDownloadDate <- date()

#  read the whole housing data file 
IdahoDataRead <- read.table("./data/IDdata.csv",sep = ",",header = T)

# There are 6496 housing entries with 188 parameters, The VAL parameter is property value.
dim(IdahoDataRead)
#[1] 6496  188  

#  Raw Property Values Vector (including NAs)  
PropertyValuesRaw <- IdahoDataRead$VAL

#  find vector of rental "NA" values
Rentals <- is.na(PropertyValuesRaw)

#  Vector of all Idaho Home Value Codes - Excludes the not for sale, vacant, or rental properties
IdahoData <- PropertyValuesRaw[!Rentals]

#  Logical vector of million dollar homes - TRUE means it's a 1M+ home
MillVec <- IdahoData==24

#  Number of Million Dollar Homes
NumMillHomes <- length(IdahoData[MillVec])

  # > NumMillHomes
  # [1] 53


#####################################
#### Q3 - Natural Gas Aquisition ####
#####################################

#   Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#   
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
# 
#   Read rows 18-23 and columns 7-15 into R and assign the result to a variable called "dat"
#
#   What is the value of:  sum(dat$Zip*dat$Ext,na.rm=T)
#

if (!file.exists("data")){      #  if "data" directory does not exist in the code location
  dir.create("data")            #  create the "data" directory
}

#  Gas Data XLSX link
GasLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

#  Download XLSX data - note the mode = "wb" is required here to have a non-corrupt xlsx file
download.file(GasLink,destfile = "./data/GasData.xlsx",mode = "wb")

#  requires install.packages("openxlsx")
library(openxlsx)

#  Read rows 18-23 and columns 7-15 using the "openxlsx" library
dat <- read.xlsx("./data/GasData.xlsx",sheet=1,colNames = T,rows = 18:23,cols = 7:15)

Q3Value <- sum(dat$Zip*dat$Ext,na.rm=T)
  #[1] 36534720

#########################################
#### Q4 - XML Baltimore Restaurants  ####
#########################################
#
#  Read the XML data on Baltimore restaurants from here:
#   
#    https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
# 
#  How many restaurants have zipcode 21231?
#

if (!file.exists("data")){      #  if "data" directory does not exist in the code location
  dir.create("data")            #  create the "data" directory
}

#  Baltimore restaurant xml data
XMLLink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

#  Requires install.packages("XML")
library(XML)

> 
#  download the xml file
download.file(XMLLink,destfile = "./data/Baltimore.xml")

doc <- xmlTreeParse(file = "./data/Baltimore.xml",useInternalNodes = T)

#   xmlTreeParse may not work on the site directly (below) behind a firewall
#doc <- xmlTreeParse(fileUrlXML,isURL = T,useInternalNodes = T)

#  xmlRoot of the Baltimore XML file
rootNode <- xmlRoot(doc)

#  get a list of the zipcodes
zips <- xpathSApply(rootNode,"//zipcode",xmlValue)

#  target zipcode
target <- 21231

#  Logical Vector which is T when zipcode = target
ZipsVec <- zips==target

#  Number of restaurants in the target zipcode
length(zips[ZipsVec])
#[1] 127

#########################################
####  Q5 - Idaho data.table speeds  #####
#########################################
# 
#   The American Community Survey distributes downloadable data about United States 
#   communities. Download the 2006 microdata survey about housing for the state of 
#   Idaho using download.file() from here:
#   
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# 
#   using the fread() command load the data into an R object
#   The following are ways to calculate the average value of the variable pwgtp15

library(data.table)

if (!file.exists("data")){      #  if "data" directory does not exist in the code location
  dir.create("data")            #  create the "data" directory
}

#  Data CSV link
CSVData <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

#  Download CSV data
download.file(CSVData,destfile = "./data/IDcsv.csv")

DT <- fread("./data/IDcsv.csv")

#  System mean calculation times below 

# > system.time(DT[,mean(pwgtp15),by=SEX])
# user  system elapsed 
# 0.02    0.00    0.02 
# 
# > system.time(tapply(DT$pwgtp15,DT$SEX,mean))
# user  system elapsed 
# 0       0       0 
# 
# > system.time(mean(DT$pwgtp15,by=DT$SEX))
# user  system elapsed 
# 0       0       0 
# 
# > system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
# user  system elapsed 
# 0       0       0 

