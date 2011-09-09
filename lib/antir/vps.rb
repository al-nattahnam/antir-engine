require 'libvirt'
require 'forwardable'
require 'antir/vps/xml'
require 'antir/hypervisor_handler'

# conn.domains
# dom = conn.domains.first
# dom.xml
# dom.destroy
# dom.reboot
# dom.start
# dom.stop

module Antir
  class VPS
    #attr_accessor :hypervisor
    @@hypervisor = Antir::HypervisorHandler.instance

    extend Forwardable

    def initialize(create = true)
      #id_disponible = self.class.max_id + 1
      #self.id = id_disponible
      #self.name = id_disponible
      #self.ip = "10.10.1.#{id_disponible}"

      @xml = Antir::VPS::XML.new
      self
    end
    def_delegators :@xml, :id, :name, :uuid, :ip, :'id=', :'name=', :'uuid=', :'ip='

    def self.find(id)
      vps = Antir::VPS.new
      xml = @@hypervisor.find(id)

      xml = LibXML::XML::Parser.string(xml).parse
      domain_xml = xml.find('//domain')[0]

      vps.id = domain_xml['id']
      vps.uuid = domain_xml.find('//uuid')[0].content
      vps.name = domain_xml.find('//name')[0].content
      vps.ip = domain_xml.find('//devices/interface/ip')[0]['address']
      vps
    end

    def create
      # validate
      #   name presence

      conn = Libvirt::connect('openvz:///system')
      conn.domains.create(@xml)
    end

    def stop
      conn = Libvirt::connect('openvz:///system')
      #
    end

    def xml
      @xml.to_xml
    end

    def self.hypervisors
      @@hypervisors
    end
  end
end
