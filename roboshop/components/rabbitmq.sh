#!/bin/bash
set -e 

COMPONENT=rabbitmq

source components/common.sh

echo -e "\e[34m configuring ${COMPONENT}.......! \e[0m \n"

echo -n "Configuring ${COMPONENT} repositories :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash   &>> ${LOGFILE}

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash   &>> ${LOGFILE}

echo -n "Installing ${COMPONENT} :"
yum install rabbitmq-server -y  &>> ${LOGFILE}
stat $? 


echo -n "Starting the ${COMPONENT} :"
systemctl enable rabbitmq-server  &>> ${LOGFILE}
systemctl start rabbitmq-server   &>> ${LOGFILE}
stat $?

sudo rabbitmqctl list_users | grep roboshop

if [ $? -ne 0 ] ; then
echo -n "Creating ${COMPONENT} user account :"
rabbitmqctl add_user roboshop roboshop123    &>> ${LOGFILE}
stat $?
fi

echo -n "Configuring the permission :"
 rabbitmqctl set_user_tags roboshop administrator      &>> ${LOGFILE}
 rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>> ${LOGFILE}
stat $?

echo -e "\e[35m ${COMPONENT} Installation is completed \e[0m \n"
