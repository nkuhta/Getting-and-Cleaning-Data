##  Finding and Reading different file types
##  Refer to Coursera Getting and Cleaning Data course from John Hopkins

####################################################
#############    Downloading Files     #############
####################################################

#  Use R to download to make it part of the data processing flow

#  important to know the directory ie. getwd() and setwd()

#  important to use backword double slashes for windows (see below)
#  setwd("C:\\Users\\Data") 

#  checking for and creating directories

#file.exists("directoryName")

#dir.create("directoryName")

if (!file.exists("data")){      #  if data directory does not exist
  dir.create("data")            #  create the data directory
}

#  Getting data from internet = download.file(url,destfile = ,method)

#  Website
#  https://data.baltimorecity.gov/Transportation/Baltimore-Fixed-Speed-Cameras/dz54-2aru

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

#  Baltimore Camera Data
download.file(fileUrl,destfile = "./data/cameras.csv")

    #> list.files("./data")
    #[1] "cameras.csv"

print(list.files("./data"))

dateDownloaded <- date()
    #> dataDownloaded
    #[1] "Mon Oct 17 15:51:52 2016"

print(dateDownloaded)

####################################################
############    Reading Local Files     ############
####################################################

#  read.table() is the most common and robust command, but can be slow and reads data into RAM

#  important read.table() parameters are file, header, sep, row.names, nrows

#  Related:  read.csv() and read.csv2()

cameraData <- read.table("./data/cameras.csv",sep = ",",header = T)  #  need to specify comma separation and header exists

#  note read.csv() automatically sets sep=","  and  header = TRUE

head(cameraData)

#                          address direction      street  crossStreet               intersection                      Location.1
# 1       S CATON AVE & BENSON AVE       N/B   Caton Ave   Benson Ave     Caton Ave & Benson Ave (39.2693779962, -76.6688185297)
# 2       S CATON AVE & BENSON AVE       S/B   Caton Ave   Benson Ave     Caton Ave & Benson Ave (39.2693157898, -76.6689698176)
# 3 WILKENS AVE & PINE HEIGHTS AVE       E/B Wilkens Ave Pine Heights Wilkens Ave & Pine Heights  (39.2720252302, -76.676960806)
# 4        THE ALAMEDA & E 33RD ST       S/B The Alameda      33rd St     The Alameda  & 33rd St (39.3285013141, -76.5953545714)
# 5        E 33RD ST & THE ALAMEDA       E/B      E 33rd  The Alameda      E 33rd  & The Alameda (39.3283410623, -76.5953594625)
# 6        ERDMAN AVE & N MACON ST       E/B      Erdman     Macon St         Erdman  & Macon St (39.3068045671, -76.5593167803)

#  Important parameters 

#  quote = "" means no quotes
#  na.strings - set the character that represents a missing value
#  nrows - how many rows to read in the file
#  skip - number of lines to skip before starting to read

####################################################
############    Reading Excel Files     ############
####################################################

##  read_excel() is the best command and requires install.packages("readxl")

if (!file.exists("data")){      #  if data directory does not exist
  dir.create("data")            #  create the data directory
}

#fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"

#download.file(fileUrl,destfile = "./data/cameras.xlsx")

dateDownloaded <- date()

#  requires install.packages("readxl")
library(readxl)

cameraDataXLSX <- read_excel("./data/cameras.xlsx",sheet=1,col_names =T)

#  Reading specific rows and columns



