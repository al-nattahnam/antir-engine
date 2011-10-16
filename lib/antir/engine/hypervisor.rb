require 'libvirt'
require 'singleton'
require 'forwardable'
require 'antir/engine/hypervisor/domain_handler'

#HYPERVISOR = 'openvz' # [:openvz, :xen].include?() validar!

module Antir
  class Engine
    class Hypervisor
      include Singleton

      @connection = nil

      @domain_handler = Antir::Engine::Hypervisor::DomainHandler.instance

      @workers = []
  
      extend Forwardable
      def_delegators :@domain_handler, :find, :create, :max_id, :ids, :destroy # stop, reboot, etc...
  
      def connect(driver, reload=false)
        @driver = driver if not reload
        @connection = Libvirt::connect("#{@driver}:///system")
      end

      def reload
        connect
        @domain_handler.connection = @connection
      end

      def domains
        reload
        @domain_handler
      end
    end
  end
end
