require 'bunny'
require 'json'

conn = Bunny.new(:automatically_recover => false)
conn.start

ch   = conn.create_channel
q    = ch.queue("reddit.mprefresh")

id = ARGV.shift || 0
payload = {id: id}

ch.default_exchange.publish(JSON.dump(payload), :routing_key => q.name)
puts " [x] Sent '#{payload}'!"

conn.close
