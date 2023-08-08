#!/bin/bash
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ] ; then
echo -e "\e[32m script is executed by the root user or with a sudo privilage \e[0m \n \t Example : sudo bash wrapper.sh frontend"
exit 1

fi
stat() {
if [ $? -eq 0 ]; then
echo -e "\e[32m success \e[0m"
else 
  echo -e "\e[31m failure \e[0m"
  fi
}

echo -e "\e[34m configuring frontend.......! \e[0m"
echo -n "installing  frontend :"
yum install nginx -y  &>> /tmp/frontend.log
stat $?

echo -n "Starting nginx :"
systemctl enable nginx  &>> /tmp/frontend.log

systemctl start nginx   &>> /tmp/frontend.log
stat $?

 echo -n "Downloading the frontend components :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

stat $?

echo -n "clean up of frontend :"
cd /usr/share/nginx/html
rm -rf *    &>> /tmp/frontend.log
stat $?
echo -n "extracting the frontend :"
unzip /tmp/frontend.zip
stat $?

#validate the user who is running the script is a root user or not

# I want to ensure , that the SCRIPT SHOULD FAIL the user who run the script is not a root user
# rather executing the commands and failing
 

# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx

# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

# cd /usr/share/nginx/html
# rm -rf *
# 

# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
