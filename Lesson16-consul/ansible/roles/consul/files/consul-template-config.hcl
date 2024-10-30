consul {
  address = "localhost:8500"

  retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}

template {
	source = "/etc/nginx/conf.d/loadbalancer.ctmpl"
	destination = "/etc/nginx/conf.d/loadbalancer.conf"
	perms = 0600
	command = "nginx -s reload"
}
