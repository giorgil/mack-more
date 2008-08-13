module Mack
  module Distributed
    class Views
      
      include Singleton
      include DRbUndumped
      include Mack::ViewHelpers::LinkHelpers
      
      def get(resource)
        path = File.join(Mack.root, resource)
        if File.exists?(path)
          raw = File.read(path)
          
          # preprocess the raw content so we can resolve css/javascript/image path
          arr = raw.scan(/<%=.*?%>/)
          arr.each do |scriptlet|
            if scriptlet.match(/stylesheet/) or scriptlet.match(/javascript/) or scriptlet.match(/image/)
              res = ERB.new(scriptlet).result(binding)
              raw.gsub!(scriptlet, res)
            end
          end
          return raw
        end
        return ""
      end
      
      class << self
        def register
          if app_config.mack.share_views
            raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
            Mack.logger.info "Registering Mack::Distributed::Views for '#{app_config.mack.distributed_app_name}' with Rinda"
            
            Mack::Distributed::Utils::Rinda.register_or_renew(:space => app_config.mack.distributed_app_name.to_sym,
                                                              :klass_def => :distributed_views, 
                                                              :object => Mack::Distributed::Views.instance)
          end
        end
        
        def ref(app_name)          
          begin
            obj = Mack::Distributed::Utils::Rinda.read(:space => app_name.to_sym, 
                                                       :klass_def => :distributed_views)
            return obj
          rescue Rinda::RequestExpiredError => er
            Mack.logger.warn(er)
          end
          
          return nil
        end
      end
    end
  end
end