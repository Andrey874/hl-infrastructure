#!/bin/bash
echo "Content-type: text/html"
echo ""
echo "<HTML>"
echo "<BODY>"
echo "<FORM action="/cgi-bin/show_all.cgi" METHOD=GET>"
echo "<P>"
echo "<HR>"
echo "<H1><CENTER> Andrey C Inc. <BR>"
echo "SKYNET Cluster</H1></CENTER>"
echo "</P><HR>"
echo "<BR><BR>"
echo "Show all data from table:<BR>"
echo "<INPUT TYPE=Submit name="all" VALUE="Show_all">"
echo "<BR><BR><HR>"
echo "</FORM>"
echo "<FORM action="/cgi-bin/app_paste_data.cgi" METHOD=GET>"
echo "Paste data:<BR>"
echo "<TEXTAREA COLS="35" ROWS="4" placeholder='Enter some text' name="paste_data"></TEXTAREA>"
echo "<BR><BR>"
echo "<INPUT TYPE=Submit VALUE="Paste">"
echo "<INPUT TYPE=Reset VALUE="Clear">"
echo "</FORM>"
echo "<BR><HR>"
echo "<FORM action="/cgi-bin/select_one.cgi" METHOD=GET> <BR>"
echo "Enter transaction id to select:<BR>"
echo "<TEXTAREA COLS="15" ROWS="2" name="transaction_id"></TEXTAREA>"
echo "<BR><BR>"
echo "<INPUT TYPE=Submit VALUE="SelectID">"
echo "<INPUT TYPE=Reset VALUE="Clear">"
echo "</FORM>"
echo "</BODY>"
echo "</HTML>"
