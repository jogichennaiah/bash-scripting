#!/bin/bash

COMPONENT=$1
ENV=$2
HOSTEDZONEID="Z00893932N2EBZOMI4T0O"
INSTANCE_TYPE="t3.micro"

if [ -z $1 ] || [ -Z $2 ] ; then
   echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m \n \n \t"
   echo -e "\e[35m Ex Usage $  \n\t\t bash launch-ec2 shipping "
   exit 1
fi

create_ec2(){
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq ".Images[].ImageId" | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b55-allow-all-chinna | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')




echo -e " ***** Creating \e[35m ${COMPONENT} \e[32m Server Is In Progress ****** "
PRIVATEIP=$(aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE}  --security-group-ids ${SG_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}-${ENV}}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

echo -e "Private Ip Address of the $COMPONENT-${ENV} is $PRIVATEIP\n\n"
echo -e "Creating DNS Record of ${COMPONENT} :"

sed -e "s/COMPONENT/${COMPONENT}-${ENV}/"  -e "s/IPADDRESS/${PRIVATEIP}/" route53.json  > /tmp/r53.json 

aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file:///tmp/r53.json
echo -e "\e[36m ***** Creating DNS Record for the $COMPONENT has completed ***** \e[0m \n\n"

}

if [ "$1" == "all" ]; then 

    for component in mongodb catalogue cart user shipping frontend payment mysql redis rabbitmg; do 
        COMPONENT=$component 
        create_ec2
    done 

else 
        create_ec2 
fi 