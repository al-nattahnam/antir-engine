require 'libvirt'

# conn.domains
# dom = conn.domains.first
# dom.xml
# dom.destroy
# dom.reboot
# dom.start
# dom.stop

module Antir
  module Container
    class Hypervisor
      @@hypervisors = [:openvz, :xen]

      def initialize(hypervisor = :openvz)
        @hypervisor = hypervisor
        # check valid driver: @@types.include?(driver)

        #id_disponible = self.class.max_id + 1
        #self.id = id_disponible
        #self.name = id_disponible
        #self.ip = "10.10.1.#{id_disponible}"

        @connection = Libvirt::connect("#{@hypervisor}:///system")

        self
      end

      def max_domain_id
        @connection.domains.collect(&:id).max
      end

      def find(id)
        @connection.domains.select{|d| d.id == id}[0].xml

        #xml = LibXML::XML::Parser.string(dom.xml).parse
        #domain_xml = xml.find('//domain')[0]

        #vps = Antir::Container::VPS.new
        #vps.id = domain_xml['id']
        #vps.uuid = domain_xml.find('//uuid')[0].content
        #vps.name = domain_xml.find('//name')[0].content
        #vps.ip = domain_xml.find('//devices/interface/ip')[0]['address']
        #vps
      end

      def create
        # validate
        #   name presence
        @connection.domains.create(@xml)
      end

      def stop
        @connection
        #
      end

      def self.hypervisors
        @@hypervisors
      end
    end
  end
end
