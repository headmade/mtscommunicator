module MtsCommunicator
  class Base
    class << self

      def templates(t=nil)
        @templates = t if t.is_a?(Hash)
        raise 'no template set' unless @templates.is_a?(Hash)
        @templates
      end

      private

      def send_template(to_ids, template, vars={})
        message = templates[template]
        raise "unknown template (#{template.to_s})" unless message

        to_ids = [to_ids] if to_ids.is_a?(String)
        vars.keys.each do |k|
          message.gsub!("%#{k}%", vars[k].to_s)
        end
        MtsCommunicator::Service.send_messages(to_ids, message)
      end

      def method_missing(meth, *args, &block)
        if templates[meth]
          send_template(args.shift, meth, *args)
        else
          super
        end
      end

    end
  end
end

