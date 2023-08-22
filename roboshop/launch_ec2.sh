#!/bin/bash 

COMPONENT=$1 
ENV=$2
HOSTEDZONEID="Z00893932N2EBZOMI4T0O"
INSTANCE_TYPE="t3.micro"
 
if [ -z $1 ] || [ -z $2 ]  ; then 
    echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m \n \t \t"
    echo -e "\e[35m Ex Usage \e[0m \n\t\t $ bash launch-ec2.sh shipping"
    exit 1
fi 

# AMI_ID="ami-0c1d144c8fdd8d690"
AMI_ID="$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7"| jq ".Images[].ImageId" | sed -e 's/"//g')" 
SG_ID="$(aws ec2 describe-security-groups  --filters Name=group-name,Values=b55-allow-all-chinna | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')"       # b54-allow-all security group id

