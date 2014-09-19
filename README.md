# Simple client for MTS Communicator service

* [MTS Communicator](https://www.mcommunicator.ru/)
* [MTSC API](http://www.mcommunicator.ru/M2M/)


## Installation

    $ gem install mtscommunicator

Or add to Gemfile

    gem 'mtscommunicator'


## Use as communication object

```ruby
client = MtsCommunicator::Client.new('login', 'password')
client.send_message('7917xxxxxxx', 'hello')
client.send_messages(['7917xxxxxxx', '7917xxxxxxy'], 'hello')
```

At the moment of writing,
MTS Communicator service unifies given recipients
(that is, each given recipient received a message only once, while can appear several times in the list of recipients).

## Use as service

### Initialization

```ruby
MtsCommunicator::Service.login='login'
MtsCommunicator::Service.password='password'
```

In Rails, this should be done in `config/initializers/mtscommunicator.rb` .


### Use in code

```ruby
MtsCommunicator::send_message('7917xxxxxxx', 'hello')
MtsCommunicator::send_messages(%w(7917xxxxxxx 7917xxxxxxy), 'hello')
```

## Note
As any web service, this commands can take unpredictable time,
so it is a good idea to run them asyncronously
(for example, with [delayed_job](https://github.com/collectiveidea/delayed_job) ).

## CLI
```
./bin/mtsc_send_messages.rb 7917xxxxxxx,7917xxxxxxy test login password
```

```
MTSC_LOGIN=login MTSC_PASSWORD=pass ./bin/mtsc_send_messages.rb 7917xxxxxxx,7917xxxxxxy test
```

The former way is simpler, the latter is more secure (as
authentication data is not shown on `ps` command).
