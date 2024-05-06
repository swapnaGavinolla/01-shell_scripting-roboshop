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
fi
}

dnf module disable nodejs -y $logfile
dnf module enable nodejs:18 -y $logfile
validate $? "creating app directory"

dnf install nodejs -y &>> $logfile
validate $? " installing nodejs" 

useradd roboshop &>> $logfile
validate $? "adding roboshop user" 

mkdir /app &>> $logfile
validate $? "creating app directory" 

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $logfile
validate $? "downloading cart zip files" 

cd /app &>> $logfile
validate $? "going into app directory" 

unzip /tmp/cart.zip &>> $logfile
validate $? "unzipping cart zip files" 

cd /app &>> $logfile
validate $? "going app directory" 

npm install  &>> $logfile
validate $? "installing dependencies" 

cp $code_dir/cart.service /etc/systemd/system/cart.service &>> $logfile
validate $? "copying cart service file" 

systemctl daemon-reload &>> $logfile
validate $? "daemon reloading" 

systemctl enable cart &>> $logfile
validate $? "enabling cart" 


systemctl start cart &>> $logfile
validate $? "starting cart" 



