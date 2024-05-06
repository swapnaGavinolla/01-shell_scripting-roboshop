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


dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>> $logfile
validate $? "installing redis rpms"

dnf module enable redis:remi-6.2 -y &>> $logfile
validate $? "enabling redis remi"

dnf install redis -y  &>> $logfile
validate $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $logfile
validate $? "editing redis listening address"

systemctl enable redis &>> $logfile
validate $? "enabling redis"

systemctl start redis &>> $logfile
validate $? "starting redis"