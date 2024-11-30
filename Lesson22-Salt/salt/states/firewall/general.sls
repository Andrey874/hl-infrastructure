make_sure_run_firewalld:
  service.running:
    - name: firewalld

open_ports_ssh_salt:
  firewalld.present:
    - name: public
    - ports:
      - 22/tcp
      - 4505/tcp
      - 4506/tcp 
    - require: 
      - service: make_sure_run_firewalld
