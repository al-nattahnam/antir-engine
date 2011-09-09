require 'libvirt'
require 'singleton'

# conn.domains
# dom = conn.domains.first
# dom.xml
# dom.destroy
# dom.reboot
# dom.start
# dom.stop

module Antir
  class Hypervisor
    include Singleton
    
    #@@hypervisors = [:openvz, :xen]
    HYPERVISOR = 'openvz'
    @@connection = nil#Libvirt::connect("#{HYPERVISOR}:///system")

    def initialize(hypervisor = :openvz)
      @hypervisor = hypervisor
      # check valid driver: @@types.include?(driver)

      #id_disponible = self.class.max_id + 1
      #self.id = id_disponible
      #self.name = id_disponible
      #self.ip = "10.10.1.#{id_disponible}"

      #@domains = Antir::Container::Hypervisor::DomainHandler.new

      self
    end

    def domains
      @@domains
    end

    def max_domain_id
      @@connection.domains.collect(&:id).max
    end

    def connection
      @@connection
    end

    private
    class DomainHandler
      def initialize(connection)
        @connection = connection
      end

      def find(id)
        @connection.domains.select{|d| d.id == id}[0].xml
      end
    end
    @@domains = Antir::Hypervisor::DomainHandler.new(@@connection)

#    def find(id)
#      #xml = LibXML::XML::Parser.string(dom.xml).parse
#      #domain_xml = xml.find('//domain')[0]
#
#      #vps = Antir::Container::VPS.new
#      #vps.id = domain_xml['id']
#      #vps.uuid = domain_xml.find('//uuid')[0].content
#      #vps.name = domain_xml.find('//name')[0].content
#      #vps.ip = domain_xml.find('//devices/interface/ip')[0]['address']
#      #vps
#    end
#
#    def create(xml)
#      # validate
#      #   name presence
#      @@connection.domains.create(xml)
#    end
#
#    def stop
#      @@connection
#      #
#    end

    def self.hypervisors
      @@hypervisors
    end
  end
end
