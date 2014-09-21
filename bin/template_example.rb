#!/usr/bin/env ruby -Ilib -rmtscommunicator

MtsCommunicator::Service.configure do |config|
  config.login = ENV['MTSC_LOGIN']
  config.password = ENV['MTSC_PASSWORD']
end

# Load I18n locale templates
I18n.load_path = Dir[File.dirname(__FILE__)+'/template_example.yml']
I18n.enforce_available_locales = false

# Initialize I18n (need if not under Rails)
I18n.backend.load_translations

class UserSms < MtsCommunicator::Base
  templates hello: 'Hello dear %name%, your account was activated on %today%',
            state: '%name%, your account is %state%, reason: %reason%'
end

def display_result(res)
  puts res.inspect
end

display_result( UserSms.hello('7917xxxyyyy', {name: 'Alex', today: Time.now}) )
display_result( UserSms.state('7917yyyxxxx', {name: 'Ivan', state: :blocked, reason: 'spam detected'}) )

I18n.locale = :en
display_result( UserSms.hi('7917xxxyyyy', {name: 'user'}) )
I18n.locale = :fr
display_result( UserSms.hi('7917yyyxxxx', {name: 'user'}) )

