Gem::Specification.new do |s|
  s.name        = 'mtscommunicator'
  s.version     = '0.0.1'
  s.date        = '2014-09-16'
  s.summary     = 'Simple client for "MTS communicator" service'
  s.description = 'A client to interact with http://mcommunicator.ru (send messages only)'
  s.authors     = ['Headmade LLC']
  s.email       = 'info@headmade.pro'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'http://rubygems.org/gems/mtscommunicator'
  s.license       = 'MIT'

  s.add_runtime_dependency 'curb'
  s.add_runtime_dependency 'crack'
  s.add_runtime_dependency 'digest'
  s.add_runtime_dependency 'i18n'
end

