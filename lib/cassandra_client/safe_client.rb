
module Cassandra
  class SafeClient  
    def initialize(client, transport)
      @client = client 
      @transport = transport
    end
    
    def method_missing(*args)
      @client.send(*args)
    rescue IOError
      @transport.open
      raise if defined?(once)
      once = true
      retry
    end
  end
end
