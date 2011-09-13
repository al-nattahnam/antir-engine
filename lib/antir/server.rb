require 'zmq'
require 'bson'

require 'beanstalk-client'

module Antir
  module Server
    class << self
      def listen
        context = ZMQ::Context.new
        reply = context.socket ZMQ::REP
        reply.bind("tcp://#{Antir::Engine.outer_address}")
        
        pool_ports = Antir::Engine.worker_ports.collect{|port| "127.0.0.1:#{port}"}
        beanstalk = Beanstalk::Pool.new(pool_ports)

        loop do
          msg = reply.recv()
          deserialized_msg = BSON.deserialize(msg)
          deserialized_msg = deserialized_msg.inject({}) { |acc, element| k,v = element; acc[k] = (if v.class == BSON::OrderedHash then v.to_h else v end); acc }
          #print "Got: #{deserialized_msg['text']} #{deserialized_msg['test_number']}"
          beanstalk.yput(deserialized_msg)
          
          response = {:body => "Got #{deserialized_msg['action']}"}
          serialized_response = BSON.serialize(response).to_s
          reply.send(serialized_response)
        end
      end

      def wait
        context = ZMQ::Context.new
        subscriber = context.socket(ZMQ::REP)
        subscriber.bind("tcp://#{Antir::Engine.inner_address}")
        #filter = '1'
        #subscriber.setsockopt(ZMQ::SUBSCRIBE, filter)
        loop do
          msg = subscriber.recv()
          puts msg
          subscriber.send('ok')
        end
      end
    end
  end
end
