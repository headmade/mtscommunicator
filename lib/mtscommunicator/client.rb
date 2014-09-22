module MtsCommunicator
  class Client

    attr_accessor :config
    attr_accessor :digest_password

    attr_reader :last_err

    def initialize(config)
      self.config = config.is_a?(Configuration) ? config : Configuration.new(config)

      self.digest_password = Digest::MD5.hexdigest(config.password)
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
      # so could not rely on any query generation engine and
      # had to use custom encode_params() to build http query string
      url = '%s/%s?%s' % [
        config.service_url,
        cmd,
        encode_params({
          login: config.login,
          password: self.digest_password
        }.merge(params))
      ]
      #puts url; return # for test
      parse_response(open(url).read())
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
      @last_err = nil
      ::Crack::XML.parse(resp)
    end

  end
end

