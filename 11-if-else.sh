#!/bin/bash
echo "Demo on if usage"
ACTION=$1
if[ "$ACTION" == "start" ]; then
echo -e "\e [32m starting payment service \e [0m"
exit 0
fi