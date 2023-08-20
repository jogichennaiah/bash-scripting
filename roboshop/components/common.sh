# All the common function will declared here . Rest of the components will be sourcing the function from this file



LOGFILE="/tmp/${COMPONENT}.log"
APPUSER=roboshop

USER_ID=$(id -u)

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

#Function to create a useraccount
CREATE_USER() {
id ${APPUSER}  &>> ${LOGFILE}
if [ $? -ne 0 ] ; then
   echo -n "Creating Application user account :"
  useradd roboshop  
stat $?
fi

}

DOWNLOAD_AND_EXTRACT() {
  echo -n "Downloading the ${COMPONENT} :"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
  stat $?

cd /home/${APPUSER}/
rm -rf ${COMPONENT}  &>> ${LOGFILE}
echo -n "Unzip the ${COMPONENT} :"
unzip -o /tmp/${COMPONENT}.zip    &>> ${LOGFILE}
stat $?

echo -n "Changing the ownership :"
mv ${COMPONENT}-main ${COMPONENT}
chown -R ${APPUSER}:${APPUSER} /home/${APPUSER}/${COMPONENT}/
stat $?

}

CONFIG_SVC() {
echo -n "Configuring the ${COMPONENT} system file :"
sed -i -e 's/CARTENDPOINT/cart.roboshop.in/' -e 's/DBHOST/mysql.roboshop.in/'  -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.in/' -e 's/MONGO_DNSNAME/mongodb.roboshop.in/' -e 's/REDIS_ENDPOINT/redis.roboshop.in/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.in/' /home/${APPUSER}/${COMPONENT}/systemd.service
mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Starting the ${COMPONENT} service :"
systemctl daemon-reload &>> ${LOGFILE}
systemctl enable ${COMPONENT} &>> ${LOGFILE}
systemctl restart ${COMPONENT} &>> ${LOGFILE}
stat $?



}


#Declaring the NoDEJS function
NODEJS() {
    echo -e "\e[34m configuring ${COMPONENT}.......! \e[0m \n"

echo -e  -n "configuring ${COMPONENT} repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -    &>> ${LOGFILE}
stat $?

echo -n "Installing Node Js :"
yum install nodejs -y &>> ${LOGFILE}
stat $? 

CREATE_USER    #calls CREATE_USER function that creates user account
DOWNLOAD_AND_EXTRACT # Download and extract the component

echo -n "Generating the ${COMPONENT} artifacts :"
cd /home/${APPUSER}/${COMPONENT}/
npm install    &>> ${LOGFILE}
stat $?
CONFIG_SVC

}

MVN_PACKAGE() {
echo -n "Generating the ${COMPONENT} artifacts :"
cd /home/${APPUSER}/${COMPONENT}/
mvn clean package   &>> ${LOGFILE}
mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
stat $?
}




JAVA() {
 echo -e "\e[34m configuring ${COMPONENT}.......! \e[0m \n"
 echo -n "Installing moven :"
 yum install maven -y  &>> ${LOGFILE}
 stat $?

 CREATE_USER             #Calls the CREATE_USER function that crates user account
 DOWNLOAD_AND_EXTRACT    # Downloads and extracts the components
 
 MVN_PACKAGE
 CONFIG_SVC
}

PYTHON() {
echo -e "\e[34m configuring ${COMPONENT}.......! \e[0m \n"

echo -n "Installing Python :"
yum install python36 gcc python3-devel -y  &>> ${LOGFILE}
stat $?

 CREATE_USER             #Calls the CREATE_USER function that crates user account
 DOWNLOAD_AND_EXTRACT    # Downloads and extracts the components

 pip3 install -r requirements.txt  &>> ${LOGFILE}
 stat $?
}