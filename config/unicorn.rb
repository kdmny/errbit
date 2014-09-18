worker_processes 3
timeout 30

working_directory "/var/www/apps/errbit/current"

# listen "/tmp/web_server.sock", :backlog => 64
listen "127.0.0.1:8080", :tcp_nopush => true

pid '/tmp/web_server.pid'

stderr_path "/var/www/apps/errbit/shared/log/unicorn.stderr.log"
stdout_path "/var/www/apps/errbit/shared/log/unicorn.stdout.log"

check_client_connection false
