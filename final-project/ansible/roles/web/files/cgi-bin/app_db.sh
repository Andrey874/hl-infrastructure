#!/bin/bash
function sqlQuery() {
   psql postgres://postgres:postgres@127.0.0.1:5000/userdata -c "${1};"
}
dbuserid=$(psql -At postgres://postgres:postgres@127.0.0.1:5001/userdata -c "select userid from users where username='guru';")

if [ ! -t 0 ]; then
data=$(base64 -w 0 /dev/stdin)
echo -n "Data inserted as ID# "
sqlQuery "INSERT INTO pastedata (userid, addtime, data) 
          VALUES (${dbuserid}, NOW(), '${data}') RETURNING dataid;"
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
