require 'antir/server'
require 'rest_client'

module Antir
  module Engine
    @@config = nil

    def self.load_config(path)
      @@config = YAML.load_file(path)
      Antir::Engine::HypervisorHandler.instance.reconnect
    end

    def self.outer_address
      return nil if @@config.empty?
      "#{@@config['outer']['host']}:#{@@config['outer']['port']}"
    end

    def self.inner_address
      return nil if @@config.empty?
      "#{@@config['inner']['host']}:#{@@config['inner']['port']}"
    end

    def self.worker_ports
      return nil if @@config.empty?
      @@config['workers']['beanstalkd_ports']
    end

    def self.hypervisor
      return nil if @@config.empty?
      @@config['hypervisor']
    end

    def self.attach
      return false if @@config.empty?

      json = {'ip' => '10.80.1.110'}.to_json
      resp = RestClient.post 'http://10.40.1.107:4568/engine', json, :content_type => :json, :accept => :json
      # resp = JSON.parse(resp)
      # {'stat' => 'ok', 'code' => '00'}
      self.start
    end

    def self.start
      return false if @@config.empty?
      server = fork { Antir::Server.listen }
      wait = fork { Antir::Server.wait }
      Antir::Engine::Worker.start
    end
  end
end

require 'antir/engine/hypervisor_handler'
require 'antir/engine/vps'
require 'antir/engine/worker'
