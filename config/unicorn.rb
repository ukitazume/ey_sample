# Set variables for usage in the before_exec block to help ensure deploys are succesful.
current_path = '/data/ey_sample/current'
shared_path = '/data/ey_sample/shared'
shared_bundler_gems_path = "/data/ey_sample/shared/bundled_gems"
working_directory '/data/ey_sample/current/'

# sets the current number of worker_processes to +nr+.  Each worker
# process will serve exactly one client at a time.  You can
# increment or decrement this value at runtime by sending SIGTTIN
# or SIGTTOU respectively to the master process without reloading
# the rest of your Unicorn configuration.  See the SIGNALS document
# for more information.
worker_processes 6

# Adds an +address+ to the existing listener set.  May be specified more
# than once.  +address+ may be an Integer port number for a TCP port, an
# "IP_ADDRESS:PORT" for TCP listeners or a pathname for UNIX domain sockets.
#
#   listen 3000 # listen to port 3000 on all TCP interfaces
#   listen "127.0.0.1:3000"  # listen to port 3000 on the loopback interface
#   listen "/tmp/.unicorn.sock" # listen on the given Unix domain socket
#   listen "[::1]:3000" # listen to port 3000 on the IPv6 loopback interface
listen '/var/run/engineyard/unicorn_ey_sample.sock', :backlog => 1024

# sets the timeout of worker processes to +seconds+.  Workers
# handling the request/app.call/response cycle taking longer than
# this time period will be forcibly killed (via SIGKILL).  This
# timeout is enforced by the master process itself and not subject
# to the scheduling limitations by the worker process.  Due the
# low-complexity, low-overhead implementation, timeouts of less
# than 3.0 seconds can be considered inaccurate and unsafe.
timeout 180

# sets the +path+ for the PID file of the unicorn master process
pid "/var/run/engineyard/unicorn_ey_sample.pid"

# The default Logger will log its output to the path specified
# by +stderr_path+.  If you're running Unicorn daemonized, then
# you must specify a path to prevent error messages from going
# to /dev/null.
logger Logger.new("log/unicorn.log")

# If you are daemonizing and using the default +logger+, it is important
# to specify this as errors will otherwise be lost to /dev/null.
# Some applications/libraries may also triggering warnings that go to
# stderr, and they will end up here.
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

# From: http://bogomips.org/unicorn.git/tree/lib/unicorn/configurator.rb#n426
# Enabling this preloads an application before forking worker
# processes.  This allows memory savings when using a
# copy-on-write-friendly GC but can cause bad things to happen when
# resources like sockets are opened at load time by the master
# process and shared by multiple children.  People enabling this are
# highly encouraged to look at the before_fork/after_fork hooks to
# properly close/reopen sockets.  Files opened for logging do not
# have to be reopened as (unbuffered-in-userspace) files opened with
# the File::APPEND flag are written to atomically on UNIX.
preload_app true

# Enable Copy on Write Garbage Collector - http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  # If Active Record is loaded: disconnect/close connections on the master process.
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :TERM : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
  sleep 1
end

# If Bundler is available; and unicorn is reloading ensure the PATH and 
# GEM_HOME and BUNDLE_GEMFILE are pointing to a correct path/filename.
if defined?(Bundler.settings)
  before_exec do |server|
    paths = (ENV["PATH"] || "").split(File::PATH_SEPARATOR) 
    paths.unshift "#{shared_bundler_gems_path}/bin"
    ENV["PATH"] = paths.uniq.join(File::PATH_SEPARATOR)

    ENV['GEM_HOME'] = ENV['GEM_PATH'] = shared_bundler_gems_path
    ENV['BUNDLE_GEMFILE'] = "#{current_path}/Gemfile"
  end
end

# This is how we write the PID files for each worker; so we can have monit know the real PID of each worker.
# Additionally if Active Record is loaded re-establish the connection on each worker.
after_fork do |server, worker|
  worker_pid = File.join(File.dirname(server.config[:pid]), "unicorn_worker_ey_sample_#{worker.nr}.pid")
  File.open(worker_pid, "w") { |f| f.puts Process.pid }
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
