
require 'rubygems'
require 'thrift'

class ThriftClient  
  DEFAULTS = { 
    :protocol => Thrift::BinaryProtocol,
    :transport => Thrift::FramedTransport,
    :socket_timeout => 1, 
    :randomize_server_list => true,
    :exception_classes => [
      IOError, 
      Thrift::Exception, 
      Thrift::ProtocolException, 
      Thrift::ApplicationException, 
      Thrift::TransportException]
  }
  
  attr_reader :client, :client_class, :server_list, :options

  def initialize(client_class, servers, options = {})
    @options = DEFAULTS.merge(options)
    @client_class = client_class        
    @server_list = Array(servers)
    @server_list = @server_list.sort_by { rand } if @options[:randomize_server_list]
    
    @attempts = 0
    @live_server_list = []    
    reconnect!    
  end
  
  private
  
  def method_missing(*args)
    attempts ||= 0
    @client.send(*args)    
  rescue *@options[:exception_classes]
    raise if attempts > @server_list.size
    reconnect!
    attempts += 1
    retry
  end  
  
  def reconnect!
    @transport.close rescue nil
    
    server = next_server.to_s.split(":")
    raise ArgumentError, 'Servers must be in the form "host:port"' if server.size != 2

    @transport = @options[:transport].new(
      Thrift::Socket.new(server.first, server.last.to_i, @options[:socket_timeout]))
    @transport.open
    @client = @client_class.new(@options[:protocol].new(@transport, false))
  end
  
  def next_server
    @live_server_list = @server_list.dup if @live_server_list.empty?
    @live_server_list.pop
  end  
end