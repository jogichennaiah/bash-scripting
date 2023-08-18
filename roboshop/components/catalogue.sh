


#!/bin/bash


USER_ID=$(id -u)
COMPONENT=catalogue
LOGFILE="/tmp/${COMPONENT}.log"
APPUSER=roboshop


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
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -    &>> ${LOGFILE}
stat $?

echo -n "Installing Node Js :"
yum install nodejs -y &>> ${LOGFILE}
stat $? 


echo -n "Creating Application user account :"
useradd roboshop
stat $?
















# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -





# yum install nodejs -y
# useradd roboshop
# curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
 #cd /home/roboshop
 #unzip /tmp/catalogue.zip
 #mv catalogue-main catalogue
 #cd /home/roboshop/catalogue
 #npm install
# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

