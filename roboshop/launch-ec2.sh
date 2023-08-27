#!/bin/bash

COMPONENT=$1

if [ -z $1 ]; then
   echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m \n \n \t"
   echo -e "\e[35m Ex Usage $  \n\t\t bash launch-ec2 shipping "
   exit 1
fi

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq ".Images[].ImageId" | sed -e 's/"//g')
#SG_ID="sg-0c848594407d0f2a8"
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b55-allow-all-chinna | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
INSTANCE_TYPE="t3.micro"
HOSTEDZONEID="Z00893932N2EBZOMI4T0O"


echo -e "***** Creating \e[35m ${COMPONENT} \e[32m Server Is In Progress ******
PRIVATEIP=$(aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE}  --security-group-ids ${SG_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

echo -e "Private Ip Address of the $COMPONENT is $PRIVATEIP\n\n"
echo -e "Creating DNS Record of ${COMPONENT} :"

sed -e"s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${IPADDRESS}/" route53.json > /tmp/route53.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file:///tmp/route53.json

echo -e "Private Ip Address of the $COMPONENT is created and ready to use on ${COMPONENT}.roboshop.in"



