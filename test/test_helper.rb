CASSANDRA_VERSION = ENV['CASSANDRA_VERSION'] || '0.8' unless defined?(CASSANDRA_VERSION)
CASSANDRA_VERSION_MAJOR_MINOR_ONLY = CASSANDRA_VERSION[0..2] unless defined?(CASSANDRA_VERSION_MAJOR_MINOR_ONLY)

require 'test/unit'
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/twitter_cassandra/#{CASSANDRA_VERSION_MAJOR_MINOR_ONLY}"
begin; require 'ruby-debug'; rescue LoadError; end

begin
  @test_client = TwitterCassandra.new('Twitter', 'localhost:9160', :thrift_client_options => {
    :retries         => 3,
    :timeout         => 5,
    :connect_timeout => 1
  })
rescue Thrift::TransportException => e
  #FIXME Make server automatically start if not running
  if e.message =~ /Could not connect/
    puts "*** Please start the TwitterCassandra server by running 'rake cassandra'. ***"
    exit 1
  end
end
