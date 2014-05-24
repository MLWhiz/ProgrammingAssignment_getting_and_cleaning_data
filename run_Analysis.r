##Set Workspace to the UCIHARDATASET
setwd("C:/Users/Rahul Agarwal/Desktop/UBUNTU/Data/Learning/Signature Track -Data Science/3. Assignments/UCI HAR Dataset")
library(data.table)
##Merging the dataset
sub_test<-read.table('test/subject_test.txt')
sub_train<-read.table('train/subject_train.txt')
x_test<-read.table('test/x_test.txt')
x_train<-read.table('train/x_train.txt')
y_test<-read.table('test/y_test.txt')
y_train<-read.table('train/y_train.txt')
subject<-rbind(sub_test,sub_train)
x<-rbind(x_test,x_train)
y<-rbind(y_test,y_train)
colnames(y)<-"y"
colnames(subject)<-"subject"
merged_data<-cbind(x,y,subject)
##Finding out which columns are needed
features<-read.table("features.txt")
filtered_features<-features[grepl("mean|std|Mean|Std",features$V2),]
indexes_req<-filtered_features$V1
indexes_name<-filtered_features$V2
##Filtering the data set according to required params
filt_merged_data<-cbind(merged_data[indexes_req],merged_data[c("y","subject")])
indexes_name<-c(as.vector(indexes_name),"y","subject")
colnames(filt_merged_data)<-indexes_name
##Loading the activity labels
activity<-read.table("activity_labels.txt")
colnames(activity)<-c('y','activity')
data_with_labels<-merge(x=filt_merged_data,y=activity,by="y",all.x=TRUE)
##As y has been mapped to activity labels remove y
data_with_labels$y=NULL
result<-aggregate(subset(data_with_labels, select = -c(activity, subject)), 
      list(activity = data_with_labels$activity, subject = data_with_labels$subject), 
      mean)
write.table(result, "result1.txt")
