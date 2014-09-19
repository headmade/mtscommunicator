module MtsCommunicator
  class Service
    class << self
      attr_accessor :login
      attr_accessor :password
      attr_accessor :service_url

      attr_reader :last_err

      def send_message(*args)
        client.send_message(*args)
      end

      def send_messages(*args)
        client.send_messages(*args)
      end

      private
      def client
        Client.new(login, password, {service_url: service_url})
      end
    end
  end
end

