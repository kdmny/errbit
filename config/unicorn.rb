worker_processes 3
timeout 30

working_directory "/var/www/apps/errbit/current"

# listen "/tmp/web_server.sock", :backlog => 64
listen "127.0.0.1:8080", :tcp_nopush => true

pid '/tmp/web_server.pid'

stderr_path "/var/www/apps/errbit/shared/log/unicorn.stderr.log"
stdout_path "/var/www/apps/errbit/shared/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
	GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
	old_pid = '/tmp/web_server.pid.oldbin'
	if File.exists?(old_pid) && server.pid != old_pid
		begin
			Process.kill("QUIT", File.read(old_pid).to_i)
		rescue Errno::ENOENT, Errno::ESRCH
			# someone else did our job for us
		end
	end

	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.establish_connection
end