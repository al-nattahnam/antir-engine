#require 'antir/server'
require 'rest_client'
require 'singleton'

require 'sigar'

CONFIG_PATH = '/opt/src/config2.yml'

module Antir
  class Engine
    attr_reader :outer_address, :inner_address, :hypervisor_driver, :worker_ports
    include Singleton

    def initialize
      load_config
      @hypervisor = Antir::Engine::Hypervisor.instance
      @hypervisor.connect(@hypervisor_driver)
    end

    def load_config
      config = YAML.load_file(CONFIG_PATH)
      begin
        #@outer_host = config['outer']['host']
        @outer_host = Sigar.new.net_interface_config('eth0').address
        @outer_address = "#{config['outer']['host']}:#{config['outer']['port']}"
        @inner_address = "#{config['inner']['host']}:#{config['inner']['port']}"
        @hypervisor_driver = config['hypervisor']
        @worker_ports = config['workers']['beanstalkd_ports']
      rescue
        throw "Engine could not be initializated! Config is missing"
      end
    end

    def reconnect
      @hypervisor.reload
    end

    def domains
      @hypervisor.domains
    end

    def attach
      json = {'ip' => @outer_host}
      resp = RestClient.post 'http://192.168.123.100:3000/engines/register', json, :content_type => :json, :accept => :json

      #resource = RestClient::Resource.new('http://127.0.0.1:3000/engines')
      #resp = resource['register'].post :code => '03'
      #resource['3/show'].get

      # resp = JSON.parse(resp)
      # {'stat' => 'ok', 'code' => '00'}
      start
    end

    def start
      @dispatcher = Antir::Engine::Dispatcher.instance
      @worker_pool = Antir::Engine::WorkerPool.new(@worker_ports)
      
      @worker_pool.workers.each do |worker|
        worker.start
      end
      @dispatcher.start

      #return false if @config.empty?
      #server = fork { Antir::Server.listen }
      #wait = fork { Antir::Server.wait }
      #Antir::Engine::Worker.start
    end

    def self.method_missing(name, *args)
      instance.send(name, *args)
    end
  end
end

require 'antir/engine/hypervisor'
require 'antir/engine/vps'
require 'antir/engine/worker'
require 'antir/engine/dispatcher'
