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
      - file: cp site.conf

cp site.conf:
  file.managed:
    - name: /etc/nginx/conf.d/site.conf
    - source: salt://nginx-back/nginx_conf_tmpl.jinja
    - template: jinja
    - show_changes: True


