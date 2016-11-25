#!/usr/bin/env ruby
require "ezmq"

PORT = 7770

worker = EZMQ::Subscriber.new port: PORT, topic: 'watcher'
worker.listen do |message, topic|
  puts topic, message
end
