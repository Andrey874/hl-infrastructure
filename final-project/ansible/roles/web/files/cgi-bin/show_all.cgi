#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<HTML><PRE>"
echo "<PRE>"
echo "Results from a GET form"
./show_all_pasts.sh -l
echo "</PRE></HTML>"
