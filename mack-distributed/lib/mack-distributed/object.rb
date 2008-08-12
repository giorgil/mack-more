module Mack # :nodoc:
  module Distributed # :nodoc:
    # Include this module into any class it will instantly register that class with
    # the mack_ring_server. The class will be registered with the name of the class
    # and the mack.distributed_app_name configured in your config/app_config/*.yml file.
    # If the mack.distributed_app_name configuration parameter is nil it will raise
    # an Mack::Distributed::Errors::ApplicationNameUndefined exception.
    # 
    # Example:
    #  class User
    #    include Mack::Distributed::Object
    #    def name
    #      "mark"
    #    end
    #  end
    # 
    #  Mack::Distributed::User.new.name # => "mark"
    module Object
      
      def self.included(base) # :nodoc:
        if app_config.mack.share_objects
          base.class_eval do
            include ::DRbUndumped
          end
          eval %{
            class ::Mack::Distributed::#{base}Proxy
              include Singleton
              include DRbUndumped

              def method_missing(sym, *args)
                #{base}.send(sym, *args)
              end
              
              def inspect
                #{base}.inspect
              end
              
              def to_s
                #{base}.to_s
              end
            
              # def respond_to?(sym)
              #   #{base}.respond_to?(sym)
              # end
            end
          }
          raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
          Mack::Distributed::Utils::Rinda.register_or_renew(:space => app_config.mack.distributed_app_name.to_sym, 
                                                            :klass_def => "#{base}".to_sym, 
                                                            :object => "Mack::Distributed::#{base}Proxy".constantize.instance)
        end
      end
      
    end # Object
  end # Distributed
end # Mack

module DRb # :nodoc:
  class DRbObject # :nodoc:

    alias_method :original_inspect, :inspect
    
    def inspect
      "#{original_inspect}|#{method_missing(:inspect)}"
    end
    
  end
end