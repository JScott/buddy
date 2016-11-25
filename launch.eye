#!/usr/bin/ruby
Eye.config do
  logger '/var/log/buddy.eye.log'
end

Eye.application :buddy do
  working_dir File.expand_path(File.dirname(__FILE__))
  trigger :Flapping, times: 10, within: 1.minute
  process :watcher do
    daemonize true
    pid_file 'watcher.pid'
    stdall 'watcher.log'
    start_command 'bin/watcher.rb'
  end
end
