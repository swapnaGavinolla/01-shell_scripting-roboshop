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

dnf install maven -y &>> $logfile
validate $? "installing maven"


# useradd roboshop  &>> $logfile
# validate $? "creating roboshop user"

# mkdir /app  &>> $logfile
# validate $? "creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip  &>> $logfile
validate $? "downloading shipping zip files"

cd /app  &>> $logfile
validate $? "going into app directory"

unzip /tmp/shipping.zip  &>> $logfile
validate $? "unzipping shipping zip files"

cd /app  &>> $logfile
validate $? "going into app directory"

mvn clean package  &>> $logfile
validate $? "downloading dependencies"

mv target/shipping-1.0.jar shipping.jar  &>> $logfile
validate $? "moving into shipping jar file"

cp $code_dir/shipping.service  /etc/systemd/system/shipping.service  &>> $logfile
validate $? "copying shipping service"

 
systemctl daemon-reload  &>> $logfile
validate $? "daemon reloading"


systemctl enable shipping   &>> $logfile
validate $? "enabling shipping"


systemctl start shipping  &>> $logfile
validate $? "starting shipping"


dnf install mysql -y  &>> $logfile
validate $? "installing mysql"


mysql -h mysql.sureshvadde.online -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>> $logfile
validate $? "loading schema"

systemctl restart shipping  &>> $logfile
validate $? "restarting shipping"