module MtsCommunicator
  class Configuration
    attr_accessor :login
    attr_accessor :password
    attr_accessor :service_url

    def self.service_url_default
      'http://www.mcommunicator.ru/m2m/m2m_api.asmx'
    end

    def initialize(options={})
      self.login = options[:login]
      self.password = options[:password]
      self.service_url = options[:service_url]
    end

    def service_url
      @service_url || self.class.service_url_default
    end

  end
end

