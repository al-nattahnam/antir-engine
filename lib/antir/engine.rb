#require 'antir/server'
require 'rest_client'
require 'singleton'

CONFIG_PATH = '/opt/src/config2.yml'
#CONFIG_PATH = '/home/fernando/desarrollo/workspace/experimentos/antir/engine/config.yml'

module Antir
  class Engine
    include Singleton
    attr_reader :outer_address, :inner_address, :hypervisor_driver, :worker_ports

    def initialize
      load_config
      @hypervisor = Antir::Engine::Hypervisor.instance
      @hypervisor.connect(hypervisor_driver)

      @dispatcher = Antir::Engine::Dispatcher.instance
      @worker_pool = Antir::Engine::WorkerPool.new(@worker_ports)
    end

    def load_config
      config = YAML.load_file(CONFIG_PATH)
      begin
        @outer_host = config['outer']['host']
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
      resp = RestClient.post 'http://10.0.0.5:3000/engines/register', json, :content_type => :json, :accept => :json

      #resource = RestClient::Resource.new('http://127.0.0.1:3000/engines')
      #resp = resource['register'].post :code => '03'
      #resource['3/show'].get

      # resp = JSON.parse(resp)
      # {'stat' => 'ok', 'code' => '00'}
      start
    end

    def start
      @workers.each do |worker|
        worker.start
      end
      @dispatcher.start
      #server = fork { Antir::Server.listen }
      #wait = fork { Antir::Server.wait }
    end

    def to_s
      instance.to_s
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
