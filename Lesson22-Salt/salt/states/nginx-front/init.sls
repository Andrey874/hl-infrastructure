install_nginx:
  pkg.installed:
    - name: nginx

make sure nginx is running:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: install_nginx
    - whatch:
      - file: cp nginx.conf

cp nginx.conf:
  file.managed:
    - name: /etc/nginx/conf.d/balance-rr.conf
    - source: salt://nginx-front/nginx_balancer_conf.jinja
    - template: jinja
    - show_changes: True


