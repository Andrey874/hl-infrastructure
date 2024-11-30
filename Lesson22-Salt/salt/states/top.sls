base:
  '*':
    - salt-minion
    - firewall.general
  'lb*':
    - nginx-front
    - firewall.front
  'back*':
    - nginx-back
    - firewall.back
