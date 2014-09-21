# Simple client for MTS Communicator service

* [MTS Communicator](https://www.mcommunicator.ru/)
* [MTSC API](http://www.mcommunicator.ru/M2M/)


## Installation

    $ gem install mtscommunicator

Or add to Gemfile

    gem 'mtscommunicator'


## Use as communication object

```ruby
client = MtsCommunicator::Client.new(login: 'login', password: 'password')
client.send_message('7917xxxxxxx', 'hello')
client.send_messages(['7917xxxxxxx', '7917xxxxxxy'], 'hello')
```

At the moment of writing,
MTS Communicator service unifies given recipients
(that is, each given recipient receives a message only once, even if he  several times appeared in the list of recipients).

## Use as service

### Initialization

```ruby
MtsCommunicator::Service.configure do |config|
  config.login = 'login'
  config.password = 'password'
end
```

In Rails, this should be done in `config/initializers/mtscommunicator.rb`.
Also one could prefer to use `config/secrets.yml` to store auth credentials.


### Use in code

```ruby
MtsCommunicator::send_message('7917xxxxxxx', 'hello')
MtsCommunicator::send_messages(%w(7917xxxxxxx 7917xxxxxxy), 'hello')
```

## Note
As any web service, this commands can take unpredictable time,
so it is a good idea to run them asyncronously
(for example, with [delayed_job](https://github.com/collectiveidea/delayed_job) ).

# Template support

```ruby
class UserSms < MtsCommunicator::Base
  templates hello: 'Hello dear %name%, your account was activated on %today%',
            state: '%name%, your account is %state%, reason: %reason%'
end
```

```ruby
UserSms.hello('7917xxxyyyy', {name: 'Alex', today: Time.now})
```
```ruby
UserSms.state(['7917yyyxxxx','7917xxxyyyy'] , {name: 'Dear user', state: :blocked, reason: 'spam detected'})
```

# I18n templates

Let locale file has:
```
en:
  user_sms:
    hi: 'Hi %name%, how are you?'

fr:
  user_sms:
    hi: 'Salut %name%, comment ca va?'
```

Usage:

```ruby
class UserSms < MtsCommunicator::Base; end

I18n.locale = :en
UserSms.hi('7917xxxyyyy', {name: 'user'})
# => sends message: 'Hi user, how are you?'

I18n.locale = :fr
UserSms.hi('7917yyyxxxx', {name: 'user'})
# => sends message: 'Salut user, comment ca va?'
```


Pay attention, that if you're running vanilla ruby (without Rails),
you have to initialize i18n yourselves:

```ruby
I18n.load_path = Dir[File.dirname(__FILE__)+'/locale/*.yml']
I18n.enforce_available_locales = false
I18n.backend.load_translations
```


## CLI
```
./bin/mtsc_send_messages.rb 7917xxxxxxx,7917xxxxxxy test login password
```

```
MTSC_LOGIN=login MTSC_PASSWORD=pass ./bin/mtsc_send_messages.rb 7917xxxxxxx,7917xxxxxxy test
```

The former way is simpler, the latter one is more secure (as
authentication data is not shown on `ps` command).

See additional examples in bin/\*rb

# Forks & pull requests

Lots of official MTS Comminucator API functions are not implemented yet. So...

You're welcome!

## Contributing

1. Fork it
2. Create your feature branch (```git checkout -b my-new-feature```).
3. Commit your changes (```git commit -am 'Added some feature'```)
4. Push to the branch (```git push origin my-new-feature```)
5. Create new Pull Request
