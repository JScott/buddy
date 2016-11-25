#!/usr/bin/ruby
Eye.config do
  logger '/var/log/buddy.eye.log'
end

Eye.application :buddy do
  working_dir File.expand_path(File.dirname(__FILE__))
  trigger :flapping, times: 10, within: 1.minute
  process :greeter do
    daemonize true
    pid_file '/run/buddy/greeter.pid'
    stdall '/var/log/greeter.log'
    start_command 'bin/greeter.rb'
  end
  process :watcher do
    daemonize true
    pid_file '/run/buddy/watcher.pid'
    stdall '/var/log/watcher.log'
    start_command 'sudo bin/watcher.rb'
  end
end
