#!/usr/bin/env ruby -Ilib -rmtscommunicator

require 'json'

MtsCommunicator::Service.login = ENV['MTSC_LOGIN'] || ARGV[2]
MtsCommunicator::Service.password = ENV['MTSC_PASSWORD'] || ARGV[3]

res = MtsCommunicator::Service.send_messages(ARGV[0].split(','), ARGV[1])
err = MtsCommunicator::Service.last_err

puts( {res: res, err: err}.to_json )

exit 1 unless err.nil?
