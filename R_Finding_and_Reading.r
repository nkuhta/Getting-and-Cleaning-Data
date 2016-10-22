##  Finding/Downloading and Reading/Parsing different file types
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

####################################################
#############    Reading XML Files     #############
####################################################

#  Extracting XML is the basis for most web scraping
#  Markup - labels that give the text structure
#  Content - The actual text of the document
#  Start Tags - <section>
#  End Tags - </section>
#  Empty Tags - <line-break />

#  Requires install.packages("XML")
library(XML)

if (!file.exists("data")){      #  if data directory does not exist
  dir.create("data")            #  create the data directory
}

dateDownloaded <- date()

#fileUrlXML <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xml?accessType=DOWNLOAD"

fileUrlXML <- "http://www.w3schools.com/xml/simple.xml"

#  Need to download file locally if xmlTreeParse doesn't work directly on a site behind a firewall
download.file(fileUrlXML,destfile = "./data/simple.xml")

doc <- xmlTreeParse(file = "./data/simple.xml",useInternalNodes = T)

#  xmlParse also works
#doc <- xmlParse(file = "./data/simple.xml")

#   xmlTreeParse may not work on the site directly (below) behind a firewall
#doc <- xmlTreeParse(fileUrlXML,isURL = T,useInternalNodes = T)

rootNode <- xmlRoot(doc)

xmlName(rootNode)
    #[1] "breakfast_menu"

names(rootNode)
    # food   food   food   food   food 
    # "food" "food" "food" "food" "food" 

rootNode[[1]]
  # <food>
  #   <name>Belgian Waffles</name>
  #   <price>$5.95</price>
  #   <description>Two of our famous Belgian Waffles with plenty of real maple syrup</description>
  #   <calories>650</calories>
  #   </food> 

rootNode[[1]][[1]]
  #<name>Belgian Waffles</name> 

#  Programatically extract parts of the xml file - Finding matching nodes 
xmlSApply(rootNode,xmlValue)
    # food 
    # "Belgian Waffles$5.95Two of our famous Belgian Waffles with plenty of real maple syrup650" 
    # food 
    # "Strawberry Belgian Waffles$7.95Light Belgian waffles covered with strawberries and whipped cream900" 
    # food 
    # "Berry-Berry Belgian Waffles$8.95Light Belgian waffles covered with an assortment of fresh berries and whipped cream900" 
    # food 
    # "French Toast$4.50Thick slices made from our homemade sourdough bread600" 
    # food 
    # "Homestyle Breakfast$6.95Two eggs, bacon or sausage, toast, and our ever-popular hash browns950" 


xpathSApply(rootNode,"//name",xmlValue)
    # [1] "Belgian Waffles"             "Strawberry Belgian Waffles" 
    # [3] "Berry-Berry Belgian Waffles" "French Toast"               
    # [5] "Homestyle Breakfast"    

xpathSApply(rootNode,"//price",xmlValue)
    #[1] "$5.95" "$7.95" "$8.95" "$4.50" "$6.95"


####################################################
############    Reading HTML Files     #############
####################################################

#  requires install.packages("XML")
library(XML)

fileUrlHTML <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"

download.file(fileUrlHTML,destfile = "./data/ravens.html")

docHTML <- htmlTreeParse(file = "./data/ravens.html",useInternalNodes = T)

#  htmlTreeParse doesn't work with work proxies - need to download html file
#docHTML <- htmlTreeParse(fileUrlHTML,useInternalNodes = T)

scores <- xpathSApply(docHTML,"//div[@class='score']",xmlValue)

teams <- xpathSApply(docHTML,"//div[@class='game-info']",xmlValue)

    # > scores 
    # [1] "13-7"  "25-20" "19-17" "28-27" "16-10" "27-23" "22-19"
    # [8] "19-18" "30-9"  "23-14"
    # > teams
    # [1] "vs  Bills"    "@  Browns"    "@  Jaguars"   "vs  Raiders" 
    # [5] "vs  Redskins" "@  Giants"    "@  Jets"      "vs  Steelers"
    # [9] "vs  Browns"   "@  Cowboys"   "vs  Bengals"  "vs  Dolphins"
    # [13] "@  Patriots"  "vs  Eagles"   "@  Steelers"  "@  Bengals"  
    # [17] "vs  Panthers" "@  Colts"     "vs  Lions"    "@  Saints"  

####################################################
############    Reading JSON Files     #############
####################################################

#  JSON = Java Script Object Notation

#  Requires install.packages("jsonlite")
library(jsonlite)

jsonLink <- "https://api.github.com/users/jtleek/repos"

download.file(jsonLink,destfile = "./data/simple_github.json")

jsonData <- fromJSON("./data/simple_github.json")

#  May not work behind a firewall
#jsonData <- fromJSON(jsonLink)

names(jsonData)
    # [1] "id"                "name"              "full_name"        
    # [4] "owner"             "private"           "html_url"         
    # [7] "description"       "fork"              "url"              
    # [10] "forks_url"         "keys_url"          "collaborators_url"
    # [13] "teams_url"         "hooks_url"         "issue_events_url" 
    # [16] "events_url"        "assignees_url"     "branches_url"     
    # [19] "tags_url"          "blobs_url"         "git_tags_url"     
    # [22] "git_refs_url"      "trees_url"         "statuses_url"     
    # [25] "languages_url"     "stargazers_url"    "contributors_url" 
    # [28] "subscribers_url"   "subscription_url"  "commits_url"      
    # [31] "git_commits_url"   "comments_url"      "issue_comment_url"
    # [34] "contents_url"      "compare_url"       "merges_url"       
    # [37] "archive_url"       "downloads_url"     "issues_url"       
    # [40] "pulls_url"         "milestones_url"    "notifications_url"
    # [43] "labels_url"        "releases_url"      "deployments_url"  
    # [46] "created_at"        "updated_at"        "pushed_at"        
    # [49] "git_url"           "ssh_url"           "clone_url"        
    # [52] "svn_url"           "homepage"          "size"             
    # [55] "stargazers_count"  "watchers_count"    "language"         
    # [58] "has_issues"        "has_downloads"     "has_wiki"         
    # [61] "has_pages"         "forks_count"       "mirror_url"       
    # [64] "open_issues_count" "forks"             "open_issues"      
    # [67] "watchers"          "default_branch"   


names(jsonData$owner)
    # [1] "login"               "id"                 
    # [3] "avatar_url"          "gravatar_id"        
    # [5] "url"                 "html_url"           
    # [7] "followers_url"       "following_url"      
    # [9] "gists_url"           "starred_url"        
    # [11] "subscriptions_url"   "organizations_url"  
    # [13] "repos_url"           "events_url"         
    # [15] "received_events_url" "type"               
    # [17] "site_admin"    

jsonData$owner$login
    # [1] "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek"
    # [7] "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek"
    # [13] "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek"
    # [19] "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek"
    # [25] "jtleek" "jtleek" "jtleek" "jtleek" "jtleek" "jtleek"


#  Writing data to JSON
myjson <- toJSON(iris,pretty=T)

#cat(myjson)

#  Writing JSON to dataframe
iris2 <- fromJSON(myjson)

head(iris2)
    # Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    # 1          5.1         3.5          1.4         0.2  setosa
    # 2          4.9         3.0          1.4         0.2  setosa
    # 3          4.7         3.2          1.3         0.2  setosa
    # 4          4.6         3.1          1.5         0.2  setosa
    # 5          5.0         3.6          1.4         0.2  setosa
    # 6          5.4         3.9          1.7         0.4  setosa







