#!/bin/bash


USER_ID=$(id -u)
COMPONENT=redis
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
echo -e  -n "configuring ${COMPONENT} repo :"   &>> ${LOGFILE}
curl -L https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/${COMPONENT}.repo -o /etc/yum.repos.d/${COMPONENT}.repo  &>> ${LOGFILE}
stat $?

echo -n "Installing ${COMPONENT} :"
yum install redis-6.2.12 -y  &>> ${LOGFILE}
stat $? 

echo -n "Enabling the ${COMPONENT} visibility:"
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/${COMPONENT}.conf
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/${COMPONENT}/${COMPONENT}.conf

stat $?
 
echo -n "Starting the ${COMPONENT} :"
systemctl daemon-reload      &>> ${LOGFILE}
systemctl enable ${COMPONENT}       &>> ${LOGFILE}
systemctl restart ${COMPONENT}     &>> ${LOGFILE}
stat $?

echo -e "\e[35m ${COMPONENT} installation is completed \e[0m \n" 
 

