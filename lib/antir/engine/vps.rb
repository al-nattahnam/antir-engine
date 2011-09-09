require 'forwardable'

require 'antir/engine/vps/xml'
require 'antir/engine/vps/states'

require 'antir/engine/hypervisor_handler'

# conn.domains
# dom = conn.domains.first
# dom.xml
# dom.destroy
# dom.reboot
# dom.start
# dom.stop

module Antir
  module Engine
    class VPS
      @@hypervisor = Antir::Engine::HypervisorHandler.instance
  
      extend Forwardable

      include Antir::Engine::VPS::States
  
      def initialize(create = true)
        @xml = Antir::Engine::VPS::XML.new

        id_disponible = @@hypervisor.domains.max_id + 1
        self.id = id_disponible
        self.name = id_disponible
        self.ip = "10.10.1.#{id_disponible}"

        self
      end
      def_delegators :@xml, :id, :name, :uuid, :ip, :'id=', :'name=', :'uuid=', :'ip='
  
      def self.find(id)
        xml = @@hypervisor.find(id)
        vps = Antir::Engine::VPS::XML.parse(xml)
        vps
      end
  
      def xml
        @xml.to_xml
      end
    end
  end
end
