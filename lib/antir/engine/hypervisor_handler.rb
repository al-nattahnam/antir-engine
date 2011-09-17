require 'libvirt'
require 'singleton'
require 'forwardable'
require 'antir/engine/hypervisor/domain_handler'

module Antir
  module Engine
    module Hypervisor
      #HYPERVISOR = 'openvz' # [:openvz, :xen].include?() validar!
      @@connection = nil

      @@domain_handler = Antir::Engine::Hypervisor::DomainHandler.instance
      #@@domain_handler.connection = @@connection

      @@workers = []
  
      extend Forwardable
      def_delegators :@@domain_handler, :find, :create, :max_id, :ids, :destroy
      # agregar: stop, reboot, etc...
  
      def domains
        reconnect
        @@domain_handler
      end

      def reconnect
        return false if not Antir::Engine.hypervisor
        @@connection = Libvirt::connect("#{Antir::Engine.hypervisor}:///system")
        @@domain_handler.connection = @@connection
      end
    end
  
    class HypervisorHandler
      include Antir::Engine::Hypervisor
      include Singleton
    end
  end
end
