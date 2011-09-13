require 'antir/engine/hypervisor_handler'
require 'antir/engine/vps'
require 'antir/engine/worker'

require 'antir/server'

module Antir
  module Engine
    @@config = nil

    def self.load_config(path)
      @@config = YAML.load_file(path)
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

    def self.start
      return false if @@config.empty?
      server = fork { Antir::Server.listen }
      wait = fork { Antir::Server.wait }
      Antir::Engine::Worker.start
    end
  end
end
