setwd("test")
testdata<-read.table("X_test.txt")
testl<-read.table("y_test.txt")
tests<-read.table("subject_test.txt")

setwd("../")
setwd("train")
traindata<-read.table("X_train.txt")
trainl<-read.table("y_train.txt")
trains<-read.table("subject_train.txt")


setwd("../")
names<-read.table("features.txt")

data<-rbind(traindata,testdata)

names(data)<-names[,2]


datas<-rbind(trains,tests)
datal<-rbind(trainl,testl)

datas$subject<-as.character(datas[,1])
datas$subject<-as.factor(datas[,2])

datal$activity<-as.character(datal[,1])
datal$activity<-as.factor(datal[,2])

datal[,2]<-gsub("1","WALKING",datal[,2])
datal[,2]<-gsub("2","WALKING_UPSTAIRS",datal[,2])
datal[,2]<-gsub("3","WALKING_DOWNSTAIRS",datal[,2])
datal[,2]<-gsub("4","SITTING",datal[,2])
datal[,2]<-gsub("5","STANDING",datal[,2])
datal[,2]<-gsub("6","LAY",datal[,2])


datal$activity<-as.factor(datal[,2])

datall<-cbind(data,datas[,2],datal[,2])

names(datall)[562]<-"subject"
names(datall)[563]<-"activity"

names<-names(datall)

mindex<-grep("mean()",names)
mnames<-names[mindex]

sindex<-grep("std()",names)
snames<-names[sindex]

meandata<-datall[,mnames]
stddata<-datall[,snames]

fdata<-cbind(meandata,stddata,datall$subject,datall$activity)
names(fdata)[80]<-"subject"
names(fdata)[81]<-"activity"



fdata$subject<-as.character(fdata$subject)
fdata$subject<-as.numeric(fdata$subject)



fdata$activity<-as.character(fdata$activity)

index<-order(fdata$subject,fdata$activity)
fdata<-fdata[index,]

#########################umeri##############
fdata$activity<-as.factor(fdata$activity)



names(fdata)<-gsub("-","",names(fdata))
names(fdata)<-gsub("\\()","",names(fdata))

s<-split(fdata,list(fdata$subject,fdata$activity))

snames<-names(fdata)
snames<-snames[1:79]

ff<-sapply(s,function(x) colSums(x[,snames])/dim(x)[1])

write.table(ff,file="datasetok.txt")
