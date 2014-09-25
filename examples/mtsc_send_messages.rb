#!/usr/bin/env ruby -Ilib -rmtscommunicator

require 'json'

mtsc_client = MtsCommunicator::Client.new(
  login: ENV['MTSC_LOGIN'] || ARGV[2],
  password: ENV['MTSC_PASSWORD'] || ARGV[3]
)

res = mtsc_client.send_messages(ARGV[0].split(','), ARGV[1])

puts( res.to_json )

