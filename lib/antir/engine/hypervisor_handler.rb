require 'libvirt'
require 'singleton'
require 'forwardable'
require 'antir/engine/hypervisor/domain_handler'

module Antir
  module Engine
    module Hypervisor
      HYPERVISOR = 'openvz' # [:openvz, :xen].include?() validar!
      @@connection = Libvirt::connect("#{HYPERVISOR}:///system")

      @@domain_handler = Antir::Engine::Hypervisor::DomainHandler.instance
      @@domain_handler.connection = @@connection

      @@workers = []
  
      extend Forwardable
      def_delegators :@@domain_handler, :find, :create, :max_id
      # agregar: stop, reboot, etc...
  
      def domains
        @@domain_handler #.domains
      end
    end
  
    class HypervisorHandler
      include Antir::Engine::Hypervisor
      include Singleton
    end
  end
end
