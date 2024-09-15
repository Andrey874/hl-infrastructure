#!/bin/bash
#!/bin/bash
ssh-keygen -q -t rsa -N "" -f "/home/andrey/.ssh/id_rsa"
ssh-keyscan -t rsa postgres-srv1 >> /home/andrey/.ssh/known_hosts 2>/dev/null
ssh-keyscan -t rsa postgres-srv2 >> /home/andrey/.ssh/known_hosts 2>/dev/null
ssh-keyscan -t rsa postgres-srv3 >> /home/andrey/.ssh/known_hosts 2>/dev/null
ssh-keyscan -t rsa osearch1 >> /home/andrey/.ssh/known_hosts 2>/dev/null
ssh-keyscan -t rsa osearch2 >> /home/andrey/.ssh/known_hosts 2>/dev/null
ssh-keyscan -t rsa osearch3 >> /home/andrey/.ssh/known_hosts 2>/dev/null

sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub postgres-srv1
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub postgres-srv2
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub postgres-srv3
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub osearch1
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub osearch2
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub osearch3
