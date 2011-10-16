require 'forwardable'

require 'antir/engine/vps/xml'

require 'antir/engine/hypervisor'

# conn.domains
# dom = conn.domains.first
# dom.xml
# dom.destroy
# dom.reboot
# dom.start
# dom.stop

module Antir
  class Engine
    class VPS
      extend Forwardable

      def initialize(create = true)
        @xml = Antir::Engine::VPS::XML.new

        id_disponible = (Antir::Engine.domains.max_id || 100) + 1
        self.id = id_disponible
        self.name = id_disponible
        self.ip = "10.10.1.#{id_disponible}"

        super()
        self
      end
      def_delegators :@xml, :id, :name, :uuid, :ip, :'id=', :'name=', :'uuid=', :'ip='
  
      def self.find(id)
        xml = Antir::Engine.domains.find(id)
        vps_xml = Antir::Engine::VPS::XML.parse(xml)
        vps = Antir::Engine::VPS.new
        vps.xml = vps_xml
        vps
      end

      def self.ids
        Antir::Engine.domains.ids
      end

      def xml
        @xml.to_xml
      end

      def xml=(xml)
        @xml = xml
      end

      def create
        Antir::Engine.domains.create(self.xml)
      end

      def destroy
        Antir::Engine.domains.destroy(self.id)
      end
    end
  end
end
