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

dnf install python36 gcc python3-devel -y  &>> $logfile
validate $? "installing python"

useradd roboshop &>> $logfile
validate $? "creating roboshop user"

mkdir /app  &>> $logfile
validate $? "creating app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $logfile
validate $? "downloading zip files"

cd /app  &>> $logfile
validate $? "going into app directory"

unzip /tmp/payment.zip &>> $logfile
validate $? "unzipping payment zip files"

cd /app  &>> $logfile
validate $? "going into app directory"

pip3.6 install -r requirements.txt &>> $logfile
validate $? "installing dependencies"

cp $code_dir/payment.service /etc/systemd/system/payment.service &>> $logfile
validate $? "copying payment service file"

systemctl daemon-reload &>> $logfile
validate $? "daemon reloading"

systemctl enable payment &>> $logfile
validate $? "enabling payment"

systemctl start payment &>> $logfile
validate $? "starting payment"

