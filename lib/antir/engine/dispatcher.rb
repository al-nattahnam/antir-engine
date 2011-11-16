require 'singleton'
require 'em-zeromq'
require 'json'

require 'beanstalk-client'

module Antir
  class Engine
    class Dispatcher
      include Singleton

      def initialize
        pool_addresses = Antir::Engine.worker_ports.collect{|port| "127.0.0.1:#{port}"}
      end

      def start
        EM.run do
          ctx = EM::ZeroMQ::Context.new(1)

          ctx.bind(ZMQ::REP, "tcp://#{Antir::Engine.outer_address}", OuterHandler.new)
          ctx.bind(ZMQ::PULL, "tcp://#{Antir::Engine.inner_address}", InnerHandler.new)
        end
      end

      class OuterHandler
        attr_reader :received
        def on_readable(socket, messages)
          messages.each do |m|
            puts m.copy_out_string
            resp = Antir::Engine.worker_pool.push m.copy_out_string
            socket.send_msg('ok!') # devolver un response (id, status.. etc)
          end
        end
      end

      class InnerHandler
        attr_reader :received
        def on_readable(socket, messages)
          message.each do |m|
            puts m.copy_out_string
          end
        end
      end
    end
  end
end
