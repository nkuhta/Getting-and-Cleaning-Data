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

#ucscDB <- dbConnect(MySQL(),user="genome",host="genome-mysql.cse.ucsc.edu")

#result <- dbGetQuery(ucscDB,"show databases;")

#  Always Disconnect
#dbDisconnect(ucscDB)

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

created=h5createGroup("example.h5","foo")
created=h5createGroup("example.h5","baa")
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

attr(B,"scale") <- "liter"

h5write(B,"example.h5","foo/foobaa/B")

h5ls("example.h5")
    # group   name       otype  dclass       dim
    # 0           /    baa   H5I_GROUP                  
    # 1           /    foo   H5I_GROUP                  
    # 2        /foo      A H5I_DATASET INTEGER     5 x 2
    # 3        /foo foobaa   H5I_GROUP                  
    # 4 /foo/foobaa      B H5I_DATASET   FLOAT 5 x 2 x 2











