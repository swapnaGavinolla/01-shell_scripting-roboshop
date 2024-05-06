#!/bin/bash

#implementing colors
R="\e[31m" 
G="\e[32m" 
N="\e[0m"

code_dir=$(pwd) #path
id=$(id -u)
logfile=/tmp/roboshop.log

#checking for root

if [ $id -ne 0 ]
then 
    echo "take root access and proceed" 
    exit 1
fi
#validating function

validate() {
if [ $1 == 0 ]
then 
    echo -e "$2 is...$G success $N"
else
   echo -e "$2 is...$R failure $N"
   exit 1
fi
}

dnf module disable nodejs -y &>> $logfile
dnf module enable nodejs:18 -y &>> $logfile
validate $? "enabling" 

dnf install nodejs -y   &>> $logfile
validate $? "installing" 

useradd roboshop &>> $logfile
validate $? "adding roboshop user" 

mkdir /app &>> $logfile
validate $? "creating app directory" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $logfile
validate $? "downloading catalogue zip files" 

cd /app &>> $logfile
validate $? "going into app directory" 

unzip /tmp/catalogue.zip &>> $logfile
validate $? "unzipping catalogue zip files" 

cd /app &>> $logfile
validate $? "going app directory" 

npm install  &>> $logfile
validate $? "installing dependencies" 

cp $code_dir/catalogue.service /etc/systemd/system/catalogue.service &>> $logfile
validate $? "copying catalogue service file" 

systemctl daemon-reload &>> $logfile
validate $? "daemon reloading" 

systemctl enable catalogue &>> $logfile
validate $? "enabling catalogue" 


systemctl start catalogue &>> $logfile
validate $? "starting catalogue" 

cp $code_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>> $logfile
validate $? "copying mongo repo file" 

dnf install mongodb-org-shell -y &>> $logfile
validate $? "installing mongo client" 

mongo --host mongodb.sureshvadde.online </app/schema/catalogue.js &>> $logfile
validate $? "loading schema" 

systemctl restart catalogue  &>> $logfile
validate $? "restarting catalogue" 