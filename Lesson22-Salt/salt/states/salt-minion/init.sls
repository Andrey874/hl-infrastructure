salt-minion:
  pkgrepo.managed:
    - name: saltstack
    - humanname: SaltStack Latest Release for $releasever
    - baseurl: https://packages.broadcom.com/artifactory/saltproject-rpm/
    - gpgkey: https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public
    - gpgcheck: 1
    - enabled: True

  pkg.installed:
    - require:
      - pkgrepo: saltstack

  service.running:
    - enable: True
    - require:
      - pkg: salt-minion
    - watch:
      - file: /etc/salt/minion

/etc/salt/minion:
  file:
  - source: salt://salt-minion/minion
  - managed
  - user: root
  - group: root
  - mode: 644
  - template: jinja

    
