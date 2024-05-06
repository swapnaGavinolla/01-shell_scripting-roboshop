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

dnf install mysql-community-server -y &>> $logfile
validate $? "installing"

systemctl enable mysqld &>> $logfile
validate $? "enabling"

systemctl start mysqld &>> $logfile
validate $? "starting"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $logfile
validate $? "setting password"
