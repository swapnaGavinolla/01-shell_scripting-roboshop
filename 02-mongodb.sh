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

cp $code_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>> $logfile
validate $? "copying mongo repo"

dnf install mongodb-org -y &>> $logfile
validate $? "installing mongodb"

systemctl enable mongod &>> $logfile
validate $? "enabling mongod"

systemctl start mongod &>> $logfile
validate $? "starting mongod"

sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $logfile
validate $? "updating mongod listening address"

systemctl restart mongod &>> $logfile
validate $? "restating mongod"