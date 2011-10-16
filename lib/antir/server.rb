require 'zmq'
require 'json'

require 'beanstalk-client'

module Antir
  module Server
    # TODO Usar Em-Zmq como en Em-Core
    class << self
      def listen
        context = ZMQ::Context.new
        reply = context.socket ZMQ::REP
        reply.bind("tcp://#{Antir::Engine.outer_address}")
        
        pool_ports = Antir::Engine.worker_ports.collect{|port| "127.0.0.1:#{port}"}
        beanstalk = Beanstalk::Pool.new(pool_ports)

        loop do
          msg = reply.recv()
          # require 'zlib'
          # Zlib::Inflate.inflate(msg)

          deserialized_msg = JSON.parse(msg)
          puts deserialized_msg
          #print "Got: #{deserialized_msg['text']} #{deserialized_msg['test_number']}"
          beanstalk.yput(deserialized_msg)
          
          response = {:body => "Got #{deserialized_msg['action']}"}
          serialized_response = response.to_json
          reply.send(serialized_response)
        end
      end

      def wait
        context = ZMQ::Context.new
        pull = context.socket(ZMQ::PULL)
        pull.bind("ipc://#{Antir::Engine.inner_address}")
        loop do
          msg = pull.recv()
          puts msg
        end
      end
    end
  end
end
