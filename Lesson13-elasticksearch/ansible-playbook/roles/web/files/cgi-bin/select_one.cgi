#!/bin/bash
echo "Content-type: text/html"
echo ""
echo "<HTML><PRE>"
echo "<PRE>"
echo "Results from a GET form"
echo "REQUEST_METHOD : $REQUEST_METHOD"
echo "QUERY_STRING : $QUERY_STRING"
tid=`echo $QUERY_STRING | awk -F'=' '{print $2}'`
. db_select.sh -p  $tid
echo "</PRE></HTML>"
