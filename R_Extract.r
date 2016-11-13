##  Database Extraction tools
##  Refer to Coursera Getting and Cleaning Data course from John Hopkins

####################################################
###############    Reading MySQL     ###############
####################################################


#  Step 1 - Install MySQL 
#  http://dev.mysql.com/doc/refman/5.7/en/installing.html

#  Step 2 - Install RMySQL
#  install.packages("RMySQL") (on Mac)
#  Windows - http://www.ahschulz.de/2013/07/23/installing-rmysql-under-windows/

#  Note RMySQL may not run behind a work firewall 

library(RMySQL)

ucscDB <- dbConnect(MySQL(),user="genome",host="genome-mysql.cse.ucsc.edu")

#  Apply a query to the database
result <- dbGetQuery(ucscDB,"show databases;")

#  Always Disconnect
dbDisconnect(ucscDB)

#  Print out the MySQL Query output
result
    # Database
    # 1   information_schema
    # 2              ailMel1
    # 3              allMis1
    # 4              anoCar1
    # .
    # .
    # .
    # .
    # 218            vicPac2
    # 219           visiGene
    # 220            xenTro1
    # 221            xenTro2
    # 222            xenTro3
    # 223            xenTro7

#  focus on a particular human genome build, hg19 is a dataframe
hg19 <- dbConnect(MySQL(),user="genome",db="hg19",host="genome-mysql.cse.ucsc.edu")

allTables <- dbListTables(hg19)

length(allTables)
    #[1] 11047

allTables[1:5]
    # [1] "HInv"         "HInvGeneMrna"
    # [3] "acembly"      "acemblyClass"
    # [5] "acemblyPep"  

#  grab all the fields in a particular hg19 row (fields are like columns)
dbListFields(hg19,"affyU133Plus2")
    # [1] "bin"         "matches"    
    # [3] "misMatches"  "repMatches" 
    # [5] "nCount"      "qNumInsert" 
    # [7] "qBaseInsert" "tNumInsert" 
    # [9] "tBaseInsert" "strand"     
    # [11] "qName"       "qSize"      
    # [13] "qStart"      "qEnd"       
    # [15] "tName"       "tSize"      
    # [17] "tStart"      "tEnd"       
    # [19] "blockCount"  "blockSizes" 
    # [21] "qStarts"     "tStarts"    

#  previously we say there are 22 fields for the parameter of interest
#  now the query below shows how many rows for the 22 columns
dbGetQuery(hg19,"select count(*) from affyU133Plus2")
    # count(*)
    # 1    58463

affyData <- dbReadTable(hg19,"affyU133Plus2")
head(affyData)
    #   bin matches misMatches repMatches nCount qNumInsert qBaseInsert tNumInsert tBaseInsert strand        qName qSize qStart qEnd tName     tSize tStart  tEnd blockCount
    # 1 585     530          4          0     23          3          41          3         898      -  225995_x_at   637      5  603  chr1 249250621  14361 15816          5
    # 2 585    3355         17          0    109          9          67          9       11621      -  225035_x_at  3635      0 3548  chr1 249250621  14381 29483         17
    # 3 585    4156         14          0     83         16          18          2          93      -  226340_x_at  4318      3 4274  chr1 249250621  14399 18745         18
    # 4 585    4667          9          0     68         21          42          3        5743      - 1557034_s_at  4834     48 4834  chr1 249250621  14406 24893         23
    # 5 585    5180         14          0    167         10          38          1          29      -    231811_at  5399      0 5399  chr1 249250621  19688 25078         11
    # 6 585     468          5          0     14          0           0          0           0      -    236841_at   487      0  487  chr1 249250621  27542 28029          1
    #                                                                  blockSizes                                                                                                qStarts
    # 1                                                          93,144,229,70,21,                                                                                    34,132,278,541,611,
    # 2              73,375,71,165,303,360,198,661,201,1,260,250,74,73,98,155,163,                        87,165,540,647,818,1123,1484,1682,2343,2545,2546,2808,3058,3133,3206,3317,3472,
    # 3                 690,10,32,33,376,4,5,15,5,11,7,41,277,859,141,51,443,1253,                   44,735,746,779,813,1190,1195,1201,1217,1223,1235,1243,1285,1564,2423,2565,2617,3062,
    # 4 99,352,286,24,49,14,6,5,8,149,14,44,98,12,10,355,837,59,8,1500,133,624,58, 0,99,452,739,764,814,829,836,842,851,1001,1016,1061,1160,1173,1184,1540,2381,2441,2450,3951,4103,4728,
    # 5                                       131,26,1300,6,4,11,4,7,358,3359,155,                                                     0,132,159,1460,1467,1472,1484,1489,1497,1856,5244,
    # 6                                                                       487,                                                                                                     0,
    #                                                                                                                                     tStarts
    # 1                                                                                                             14361,14454,14599,14968,15795,
    # 2                                     14381,14454,14969,15075,15240,15543,15903,16104,16853,17054,17232,17492,17914,17988,18267,24736,29320,
    # 3                               14399,15089,15099,15131,15164,15540,15544,15549,15564,15569,15580,15587,15628,15906,16857,16998,17049,17492,
    # 4 14406,20227,20579,20865,20889,20938,20952,20958,20963,20971,21120,21134,21178,21276,21288,21298,21653,22492,22551,22559,24059,24211,24835,
    # 5                                                                         19688,19819,19845,21145,21151,21155,21166,21170,21177,21535,24923,
    # 6                                                                                                                                     27542,

#  Select a specific subset

query <- dbSendQuery(hg19,"select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query);quantile(affyMis$misMatches)
    # 0%  25%  50%  75% 100% 
    # 1    1    2    2    3 

#  small data set
affyMisSmall <- fetch(query,n=10); dbClearResult(query);
    #[1] TRUE

dim(affyMisSmall)
    #[1] 10 22

###  DON'T FORGET TO CLOSE THE CONNECTION!!!!

dbDisconnect(hg19)
    #[1] TRUE

#  Nice blog summarizing other MySQL and R commands:
#  http://www.r-bloggers.com/mysql-and-r/


####################################################
###############    Reading HDF5     ################
####################################################

#  Heirarchical data format = HDF

#  Loading the package
#  source("http://bioconductor.org/biocLite.R")
#  biocLite("rhdf5")

library(rhdf5)

created=h5createFile("example.h5")

created
    #[1] TRUE

#  Creating Groups

#  create group foo
created=h5createGroup("example.h5","foo")
#  create group baa
created=h5createGroup("example.h5","baa")
#  create group foo with sub-group foobaa
created=h5createGroup("example.h5","foo/foobaa")

h5ls("example.h5")
    # group   name     otype dclass dim
    # 0     /    baa H5I_GROUP           
    # 1     /    foo H5I_GROUP           
    # 2  /foo foobaa H5I_GROUP   

#  Write to the groups

A=matrix(1:10,nr=5,nc=2)

h5write(A,"example.h5","foo/A")

B=array(seq(0.1,2,by=0.1),dim=c(5,2,2))

#  assign units
attr(B,"scale") <- "liter"

h5write(B,"example.h5","foo/foobaa/B")

h5ls("example.h5")
    # group   name       otype  dclass       dim
    # 0           /    baa   H5I_GROUP                  
    # 1           /    foo   H5I_GROUP                  
    # 2        /foo      A H5I_DATASET INTEGER     5 x 2
    # 3        /foo foobaa   H5I_GROUP                  
    # 4 /foo/foobaa      B H5I_DATASET   FLOAT 5 x 2 x 2

#  Writing a data set to the top-level group

df=data.frame(1L:5L,seq(0,1,length.out = 5),c("ab","cde","fghi","a","s"),stringsAsFactors = F)

    # > 1L:5L
    # [1] 1 2 3 4 5
    # > seq(0,1,length.out = 5)
    # [1] 0.00 0.25 0.50 0.75 1.00

h5write(df,"example.h5","df")

h5ls("example.h5")
    # group   name       otype   dclass       dim
    # 0           /    baa   H5I_GROUP                   
    # 1           /     df H5I_DATASET COMPOUND         5
    # 2           /    foo   H5I_GROUP                   
    # 3        /foo      A H5I_DATASET  INTEGER     5 x 2
    # 4        /foo foobaa   H5I_GROUP                   
    # 5 /foo/foobaa      B H5I_DATASET    FLOAT 5 x 2 x 2


#   Reading Data

readA=h5read("example.h5","foo/A")
readB=h5read("example.h5","foo/foobaa/B")
readC=h5read("example.h5","df")

    # > readA
    #       [,1] [,2]
    # [1,]    1    6
    # [2,]    2    7
    # [3,]    3    8
    # [4,]    4    9
    # [5,]    5   10
    # > readB
    # , , 1
    # 
    #       [,1] [,2]
    # [1,]  0.1  0.6
    # [2,]  0.2  0.7
    # [3,]  0.3  0.8
    # [4,]  0.4  0.9
    # [5,]  0.5  1.0
    # 
    # , , 2
    # 
    #       [,1] [,2]
    # [1,]  1.1  1.6
    # [2,]  1.2  1.7
    # [3,]  1.3  1.8
    # [4,]  1.4  1.9
    # [5,]  1.5  2.0
    # 
    # > readC
    # X1L.5L seq.0..1..length.out...5.
    # 1      1                      0.00
    # 2      2                      0.25
    # 3      3                      0.50
    # 4      4                      0.75
    # 5      5                      1.00
    # c..ab....cde....fghi....a....s..
    # 1                               ab
    # 2                              cde
    # 3                             fghi
    # 4                                a
    # 5                                s


#  Reading and Writing in Chunks

#  write 12,13,14 to the first 3 rows of the column 1
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))

h5read("example.h5","foo/A")
    # > h5read("example.h5","foo/A")
    #       [,1] [,2]
    # [1,]   12    6
    # [2,]   13    7
    # [3,]   14    8
    # [4,]    4    9
    # [5,]    5   10

####################################################
##########    Reading from the Web     #############
####################################################

#  Webscraping - Programatically extract data from HTML code
#  In some cases this is against the terms of service for a website

#  Example - Google Scholar

con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")

htmlCode = readLines(con)

close(con)

htmlCode
    # [1] "<!doctype html><head><meta http-equiv=\"Content-Type
    # \" content=\"text/html;charset=ISO-8859-1\"><meta http-equiv=
    # \"X-UA-Compatible
    # .
    # .
    # .
    # .
    # /a> <a href=\"/citations?hl=en&amp;oe=ASCII\">Get my own profile
    # </a></div></div></div></div></div><div id=\"gs_rdy\"></div></body></html>"

#  Parsing with XML

library(XML)

url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"

html <- htmlParse(url,useInternalNodes = T)

#  When parsing directly doesn't work you can download

if (!file.exists("data")){      #  if data directory does not exist
  dir.create("data")            #  create the data directory
}

#  Download Method
#download.file(url,destfile = "./data/GS.html")
#html <- htmlTreeParse(file = "./data/GS.html",useInternalNodes = T)

xpathSApply(html,"//title",xmlValue)
    #[1] "Jeff Leek - Google Scholar Citations"

xpathSApply(html,"//td[@id='col-citedby']",xmlValue)
#  cannot get this to work

#####################
###  GET command  ###
#####################

#  httr package 
library(httr)

#  GET the url link (above)
html2=GET(url)

content2 = content(html2,as="text")

parsedHtml=htmlParse(content2,asText = T)

xpathSApply(parsedHtml,"//title",xmlValue)
    #[1] "Jeff Leek - Google Scholar Citations"

#####################
###  USER/PASWDS  ###
#####################

pg1 = GET("http:/httpbin.org/basic-auth/user/passwd")
  # > pg1
  # Response [http://httpbin.org/basic-auth/user/passwd]
  # Date: 2016-11-13 22:10
  # Status: 401
  # Content-Type: <unknown>
  #   <EMPTY BODY>

pg2 = GET("http:/httpbin.org/basic-auth/user/passwd",
          authenticate("user","passwd"))
  
pg2  
  # Response [http://httpbin.org/basic-auth/user/passwd]
  # Date: 2016-11-13 22:11
  # Status: 200
  # Content-Type: application/json
  # Size: 47 B
  # {
  #   "authenticated": true, 
  #   "user": "user"

names(pg2)
  # [1] "url"         "status_code"
  # [3] "headers"     "all_headers"
  # [5] "cookies"     "content"    
  # [7] "date"        "times"      
  # [9] "request"     "handle"  

#############################
######  Using Handles  ######
#############################

google = handle("http://google.com")

pg1 = GET(handle=google,path="/")

pg2 = GET(handle=google,path="search")

#  Further Resources

#  http://www.r-bloggers.com/?s=Web+Scraping


####################################################
#############    Reading from APIs     #############
####################################################

#  API = Application Programming Interfaces

library(httr)

myapp = oauth_app("twitter",
                  key="yourComsumerKeyHere",secret = "yourConsumerSecret")

sig = sign_oauth1.0(myapp,
                    token = "yourTokenHere",
                    token_secret = "yourTokenSecretHere")

homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig)







































