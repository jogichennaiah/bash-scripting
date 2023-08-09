#!/bin/bash
USER_ID=$(id -u)
COMPONENT=$frontend
LOGFILE="/tmp/${COMPONENT}.log"

if [ $USER_ID -ne 0 ] ; then
echo -e "\e[32m script is executed by the root user or with a sudo privilage \e[0m \n \t Example : sudo bash wrapper.sh ${COMPONENT}"
exit 1

fi
stat() {
if [ $? -eq 0 ]; then
echo -e "\e[32m success \e[0m"
else 
  echo -e "\e[31m failure \e[0m"
  fi
}

echo -e "\e[34m configuring ${COMPONENT}.......! \e[0m"
echo -n "installing  ${COMPONENT} :"
yum install nginx -y  ${LOGFILE}
stat $?

echo -n "Starting nginx :"
systemctl enable nginx  ${LOGFILE}

systemctl start nginx   ${LOGFILE}
stat $?

 echo -n "Downloading the ${COMPONENT} components :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"

stat $?

echo -n "clean up of ${COMPONENT} :"
cd /usr/share/nginx/html
rm -rf *    ${LOGFILE}
stat $?

echo -n "extracting the ${COMPONENT} :"
unzip /tmp/frontend.zip ${LOGFILE}
stat $?
 
echo -n "sorting the ${COMPONENT} files :"
 mv ${COMPONENT}-main/* .
 mv static/* .
 rm -rf ${COMPONENT}-main README.md  &>> ${LOGFILE}
 mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Restarting  ${COMPONENT} :"
systemctl daemon-reload  &>> ${LOGFILE}
systemctl restart nginx   &>> ${LOGFILE}
stat $?


