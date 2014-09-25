module MtsCommunicator
  class Client

    attr_accessor :config
    attr_accessor :digest_password

    attr_reader :last_err

    def initialize(config)
      self.config = config.is_a?(Configuration) ? config : Configuration.new(config)

      self.digest_password = Digest::MD5.hexdigest(self.config.password)
    end

    def send_message(to_id, message)
      raise 'invalid to_id' unless to_id.is_a?(String)
      raise 'invalid message' unless message.is_a?(String)
      res = command(:send_message, {msid: to_id, message: message, naming: ''})
      res = res.body
      {
        to_id: to_id,
        stored_id: res && res[:send_message_response] && res[:send_message_response][:send_message_result],
      }
    end

    def send_messages(to_ids, message)
      raise 'invalid message' unless message.is_a?(String)
      raise 'invalid to_ids' unless to_ids.is_a?(Array)
      #return 'NO_MSID' unless to_ids.any?

      # TODO: wtf it does not work :-?
      #command(:send_messages, {msids: to_ids.uniq, message: message, naming: ''})

      to_ids.uniq.map do |to_id|
        send_message(to_id, message)
      end
    end

    private

    def client
      @client ||= Savon.client(wsdl: [config.service_url,'?wsdl'].join)
    end

    def command(cmd, params = {})
      client.call(cmd, message: auth_params.merge(params))
    end

    def auth_params
      @auth_params ||= {login: config.login, password: self.digest_password}
    end

  end
end

