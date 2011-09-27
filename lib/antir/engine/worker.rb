require 'beanstalk-client'

require 'zmq'

module Antir
  module Engine
    class Worker
      @@group = ThreadGroup.new
      # group.list.size
      @@workers = []

      @@report = nil

      def initialize(address, port)
        @beanstalk = Beanstalk::Pool.new(["#{address}:#{port}"])
      end

      # service
      # create  | xml
      # destroy | id
      # stop    | id

      def do
        if self.queue_size > 0 then
          job = @beanstalk.reserve
          # job.state -> reserved

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
        vps = Antir::Engine::VPS.new

        code = options['code']
        vps.id = code
        vps.name = code
        vps.ip = "10.10.1.#{code}"
        vps.create

        @@report.send("created #{options['code']}")
        #msg = @@report.recv()
      end

      #def destroy(options)

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
        Antir::Engine.worker_ports.each do |port|
          @@workers << self.new('127.0.0.1', port)
        end
        
        @@workers.each do |worker|
          @@group.add(Thread.new { loop { worker.do } } )
        end

        @@context = ZMQ::Context.new
        @@report = @@context.socket ZMQ::PUSH
        @@report.connect("ipc://#{Antir::Engine.inner_address}")
      end
    end
  end
end
