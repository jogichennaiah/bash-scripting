#!/bin/bash
USER_ID=$(id -u)
COMPONENT=frontend
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
echo -n "installing  ${COMPONENT} :"
yum install nginx -y  &>> ${LOGFILE}
stat $?

echo -n "Starting nginx :"
systemctl enable nginx &>> ${LOGFILE}

systemctl start nginx  &>> ${LOGFILE}
stat $?

 echo -n "Downloading the ${COMPONENT} components :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"

stat $?

echo -n "clean up of ${COMPONENT} :"
cd /usr/share/nginx/html
rm -rf *   &>> ${LOGFILE}
stat $?

echo -n "extracting the ${COMPONENT} :"
unzip /tmp/${COMPONENT}.zip  &>> ${LOGFILE}
 mv ${COMPONENT}-main/* .
 mv static/* .
 rm -rf ${COMPONENT}-main README.md  &>> ${LOGFILE}
 mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "updating the Backend Component in the reverse proxy file :"
for component in catalogue user cart shipping payment ; do 
   sed -i -e "/${component}/s/localhost/${component}.roboshop.in/" /etc/nginx/default.d/roboshop.conf
done

echo -n "Restarting  ${COMPONENT} :"
systemctl daemon-reload  &>> ${LOGFILE}
systemctl restart nginx   &>> ${LOGFILE}
stat $?

echo -e "\e[35m ${COMPONENT} Installation is completed \e[0m \n"


