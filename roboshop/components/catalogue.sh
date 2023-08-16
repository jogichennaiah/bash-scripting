#!/bin/bash/
USER_ID=$(id -u)
COMPONENT=catalogue
LOGFILE=/tmp/${COMPONENT}.log
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
yum install nodejs -y  &>> ${LOGFILE}
stat $?

id ${APPUSER}  &>> ${LOGFILE}

if [ $? -ne 0 ] ; then
echo -n "Creating Application user account :"
useradd ${APPUSER}
stat $?
fi

echo -n "Downloading the ${COMPONENT} :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "Copying the ${COMPONENT} to ${APPUSER} home directory :"
cd /home/${APPUSER}/
rm -rf ${COMPONENT}    &>> ${LOGFILE}
unzip -o /tmp/${COMPONENT}.zip    &>> ${LOGFILE}
stat $?

echo -n "Changing the ownership :"
mv ${COMPONENT}-main ${COMPONNT}
chown -R ${APPUSER}:${APPUSER} /home/${APPUSER}/${COMPONENT}/
stat $?