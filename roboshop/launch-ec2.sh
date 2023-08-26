#!/bin/bash

COMPONENT=$1

if [ -z $1 ]; then
   echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m \n \n \t"
   echo -e "\e[35m Ex Usage $  \n\t\t bash launch-ec2 shipping "
   exit 1
fi

AMI_ID="ami-0c1d144c8fdd8d690"
INSTANCE_TYPE="t3.micro"
SG_ID="sg-0c848594407d0f2a8"
aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE}  --security-group-ids ${SG_ID} --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]' 
