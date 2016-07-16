ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/config/environment"
require "bunny"

conn = Bunny.new(:automatically_recover => false)
conn.start

@ch   = conn.create_channel
@q    = @ch.queue("reddit.mprefresh")
@ch.prefetch(1)


def refresh_mp(id) 
  account = Account.find(id)
  if(account && account.provider == "reddit")
      puts " [x] Refreshing #{account.login}"
      sleep(2)
    account.has_notif = (rand > 0.8)
      puts " [✔] Got a mail!" if account.has_notif
    account.touch
    account.save!
    puts " [+] Saved"
  end
end

def refresh_all
  Account.where(provider: "reddit").each do |acc|
    payload = {id: acc.id}
    @ch.default_exchange.publish(JSON.dump(payload), :routing_key => @q.name)
    puts " [#] Added '#{payload}' to queue!"
  end
end


begin
  puts " [*] Waiting for messages. To exit press CTRL+C"
  @q.subscribe(:block => true) do |delivery_info, properties, body|
  	id = JSON.parse(body)["id"]
    if(id.to_i > 0)
    	refresh_mp(id)
    else
      refresh_all
    end
  end
rescue Interrupt => _
  conn.close

  exit(0)
end

