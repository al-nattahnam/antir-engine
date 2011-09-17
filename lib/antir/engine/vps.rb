require 'forwardable'

require 'antir/engine/vps/xml'

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

      def initialize(create = true)
        @xml = Antir::Engine::VPS::XML.new

        id_disponible = (@@hypervisor.domains.max_id || 100) + 1
        self.id = id_disponible
        self.name = id_disponible
        self.ip = "10.10.1.#{id_disponible}"

        super()
        self
      end
      def_delegators :@xml, :id, :name, :uuid, :ip, :'id=', :'name=', :'uuid=', :'ip='
  
      def self.find(id)
        xml = @@hypervisor.find(id)
        vps_xml = Antir::Engine::VPS::XML.parse(xml)
        vps = Antir::Engine::VPS.new
        vps.xml = vps_xml
        vps
      end

      def self.ids
        @@hypervisor.ids
      end

      def xml
        @xml.to_xml
      end

      protected
      def xml=(xml)
        @xml = xml
      end

      def create
        @@hypervisor.create(self.xml)
      end

      def destroy
        @@hypervisor.destroy(self.id)
      end
    end
  end
end
