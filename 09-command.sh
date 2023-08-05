#/bin/bash
stat(){
    echo "Number of sessions are opened $(who | wc -l)"
    echo "Today date is $(date +%F)"

}
stat
sleep 1
stat
sleep 2
stat
sleep 3
stat