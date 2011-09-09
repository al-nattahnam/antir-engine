#require 'rubygems'
require 'zmq'
require 'bson'

require 'beanstalk-client'

module Antir
  module Server
    class << self
      # group = ThreadGroup.new
      # group.list.size # threads
      # group.add(Thread.new { process msg from reply.recv() })

      def listen
        context = ZMQ::Context.new
        reply = context.socket ZMQ::REP
        reply.bind('tcp://10.80.1.110:5555')
        
        beanstalk = Beanstalk::Pool.new(['127.0.0.1:11300'])
        
        while true
          msg = reply.recv()
          deserialized_msg = BSON.deserialize(msg)
          print "Got: #{deserialized_msg['text']} #{deserialized_msg['test_number']}"
        
          beanstalk.put(deserialized_msg['test_number'])
        
          response = {:body => "Got #{deserialized_msg['test_number']}"}
          serialized_response = BSON.serialize(response).to_s
          reply.send(serialized_response)
        end
      end
    end
  end
end

