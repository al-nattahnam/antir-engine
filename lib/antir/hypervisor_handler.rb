require 'libvirt'
require 'singleton'
# require 'forwardable'
require 'antir/hypervisor/domain_handler'

module Antir
  module Hypervisor
    #@@hypervisors = [:openvz, :xen]
    HYPERVISOR = 'openvz'
    @@connection = Libvirt::connect("#{HYPERVISOR}:///system")
    @@domain_handler = Antir::Hypervisor::DomainHandler.instance
    @@domain_handler.connection = @@connection

    def domains
      @@domain_handler #.domains
    end

    # delegate max_domain_id, find, create.... a domain_handler
    #def max_domain_id
    #  @@domain_handler.max_id
    #end

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
  end

  class HypervisorHandler
    include Antir::Hypervisor
    include Singleton
  end
end
