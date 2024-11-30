
open_ports_80:
  firewalld.present:
    - name: public
    - ports:
      - 80/tcp
