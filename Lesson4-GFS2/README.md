### Выполнение задания по занятию № 4 ISCSI, multipath и кластерные файловые системы: GFS2
## Задание

- виртуалка с iscsi
- 3 виртуальные машины с разделяемой файловой системой GFS2 поверх cLVM
- должен быть настроен fencing для VirtualBox

Задание выполнялось на ОС Almalinux 9.4 для нод и Almalinux 9.2 для iscsi-target в среде виртуализации VirtualBox v.7.0.
Для развертывания стенда применялся vagrant v.2.4.1. 

Ссылка на [vagrant box ОС Almalinux9.4(v9.4.20240509)](https://app.vagrantup.com/almalinux/boxes/9/versions/9.4.20240509/providers/virtualbox/amd64/vagrant.box)  
Ссылка на [vagrant box ОС Almalinux9.2(v9.2.20230513)](https://app.vagrantup.com/almalinux/boxes/9/versions/9.2.20230513/providers/virtualbox/unknown/vagrant.box)  
Для импортирования образов в список доступных boxes используются команды

```
vagrant box add almalinux/9.4 package.box
vagrant box add almalinux/9.2 package.box
```
После чего имена образов ОС almalinux/9.4 и almalinux/9.2 можно применять в Vagrantfile.

Для запуска стенда требуется применить команду   
```vagrant up```  
Когда процесс выполнения данной команды завершится, будет готово 4 виртуальных машины: 
- iscsi-target 
- node1 
- node2 
- node3

Установка ПО, настройка сервисов и конфигурационных файлов осуществляется с сервера iscsi-target средствами ПО ansible.  
Для этого следует подключится к серверу iscsi-target при помощи команды  
`vagrant ssh iscsi-target`  
подключиться под пользователем ansible  
`sudo su - ansible`  
Команды ansible следует выполнять из директории /home/ansible/ansible  
В файле /home/ansible/ansible/roles/vars/main.yml описаны переменные, которые необоходимо  
переопределить для настрйки фенсинга(ограждения):  
**ip_host_os** - ip адрес хоста на котором установлен virtualbox(ip адрес хостовой машины)  
**username_host_os** - login для подключения к хосту на котором установлен virtualbox  
**passwd_username_host_os** - пароль от указанного логина  
**type_host_os** - тип хоста на котором установлен virtualbox, по умолчанию linux. Если хостовой ОС  
является windows то при запуске ansible-playbook необходимо переопределить данную переменную  
с помощью ключа -e type_host_os=windows. 

После проверки переменных можно запускать ансибл роль, которая прозиведет все настройки  
`ansible-playbook roles/tasks/main.yml`  
или, если хостовая ОС windows  
`ansible-playbook -e type_host_os=windows roles/tasks/main.yml`  
После заявершения выполнения плейбука можно перейти на любую из нод и проверить состояние кластера  
`sudo pcs status --full`  
Посмотреть настройки stonith, fencing(ограждение):  
`sudo pcs stonith config`








