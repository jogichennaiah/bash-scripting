#!/bin/bash


USER_ID=$(id -u)
COMPONENT=mongodb
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
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
stat $?

echo -n "Installing ${COMPONENT} :"
yum install -y mongodb-org  &>> ${LOGFILE}
stat $? 

echo -n "Enabling the ${COMPONENT} visibility:"
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
stat $?
 
echo -n "Starting the ${COMPONENT} :"
systemctl enable mongod    &>> ${LOGFILE}
systemctl start mongod
systemctl restart mongod
stat $?

echo -n "Downloading the ${COMPONENT} schema :"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?
 
 echo -n "Extracting the ${COMPONENT} schema :"
 cd /tmp
 unzip -o ${COMPONENT}.zip   &>> ${LOGFILE}
 stat $?
  
echo -n "Injecting the ${COMPONENT} schema :"
cd ${COMPONENT}-main
mongo < catalogue.js  &>> ${LOGFILE}
mongo < users.js      &>> ${LOGFILE} 
stat $?

echo -e "\e[32m ${COMPONENT} installation is completed \e[0m \n" 
 

