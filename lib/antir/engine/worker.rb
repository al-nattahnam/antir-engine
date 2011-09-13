require 'beanstalk-client'

require 'zmq'

module Antir
  module Engine
    class Worker
      @@group = ThreadGroup.new
      # group.list.size
      @@workers = []
      ADDRESS = '127.0.0.1'
      PORTS = ['11300', '11301']

      @@report = nil

      def initialize(address, port)
        @beanstalk = Beanstalk::Pool.new(["#{address}:#{port}"])
      end

      # pid = fork { worker.do }

      # service
      # create  | xml
      # destroy | id
      # stop    | id

      def do
        if self.queue_size > 0 then
          job = @beanstalk.reserve
          # job.state -> reserved

          #puts job.body
          self.send(job.ybody['action'], job.ybody)

          # transaction begin
          #if not job.ybody == nil
          #  self.send(job.ybody['action'], job.ybody)
          #  job.touch # para avisar al queue que todavia se esta procesando
          #end
        
          # job.touch # para avisar al queue que todavia se esta procesando
          # job.time_left
          # job.timeouts
          # job.release # para devolver al queue
          
          job.delete # cuando se termino Ok el proceso, lo saca del queue
          # job.state
          
          #job.bury # cuando se termino Con errores el proceso, lo saca del queue
          # job.state -> buried
        
          # transaction end
        end
      end

      def create(options)
        puts "#{@beanstalk.last_conn.addr}: create #{options['code']}\n"
        sleep 5
        @@report.send("created #{options['code']}")
        msg = @@report.recv()

        #vps = Antir::Engine.create_vps
        #vps.create
      end

      def queue_size
        @beanstalk.stats["current-jobs-ready"]
      end

      def total_jobs
        @beanstalk.stats["total-jobs"] # Cantidad total de jobs resueltos/no resueltos
      end

      def self.workers
        @@workers
      end

      def self.start
        PORTS.each do |port|
          @@workers << self.new(ADDRESS, port)
        end
        
        @@workers.each do |worker|
          @@group.add(Thread.new { loop { worker.do } } )
        end

        @@context = ZMQ::Context.new
        @@report = @@context.socket ZMQ::REQ
        @@report.connect('tcp://127.0.0.1:5556')
      end
    end
  end
end
