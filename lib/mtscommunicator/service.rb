module MtsCommunicator
  class Service
    class << self
      attr_writer :configuration

      attr_reader :last_err

      def send_message(*args)
        client.send_message(*args)
      end

      def send_messages(*args)
        client.send_messages(*args)
      end

      def configure
        yield(configuration)
      end

      def reconfigure
        @configuration = Configuration.new
        yield(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
      end

      private
      def client
        Client.new(configuration)
      end
    end
  end
end

