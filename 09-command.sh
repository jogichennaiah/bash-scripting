#/bin/bash
stat(){
    echo "Number of sessions are opened $(who | wc -l)"
    echo "Today date is $(date +%F)"

}
stat