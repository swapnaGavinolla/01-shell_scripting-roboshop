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

dnf install nginx -y &>> $logfile
validate $? installation

systemctl enable nginx &>> $logfile
validate $? enabling

systemctl start nginx &>> $logfile
validate $? starting

rm -rf /usr/share/nginx/html/* &>> $logfile
validate $? "removing default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $logfile
validate $? "downloading code"

cd /usr/share/nginx/html &>> $logfile

unzip /tmp/web.zip &>> $logfile
validate $? unzipping

cp $code_dir/roboshop.conf  /etc/nginx/default.d/roboshop.conf &>> $logfile
validate $? "copying roboshop.conf"

systemctl restart nginx &>> $logfile
validate $? "restarting nginx"