#!/usr/bin/env ruby
require "ezmq"
require "mailgun-ruby"
require "yaml"

$MAIL = YAML.load_file File.join(__dir__, '../mail.yaml')
PORT = 7770
greeter = EZMQ::Subscriber.new port: PORT, topic: 'watcher'
greeting = {
  subject: 'Welcome home :D',
  text: "It's good to see you. Why don't you say hi to Jenn and then come chat with me? <CHATURL>"
}

$mailgun = Mailgun::Client.new $MAIL['mailgun']['secret_key']
$addresses = {
  from: "buddy@#{$MAIL['mailgun']['domain']}",
  to: $MAIL['recipient']
}
def send(email)
  puts "Sending '#{email[:subject]}'"
  domain = "mg.#{$MAIL['mailgun']['domain']}"
  $mailgun.send_message domain, $addresses.merge(email)
end

puts "Starting..."
puts $MAIL
greeter.listen do |message, topic|
  send greeting if message == 'arrived'
end
