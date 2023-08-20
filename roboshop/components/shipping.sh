#!/bin/bash
COMPONENT=shipping

# this is how we import the functions that are declared in a different file using source
source components/common.sh

JAVA         # calling java function

echo -e "\e[35m ${COMPONENT} Installation is Completed \e[0m \n"
