#!/bin/bash


COMPONENT=mysql
source components/common.sh

echo -e "\e[34m configuring ${COMPONENT}.......! \e[0m"

echo -n "Configuring ${COMPONENT} repo :"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Installing ${COMPONENT} :"
yum install mysql-community-server -y   &>>  ${LOGFILE}
stat $?

