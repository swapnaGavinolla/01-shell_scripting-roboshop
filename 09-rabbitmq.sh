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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>> $logfile
validate $? "downloading repos by vendor"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $logfile
validate $? "downloading yum repos"

dnf install rabbitmq-server -y  &>> $logfile
validate $? "installing rabbitmq server"

systemctl enable rabbitmq-server  &>> $logfile
validate $? "enabling rabbitmq server"

systemctl start rabbitmq-server  &>> $logfile
validate $? "strating rabbitmq server"

rabbitmqctl add_user roboshop roboshop123  &>> $logfile
validate $? "setting password"