#!/usr/bin/env ruby
require "ezmq"

WIFI_MAC = "a0:8d:16:ed:71:a1"
PORT = 7770
INTERVAL_LENGTH = 1
DISCONNECT_LENGTH = 60
last_connection = Time.now - DISCONNECT_LENGTH

if ENV["USER"] != "root" then
  puts "Needs to be run with sudo"
  exit 1
end
if `which arp-scan`.empty? then
  puts "Run 'sudo apt-get install arp-scan' first"
  exit 2
end

$publisher = EZMQ::Publisher.new port: PORT
def publish(message)
  puts "#{Time.now} - sending: #{message}"
  $publisher.send message, topic: 'watcher'
end

$state = 'left'
def set_state(to)
  puts "in: " + to
  return if $state == to
  $state = to
  publish($state)
end

puts "Starting..."
loop do
  devices = `arp-scan -l | grep #{WIFI_MAC}`
  last_connection = Time.now if !devices.empty?
  been_a_while = Time.now - last_connection > DISCONNECT_LENGTH
  set_state(been_a_while ? 'left' : 'arrived')
  sleep INTERVAL_LENGTH
end
