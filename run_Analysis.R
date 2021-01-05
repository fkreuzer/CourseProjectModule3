#this file performs the data preparation

library(readr)
library(stringr)

#define filepaths

filepath.test = "./UCI_HAR_Dataset/test/X_test.txt"
filepath.train = "./UCI_HAR_Dataset/train/X_train.txt"
filepath.testp = "./UCI_HAR_Dataset/test/X_test_p.txt"
filepath.trainp = "./UCI_HAR_Dataset/train/X_train_p.txt"

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

#read in the data

Xtest <- read.delim(new_filepaths[[1]],sep = " ", header = FALSE)
Xtrain <- read.delim(new_filepaths[[2]],sep = " ", header = FALSE)

Xtest <- Xtest[2:562]
Xtrain <- Xtrain[2:562]

#build the dataframe

Xtest <- Xtest[,indexfeatures]
Xtrain <- Xtrain[,indexfeatures]

names(Xtest) <- featurenames[indexfeatures,2]
names(Xtrain) <- featurenames[indexfeatures,2]
