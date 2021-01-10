#this file performs the data preparation

library(readr)
library(stringr)
library(dplyr)
library(tibble)

#define filepaths

filepath.test = "./UCI_HAR_Dataset/test/X_test.txt"
filepath.train = "./UCI_HAR_Dataset/train/X_train.txt"
filepath.testp = "./UCI_HAR_Dataset/test/X_test_p.txt"
filepath.trainp = "./UCI_HAR_Dataset/train/X_train_p.txt"

filepath.testy = "./UCI_HAR_Dataset/test/y_test.txt"
filepath.trainy = "./UCI_HAR_Dataset/train/y_train.txt"

filepath.subjecttest = "./UCI_HAR_Dataset/test/subject_test.txt"
filepath.subjecttrain = "./UCI_HAR_Dataset/train/subject_train.txt"


old_filepaths = c(filepath.test,filepath.train)
new_filepaths = c(filepath.testp,filepath.trainp)

#preprocess .txt files to remove additional white spaces
for (i in 1:2){
  
  if (file.exists(new_filepaths[[i]])) {
    #Delete file if it exists
    file.remove(new_filepaths[[i]])
  }
  
  txt <- read_file(old_filepaths[[i]])
  txt <- gsub(" +", " ", txt)
  
  file.create(new_filepaths[[i]])
  
  fileConn<-file(new_filepaths[[i]])
  write_lines(txt, fileConn)
  close(fileConn)
}


#extract only the mean and Std values for each measurements

indexfeatures <- c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,
                   240,241,253,254,266:271,345:350,424:429,503,504,529,530,
                   542,543)

#read in the features

featurenames <- read.delim("./UCI_HAR_Dataset/features.txt",
                       header = FALSE,sep = " ")

#read in the Xdata

Xtest <- read.delim(new_filepaths[[1]],sep = " ", header = FALSE)
Xtrain <- read.delim(new_filepaths[[2]],sep = " ", header = FALSE)

Xtest <- Xtest[2:562]
Xtrain <- Xtrain[2:562]

#read in the ydata

ytest <- read.delim(filepath.testy, sep = " ",header = FALSE)
ytrain <- read.delim(filepath.trainy, sep = " ",header = FALSE)

#change activity labels

ytrain[,1] <- gsub("1","walking",ytrain[[1]])
ytest[,1] <- gsub("1","walking",ytest[[1]])
ytrain[,1] <- gsub("2","walking upstairs",ytrain[[1]])
ytest[,1] <- gsub("2","walking upstairs",ytest[[1]])
ytrain[,1] <- gsub("3","walking downstairs",ytrain[[1]])
ytest[,1] <- gsub("3","walking downstairs",ytest[[1]])
ytrain[,1] <- gsub("4","sitting",ytrain[[1]])
ytest[,1] <- gsub("4","sitting",ytest[[1]])
ytrain[,1] <- gsub("5","standing",ytrain[[1]])
ytest[,1] <- gsub("5","standing",ytest[[1]])
ytrain[,1] <- gsub("6","laying",ytrain[[1]])
ytest[,1] <- gsub("6","laying",ytest[[1]])




#read in the subject data

subjecttest <- read.delim(filepath.subjecttest, sep = " ",header = FALSE)
subjecttrain <- read.delim(filepath.subjecttrain, sep = " ",header = FALSE)



#build the dataframe

Xtest <- Xtest[,indexfeatures]
Xtrain <- Xtrain[,indexfeatures]

names(Xtest) <- featurenames[indexfeatures,2]
names(Xtrain) <- featurenames[indexfeatures,2]

#transform to tibbles

Xtest <- as_tibble(Xtest)
Xtrain <- as_tibble(Xtrain)

#add features and results
Xtest <- add_column(Xtest, y = ytest[[1]], .before = "tBodyAcc-mean()-X")
Xtrain <- add_column(Xtrain, y = ytrain[[1]], .before = "tBodyAcc-mean()-X")
Xtest <- add_column(Xtest, subject = subjecttest[[1]],
                    .before = "tBodyAcc-mean()-X")
Xtrain <- add_column(Xtrain, subject = subjecttrain[[1]],
                    .before = "tBodyAcc-mean()-X")

#clean up label names

newnames <- gsub("-mean\\(\\)", " Mean", names(Xtrain))
newnames <- gsub("-std\\(\\)", " Standard Deviation", newnames)
newnames <- gsub("-", " ", newnames)

names(Xtrain) <- newnames
names(Xtest) <- newnames

#combine the two datasets

alldata <- rbind(Xtrain,Xtest)

#create additional dataset

#activities = c("walking","walking upstairs","walking downstairs","sitting",
#               "standing","lying")

meandata <- alldata %>% group_by(y,subject) %>% summarize_all(mean)



write.table(meandata,"./meandata.txt",row.name=FALSE)
