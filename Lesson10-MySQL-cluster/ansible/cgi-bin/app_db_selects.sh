#!/bin/bash
function sqlQuery() {
 echo "${1}" | mysql -u sbuser -p'Pa$$w0rd' -h 127.0.0.1 -P 6033 -Bs userdata 
}
dbuserid=$(sqlQuery "select userid from user where username='guru';")

if [ -t 0 ]; then
data=$(base64 -w 0 /dev/stdin)
echo -n "Data inserted as ID# "
sqlQuery "INSERT INTO pastedata (userid, addtime, data) VALUES (${dbuserid}, NOW(), '${data}'); SELECT LAST_INSERT_ID();"
else
 while getopts "ld:p:" opt; do
   case "$opt" in
    d)
     sqlQuery "DELETE FROM pastedata WHERE dataid='${OPTARG}' AND userid='${dbuserid}';"
     ;;
    l)
     sqlQuery "SELECT addtime,dataid FROM pastedata WHERE userid='${dbuserid}';"
     ;;
    p)
     sqlQuery "SELECT data FROM pastedata WHERE dataid='${OPTARG}' AND userid='${dbuserid}';" | base64 -id
     ;;
   esac
 done
fi
