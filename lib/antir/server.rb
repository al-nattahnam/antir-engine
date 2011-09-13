require 'zmq'
require 'bson'

require 'beanstalk-client'

module Antir
  module Server
    class << self
      #INCOMING_IP = '10.80.1.110:5555'
      INCOMING_IP = '10.40.1.107:5555'

      def listen
        context = ZMQ::Context.new
        reply = context.socket ZMQ::REP
        reply.bind("tcp://#{INCOMING_IP}")
        
        beanstalk = Beanstalk::Pool.new(['127.0.0.1:11300', '127.0.0.1:11301'])

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
        subscriber.bind('tcp://127.0.0.1:5556')
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
