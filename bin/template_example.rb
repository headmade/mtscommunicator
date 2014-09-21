#!/usr/bin/env ruby -Ilib -rmtscommunicator

MtsCommunicator::Service.configure do |config|
  config.login = ENV['MTSC_LOGIN']
  config.password = ENV['MTSC_PASSWORD']
end

I18n.load_path = Dir[File.dirname(__FILE__)+'/*.yml']
I18n.enforce_available_locales = false
I18n.backend.load_translations

class UserSms < MtsCommunicator::Base
  templates hello: 'Hello dear %name%, your account was activated on %today%',
            state: '%name%, your account is %state%, reason: %reason%'
end

UserSms.hello('7917xxxyyyy', {name: 'Alex', today: Time.now})
UserSms.state('7917yyyxxxx', {name: 'Ivan', state: :blocked, reason: 'spam detected'})

I18n.locale = :en
UserSms.hi('7917xxxyyyy', {name: 'user'})
I18n.locale = :fr
UserSms.hi('7917yyyxxxx', {name: 'user'})

