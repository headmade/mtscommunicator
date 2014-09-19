#!/usr/bin/env ruby -Ilib -rmtscommunicator

require 'json'

MtsCommunicator::Service.login = ENV['MTSC_LOGIN']
MtsCommunicator::Service.password = ENV['MTSC_PASSWORD']

class UserSms < MtsCommunicator::Base
  templates hello: 'Hello dear %name%, your account was activated on %today%',
            state: '%name%, your account is %state%, reason: %reason%'
end

UserSms.hello('7917xxxyyyy', {name: 'Alex', today: Time.now})
UserSms.state('7917yyyxxxx', {name: 'Ivan', state: :blocked, reason: 'spam detected'})

