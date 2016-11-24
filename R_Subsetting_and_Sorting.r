##  Organizing, Merging, and Managing Data
##  Refer to Coursera Getting and Cleaning Data course from John Hopkins

####################################################
##########    Subsetting and Sorting     ###########
####################################################

set.seed(13435)

#  3 sample variable within different ranges
x <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
    # > x
    #   var1 var2 var3
    # 1    2    8   15
    # 2    3    7   12
    # 3    5    6   14
    # 4    1   10   11
    # 5    4    9   13

#  rearrange row order through sampling and make var2 elements 1 and 3 NA
x <- x[sample(1:5),];x$var2[c(1,3)]=NA
  
    # > x
    #   var1 var2 var3
    # 1    2   NA   15
    # 4    1   10   11
    # 2    3   NA   12
    # 3    5    6   14
    # 5    4    9   13

#  x first column
x[,1]
    # [1] 2 3 5 1 4

#  x var1 column
x[,"var1"]
    # [1] 2 3 5 1 4

#  x var2 column
x[1:2,"var2"]
    # [1] NA 10

####################################################
############    Logical AND and OR     #############
####################################################

#  Rows where x var1 less than or equal to 3 "AND" x var3 greater than 11

x[(x$var1<=3 & x$var3 >11),]
    #   var1 var2 var3
    # 1    2   NA   15
    # 2    3   NA   12

#  Rows where x_var1 is less than or equal to 3 "OR" x_var3 is greater than 15

x[(x$var1<=3 | x$var3 >15),]
    #   var1 var2 var3
    # 1    2   NA   15
    # 4    1   10   11
    # 2    3   NA   12

#  Dealing with missing values - using the which() command 

x[which(x$var2>8),]
    #   var1 var2 var3
    # 4    1   10   11
    # 5    4    9   13

####################################################
##################    Sorting     ##################
####################################################

#  sort in increasing (default) numerical order
sort(x$var1)
    # [1] 1 2 3 4 5

#  sort in decreasing numerical order
sort(x$var1,decreasing = T)
    # [1] 5 4 3 2 1

#  sort x_var2 with NAs at the end
sort(x$var2,na.last = T)
    # [1]  6  9 10 NA NA


####################################################
#################    Ordering     ##################
####################################################

#  Order data frame rows by a variable

x[order(x$var1),]
    #   var1 var2 var3
    # 4    1   10   11
    # 1    2   NA   15
    # 2    3   NA   12
    # 5    4    9   13
    # 3    5    6   14

#  Order data frame rows for multiple variables (first by var1, then var3 if there are var1 duplicates)
x[order(x$var1,x$var3),]
    #   var1 var2 var3
    # 4    1   10   11
    # 1    2   NA   15
    # 2    3   NA   12
    # 5    4    9   13
    # 3    5    6   14

####################################################
###########    Ordering with plyr     ##############
####################################################

library(plyr)

arrange(x,var1)
    #   var1 var2 var3
    # 1    1   10   11
    # 2    2   NA   15
    # 3    3   NA   12
    # 4    4    9   13
    # 5    5    6   14

arrange(x,desc(var1))
    #   var1 var2 var3
    # 1    5    6   14
    # 2    4    9   13
    # 3    3   NA   12
    # 4    2   NA   15
    # 5    1   10   11

####################################################
#########    Adding Rows and Columns     ###########
####################################################

#  Add a var4 column with rnorm
x$var4 <- rnorm(5)

x
    #   var1 var2 var3       var4
    # 1    2   NA   15  0.1875960
    # 4    1   10   11  1.7869764
    # 2    3   NA   12  0.4966936
    # 3    5    6   14  0.0631830
    # 5    4    9   13 -0.5361329

#  add a column with cbind
y <- cbind(x,rnorm(5))

y
    #   var1 var2 var3       var4    rnorm(5)
    # 1    2   NA   15  0.1875960  0.62578490
    # 4    1   10   11  1.7869764 -2.45083750
    # 2    3   NA   12  0.4966936  0.08909424
    # 3    5    6   14  0.0631830  0.47838570
    # 5    4    9   13 -0.5361329  1.00053336
















