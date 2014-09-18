worker_processes 3
timeout 30

working_directory "/var/www/apps/errbit/current"

listen "0.0.0.0:8080", :backlog => 64

pid '/var/www/apps/errbit/shared/pids/unicorn.pid'

stderr_path "/var/www/apps/errbit/shared/log/unicorn.stderr.log"
stdout_path "/var/www/apps/errbit/shared/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
	GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
	old_pid = '/var/www/apps/errbit/shared/pids/unicorn.pid.oldbin'
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