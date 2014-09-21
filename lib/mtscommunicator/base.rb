module MtsCommunicator
  class Base
    class << self

      def templates(hash)
        @templates = hash
      end

      def method_missing(meth, *args, &block)
        name = meth.to_s
        template, template_name = get_template(meth), meth
        template, template_name = get_template(name), name unless template
        # TODO: check for possible problems with RTL templates
        if template && !template.end_with?('.'+name)
          send_template(template_name, *args)
        else
          super
        end
      end

      private

      def get_template(name)
        return @templates[name] if @templates && name.is_a?(Symbol)
        return I18n.t([i18n_key,name].join('.')) if name.is_a?(String)
        nil
      end

      def send_template(name, to_ids, vars={})
        message = get_template(name)
        raise "unknown template (#{name.to_s})" unless message

        to_ids = [to_ids] if to_ids.is_a?(String)
        vars.keys.each do |k|
          message.gsub!("%#{k}%", vars[k].to_s)
        end
        MtsCommunicator::Service.send_messages(to_ids, message)
      end

      def i18n_key
        @i18n_key ||=
        begin
          key = self.name
          key[0].tr!('A-Z','a-z')
          key.gsub!(/([a-z\d])([A-Z])([a-z\d])/) { |s| [$1,'_',$2.downcase,$3].join}
          key.downcase
        end
      end

    end
  end
end

