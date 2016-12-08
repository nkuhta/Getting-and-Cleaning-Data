##  Organizing, Merging, and Managing Data
##  Refer to Coursera Getting and Cleaning Data course from John Hopkins

####################################################
##############    Downloading Data    ##############
####################################################

#  Why create new variables? 

#  1.  Raw data doesn't have data of interest
#  2.  Need to transform data to get value of interest

#  Common variables to create = ...
#  ...Missing indicators, Cutting up quantitative variables, applying transforms

#  create data directory
if(!file.exists("./data")){dir.create("./data")}

#  data csv link
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"

download.file(fileUrl,destfile = "./data/restaurants.csv")

restData <- read.csv("./data/restaurants.csv")

####################################################
#############    Creating Sequences   ##############
####################################################

#  s1 is the sequence from 1 to 10 by increments of 2
s1 = seq(1,10,by=2); s1
  #[1] 1 3 5 7 9

#  s2 = 3 equally spaced sequencial points between (and including) 1 and 10. 
s2 = seq(1,10,length=3); s2
  #[1]  1.0  5.5 10.0

#  index sequence for vector x
x <- c(1,3,8,25,100); seq(along=x)
    #[1] 1 2 3 4 5

####################################################
###########    Subsetting Variables   ##############
####################################################

#  create a new "nearMe" catagory for restaurants in certain neighborhoods.  
restData$nearMe = restData$neighborhood %in% c("Roland Park","Homeland")

table(restData$nearMe)
  # FALSE  TRUE 
  # 1314    13 

####################################################
###########    Create Binary Variables   ###########
####################################################

#  If zipcode < 0 you get a T, else F
restData$zipWrong = ifelse(restData$zipCode <0,T,F)

table(restData$zipWrong,restData$zipCode<0)
    #       FALSE TRUE
    # FALSE  1326    0
    # TRUE      0    1

####################################################
############    Categorical Variables   ############
####################################################

restData$zipGroups = cut(restData$zipCode,breaks=quantile(restData$zipCode))

table(restData$zipGroups)
  # (-2.123e+04,2.12e+04]  (2.12e+04,2.122e+04] (2.122e+04,2.123e+04] (2.123e+04,2.129e+04] 
  # 337                   375                   282                   332 

table(restData$zipGroups,restData$zipCode)
  #                       -21226 21201 21202 21205 21206 21207 21208 21209 21210 21211 21212 21213 21214
  # (-2.123e+04,2.12e+04]      0   136   201     0     0     0     0     0     0     0     0     0     0
  # (2.12e+04,2.122e+04]       0     0     0    27    30     4     1     8    23    41    28    31    17
  # (2.122e+04,2.123e+04]      0     0     0     0     0     0     0     0     0     0     0     0     0
  # (2.123e+04,2.129e+04]      0     0     0     0     0     0     0     0     0     0     0     0     0
  # 
  #                       21215 21216 21217 21218 21220 21222 21223 21224 21225 21226 21227 21229 21230
  # (-2.123e+04,2.12e+04]     0     0     0     0     0     0     0     0     0     0     0     0     0
  # (2.12e+04,2.122e+04]     54    10    32    69     0     0     0     0     0     0     0     0     0
  # (2.122e+04,2.123e+04]     0     0     0     0     1     7    56   199    19     0     0     0     0
  # (2.123e+04,2.129e+04]     0     0     0     0     0     0     0     0     0    18     4    13   156
  # 
  #                       21231 21234 21237 21239 21251 21287
  # (-2.123e+04,2.12e+04]     0     0     0     0     0     0
  # (2.12e+04,2.122e+04]      0     0     0     0     0     0
  # (2.122e+04,2.123e+04]     0     0     0     0     0     0
  # (2.123e+04,2.129e+04]   127     7     1     3     2     1

####################################################
###############    Easier Cutting   ################
####################################################
























