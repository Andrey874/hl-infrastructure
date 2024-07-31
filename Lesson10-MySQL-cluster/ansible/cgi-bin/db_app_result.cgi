#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<HTML><PRE>"
echo "<PRE>"
echo "Results from a GET form"
echo "REQUEST_METHOD : $REQUEST_METHOD"
echo "QUERY_STRING : $QUERY_STRING"
data=`echo $QUERY_STRING | awk -F'=' '{print $2}' | sed -e 's/+/ /g'`
echo $data | ./app_db.sh
echo "</PRE></HTML>"
