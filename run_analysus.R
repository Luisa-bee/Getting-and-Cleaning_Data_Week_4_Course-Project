#Getting and Cleaning Data Week 4: Course-Project
#loading the necessary packages
library(data.table)
library(dplyr)

#Reading all files
Featest <- read.table("./datosr/test/X_test.txt", header = FALSE)
Featrain<- read.table("./datosr/train/X_train.txt", header = FALSE)
Actest <- read.table("./datosr/test/Y_test.txt", header = FALSE)
Actrain <- read.table("./datosr/train/Y_train.txt", header = FALSE)
Subtest <- read.table("./datosr/test/subject_test.txt", header = FALSE)
Subtrain <- read.table("./datosr/train/subject_train.txt", header = FALSE)
Actlabels <- read.table("./datosr/activity_labels.txt", header = FALSE)
Featnames <- read.table("./datosr/features.txt", header = FALSE)

#Merging the previous dataframes to make new dataframes
FeatData <- rbind(Featest, Featrain)
ActData <- rbind(Actest, Actrain)
SubData <- rbind(Subtest, Subtrain)

#Renaming colums 
names(ActData) <- "ActN"
Activity <- left_join(ActData, Actlabels, "ActN")[, 2]
names(Actlabels) <- c("ActN", "Activity")
names(SubData) <- "Subject"
names(FeatData) <- Featnames$V2

#Create a NData with the variables: SubjectData,  Activity,  FeaturesData}
#If someone know how to do this in one line of code please tell me jeje 
NData <- cbind(SubData, Activity)
NData <- cbind(NData, FeatData)

#Extract measurements of mean and standard deviation 
subFeatnames <- Featnames$V2[grep("mean\\(\\)|std\\(\\)", Featnames$V2)]
DataNames <- c("Subject", "Activity", as.character(subFeatnames))
NData <- subset(NData, select=DataNames)

#Independent tidy data set 
SecondNData<-aggregate(. ~Subject + Activity, NData, mean)
SecondNData<-SecondNData[order(SecondNData$Subject,SecondNData$Activity),]

#Save this tidy NData to local file
write.table(SecondNData, file = "tidydata2.txt",row.name=FALSE)