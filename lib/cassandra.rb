require 'rubygems'
gem 'thrift_client', '>= 0.7.0'
require 'thrift_client'
gem 'simple_uuid' , '~> 0.2.0'
require 'simple_uuid'

require 'json' unless defined?(JSON)

here = File.expand_path(File.dirname(__FILE__))

class TwitterCassandra ; end
unless TwitterCassandra.respond_to?(:VERSION)
  require "#{here}/cassandra/0.8"
end

$LOAD_PATH << "#{here}/../vendor/#{TwitterCassandra.VERSION}/gen-rb"
require "#{here}/../vendor/#{TwitterCassandra.VERSION}/gen-rb/cassandra"

$LOAD_PATH << "#{here}"

require 'cassandra/helpers'
require 'cassandra/array'
require 'cassandra/time'
require 'cassandra/comparable'
require 'cassandra/long'
require 'cassandra/ordered_hash'
require 'cassandra/columns'
require 'cassandra/protocol'
require "cassandra/#{TwitterCassandra.VERSION}/columns"
require "cassandra/#{TwitterCassandra.VERSION}/protocol"
require "cassandra/cassandra"
require "cassandra/#{TwitterCassandra.VERSION}/cassandra"
unless TwitterCassandra.VERSION.eql?("0.6")
  require "cassandra/column_family"
  require "cassandra/keyspace"
end
require 'cassandra/constants'
require 'cassandra/debug' if ENV['DEBUG']
