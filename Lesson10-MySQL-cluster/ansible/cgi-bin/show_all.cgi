#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<HTML><PRE>"
echo "<PRE>"
echo "Results from a GET form"
./app_db_selects.sh -l
echo "</PRE></HTML>"
