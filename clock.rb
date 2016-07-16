require 'clockwork'
require "bunny"

module Clockwork

  conn = Bunny.new(:automatically_recover => false)
  conn.start

  @ch   = conn.create_channel
  @q    = @ch.queue("reddit.mprefresh")

  handler do |job|
    @ch.default_exchange.publish("{}", :routing_key => job)
  end

  every(10.minutes, 'reddit.mprefresh')

  # handler receives the time when job is prepared to run in the 2nd argument
  # handler do |job, time|
  #   puts "Running #{job}, at #{time}"
  # end

  # every(10.seconds, 'frequent.job')
  # every(3.minutes, 'less.frequent.job')
  # every(1.hour, 'hourly.job')

  # every(1.day, 'midnight.job', :at => '00:00')
end