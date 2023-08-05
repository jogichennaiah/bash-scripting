#/bin/bash
hai (){
    echo "I am hai function"
    echo "I am here to tell you HAi"
    echo "I am completed"
}
stat(){
    echo "Number of sessions are opened $(who | wc -l)"
    echo "Today date is $(date +%F)"
    echo "Avg CPU utilization in last 5 minutes $(uptime | awk -F:'{print $NF}'| awk -F,'{print $2}')"
    hai

}
stat
