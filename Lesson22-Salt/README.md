## Выполнение задания по занятию № 22 SALTSTACK
### Задание
добавить в проект salt server;  
добавить на конечные ноды миньоны солта;  
настроить управление конфигурацией nginx и iptables.  

Цель:
настроить управление конфигурацией проекта ( предыдущее ДЗ) через salt


### Описание выполнения
Стенд для выполнения задания состоит из 6 серверов: 
- lb1
- lb2
- back1
- back2

Конфигурация salt-master   
/etc/salt/master:
```commandline
interface: 0.0.0.0
publish_port: 4505
user: root
ret_port: 4506
pidfile: /var/run/salt-master.pid
root_dir: /
cachedir: /var/cache/salt/master
gather_job_timeout: 10
sock_dir: /var/run/salt/master
roster_file: /srv/salt/states/roster
file_roots:
  base:
    - /srv/salt/states
pillar_roots:
  base:
    - /srv/salt/pillar
```
### Управление ключами  
#### Вывести список ключей  
`salt-key`  
#### удалить все ключи  
`salt-key -D`  
#### что бы ключи появидись на мастере, необходимо установить миньоны  
`sudo salt-ssh '*' state.apply salt-minion`
#### Проверка связи  
`sudo salt-ssh '*' test.ping`  
#### принимаем все ключи
`sudo salt-key -A`
### Дерево проекта
`tree /srv/salt/`
```commandline
/srv/salt/
├── pillar
│   ├── core.sls
│   └── top.sls
└── states
    ├── firewall
    │   ├── back.sls
    │   ├── front.sls
    │   └── general.sls
    ├── nginx-back
    │   ├── init.sls
    │   └── nginx_conf_tmpl.jinja
    ├── nginx-front
    │   ├── init.sls
    │   └── nginx_balancer_conf.jinja
    ├── roster
    ├── salt-minion
    │   ├── init.sls
    │   └── minion
    └── top.sls
```
### Запуск проекта
`sudo salt '*' state.highstate`
