ACTION=$1
case $ACTION in
start)
echo "starting payment service"
;;
stop)
echo "stoping payment service"
;;
restart)
echo "restarting payment service"
;;
*)
echo "valid optins are start or stop or restart "
echo -e "example usage : \n \t bash scriptName stop"
;;
esac