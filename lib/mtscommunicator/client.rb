module MtsCommunicator
  class Client

    attr_accessor :login
    attr_accessor :password
    attr_accessor :service_url

    attr_reader :last_err

    def self.service_url_default
      'http://www.mcommunicator.ru/m2m/m2m_api.asmx'
    end

    def initialize(login, password, options = {})
      self.login = login
      self.password = Digest::MD5.hexdigest(password)

      self.service_url = options[:service_url]
    end

    def service_url
      @service_url || self.class.service_url_default
    end


    def send_message(to_id, message)
      raise 'invalid to_id' unless to_id.is_a?(String)
      raise 'invalid message' unless message.is_a?(String)
      command(:SendMessage, {msid: to_id, message: message, naming: ''})
    end

    def send_messages(to_ids, message)
      raise 'invalid message' unless message.is_a?(String)
      raise 'invalid to_ids' unless to_ids.is_a?(Array)

      command(:SendMessages, {msids: to_ids, message: message, naming: ''})
    end

    private

    def command(cmd, params = {})
      # MTS Communicator service uses a special (XML-like?) way to pass list arguments
      # (for example, msid = [1,2,3] should become 'msid=1&msid=2&msid=3')
      # so had to use custom encode_params() to build http query string
      url = '%s/%s?%s' % [
        service_url,
        cmd,
        encode_params(params.merge(login: @login, password: @password))
      ]
      parse_response(Curl.get(url).body_str)
    end

    def encode_params(params={})
      res = []
      params.keys.map do |k|
        v = params[k]
        if v.is_a?(Array)
          res += v.map{ |s| encode_pair(k,s) }
        else
          res << encode_pair(k,v)
        end
      end
      res.join('&')
    end

    def encode_pair(k,v)
      [URI::encode(k.to_s),URI::encode(v.to_s)].join('=')
    end

    def parse_response(resp)
      if resp.is_a?(String)
        if resp[0] != '<'
          @last_err = resp.chomp
          return nil
        end
      else
        @last_err = 'INVALID_RESPONSE'
        return nil
      end
      ::Crack::XML.parse(resp)
    end

  end
end

