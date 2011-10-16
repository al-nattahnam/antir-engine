#require 'antir/server'
require 'rest_client'
require 'singleton'

CONFIG_PATH = '/opt/src/config2.yml'

module Antir
  class Engine
    include Singleton

    def initialize
      load_config
      @hypervisor = Hypervisor.instance
      @hypervisor.connect(hypervisor_driver)
    end

    def load_config
      @config = YAML.load_file(CONFIG_PATH)
    end

    def reconnect
      @hypervisor.reload
    end

    def outer_address
      "#{@config['outer']['host']}:#{@config['outer']['port']}" rescue nil
    end

    def inner_address
      "#{@config['inner']['host']}:#{@config['inner']['port']}" rescue nil
    end

    def worker_ports
      @config['workers']['beanstalkd_ports'] rescue nil
    end

    def hypervisor_driver
      @config['hypervisor'] rescue nil
    end

    #def hypervisor
    #  @hypervisor
    #end

    def domains
      @hypervisor.domains
    end

    def attach
      return false if @config.empty?

      json = {'ip' => @config['outer']['host']}
      resp = RestClient.post 'http://10.0.0.5:3000/engines/register', json, :content_type => :json, :accept => :json

      #resource = RestClient::Resource.new('http://127.0.0.1:3000/engines')
      #resp = resource['register'].post :code => '03'
      #resource['3/show'].get

      # resp = JSON.parse(resp)
      # {'stat' => 'ok', 'code' => '00'}
      start
    end

    def start
      return false if @config.empty?
      server = fork { Antir::Server.listen }
      wait = fork { Antir::Server.wait }
      Antir::Engine::Worker.start
    end

    def self.method_missing(name, *args)
      instance.send(name, args)
    end
  end
end

require 'antir/engine/hypervisor'
require 'antir/engine/vps'
require 'antir/engine/worker'
