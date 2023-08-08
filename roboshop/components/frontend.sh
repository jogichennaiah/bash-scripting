#!/bin/bash
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ] ; then
echo -e "\e[32m script is executed by the root user or with a sudo privilage \e[0m \n \t Example : sudo bash wrapper.sh frontend"
exit 1
fi
echo -e "\e[34m configuring frontend.......! \e[0m"
yum install nginx -y  &>> /tmp/frontend.log

#validate the user who is running the script is a root user or not

# I want to ensure , that the SCRIPT SHOULD FAIL the user who run the script is not a root user
# rather executing the commands and failing
 

# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx

# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
