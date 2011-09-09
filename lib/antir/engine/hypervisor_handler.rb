require 'libvirt'
require 'singleton'
require 'forwardable'
require 'antir/engine/hypervisor/domain_handler'

module Antir
  module Engine
    module Hypervisor
  
      #@@hypervisors = [:openvz, :xen]
      HYPERVISOR = 'openvz'
      @@connection = Libvirt::connect("#{HYPERVISOR}:///system")
      @@domain_handler = Antir::Engine::Hypervisor::DomainHandler.instance
      @@domain_handler.connection = @@connection
  
      extend Forwardable
      def_delegators :@@domain_handler, :find, :max_id
  
      def domains
        @@domain_handler #.domains
      end
  
      # delegate max_domain_id, find, create, stop, etc.... a domain_handler
      #def max_domain_id
      #  @@domain_handler.max_id
      #end
    end
  
    class HypervisorHandler
      include Antir::Engine::Hypervisor
      include Singleton
    end
  end
end
