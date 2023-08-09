#!/bin/bash
USER_ID=$(id -u)
COMPONENT=catalogue
LOGFILE="/tmp/${COMPONENT}.log"

if [ $USER_ID -ne 0 ] ; then
echo -e "\e[32m script is executed by the root user or with a sudo privilage \e[0m \n \t Example : sudo bash wrapper.sh ${COMPONENT}"
exit 1

fi
stat() {
if [ $1 -eq 0 ]; then
echo -e "\e[32m success \e[0m"
else 
  echo -e "\e[31m failure \e[0m"
  fi
}
echo -e "\e[34m configuring ${COMPONENT}.......! \e[0m"
echo -e  -n "configuring ${COMPONENT} repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
stat $?

echo -n "Installing ${COMPONENT} NodeJs :"
yum install  nodejs -y   &>> ${LOGFILE}
stat $? 

echo -n "Creating application user account :"
useradd roboshop
stat c$?









# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
# yum install nodejs -y
# useradd roboshop
#$ curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
#$ cd /home/roboshop
#$ unzip /tmp/catalogue.zip
#$ mv catalogue-main catalogue
#$ cd /home/roboshop/catalogue
#$ npm install
#$ vim systemd.servce
# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

#NOTE: You should see the log saying `connected to MongoDB`, then only your catalogue
#will work and can fetch the items from MongoDB

#Ref Log:
#{"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}