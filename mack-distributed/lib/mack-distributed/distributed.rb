module Mack # :nodoc:
  module Distributed # :nodoc:
    
    # Looks up and tries to find the missing constant using the ring server.
    def self.const_missing(const)
      Mack::Distributed::Utils::Rinda.read(:klass_def => "#{const}".to_sym)
    end
    
    # Allows for the specific lookup of services on the ring server
    # 
    # Examples:
    #   Mack::Distributed::Utils::Rinda.register_or_renew(:space => :app_1, :klass_def => :Test, :object => "Hello World!")
    #   Mack::Distributed::Utils::Rinda.register_or_renew(:space => :app_2, :klass_def => :Test, :object => "Hello WORLD!")
    #   Mack::Distributed.lookup("distributed://app_1/Test") # => "Hello World!"
    #   Mack::Distributed.lookup("distributed://app_2/Test") # => "Hello WORLD!"
    def self.lookup(address)
      uri = Addressable::URI.parse(address)
      path = uri.path[1..uri.path.size] # remove the first slash
      host = uri.host
      Mack::Distributed::Utils::Rinda.read(:klass_def => path.to_sym, :space => host.to_sym)
    end
    
  end # Distributed
end # Mack