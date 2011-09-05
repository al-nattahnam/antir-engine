require 'libvirt'
require 'libxml'

# conn.domains
# dom = conn.domains.first
# dom.xml
# dom.destroy
# dom.reboot
# dom.start
# dom.stop

module Antir
  module Container
    class VPS
      @@drivers = [:openvz, :xen]

      attr_accessor :driver

      def initialize(driver = :openvz, create = true)
        @driver = driver
        # check valid driver: @@types.include?(driver)
        vps_template = self.class.vps_template(@driver)

        @xml = LibXML::XML::Document.new
        @xml.root = vps_template

        id_disponible = self.class.max_id + 1
        self.id = id_disponible
        self.name = id_disponible
        self.ip = "10.10.1.#{id_disponible}"

        self
      end

      def self.max_id
        conn = Libvirt::connect('openvz:///system')
        conn.domains.collect(&:id).max
      end

      def id=(id)
        id_node = @xml.find('//domain')[0]
        id_node['id'] = id.to_s
      end
      def id
        id_node = @xml.find('//domain')[0]
        id_node['id']
      end

      def name=(name)
        name_node = @xml.find('//domain/name')[0]
        name_node.content = name.to_s
      end
      def name
        name_node = @xml.find('//domain/name')[0]
        name_node.content
      end

      def uuid=(uuid)
        uuid_node = @xml.find('//domain/uuid')[0]
        uuid_node.content = uuid
      end
      def uuid
        uuid_node = @xml.find('//domain/uuid')[0]
        uuid_node.content
      end

      def ip=(ip)
        ip_node = @xml.find('//domain/devices/interface/ip')[0]
        ip_node['address'] = ip
      end
      def ip
        ip_node = @xml.find('//domain/devices/interface/ip')[0]
        ip_node['address']
      end

      def self.find(id)
        conn = Libvirt::connect('openvz:///system')
        dom = conn.domains.select{|d| d.id == id}[0]

        xml = LibXML::XML::Parser.string(dom.xml).parse
        domain_xml = xml.find('//domain')[0]

        vps = VPS.new
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
        xml = @xml.find('//domain')[0].to_s(:indent => true)
        conn.domains.create(xml)
      end

      def stop
        conn = Libvirt::connect('openvz:///system')
        #
      end

      def xml
        # para debug solamente
        @xml
      end

      def to_xml
        @xml.find("//domain")[0].to_s(:indent => true)
      end

      def self.drivers
        @@driver
      end

      private
      def self.vps_template(driver)
        # use driver
        domain_xml = LibXML::XML::Node.new('domain')
        domain_xml['type'] = 'openvz'
        domain_xml['id'] = '135'
        domain_xml << LibXML::XML::Node.new('name', '')
        domain_xml << LibXML::XML::Node.new('uuid', '')
        domain_xml << LibXML::XML::Node.new('vcpu', '1')
        
        devices_xml = LibXML::XML::Node.new('devices')
        
        filesystem_xml = LibXML::XML::Node.new('filesystem')
        filesystem_xml['type'] = 'template'
        
        source_xml = LibXML::XML::Node.new('source')
        source_xml['name'] = 'debian-6.0-x86'
        
        target_xml = LibXML::XML::Node.new('target')
        target_xml['dir'] = '/'
        
        filesystem_xml << source_xml
        filesystem_xml << target_xml
        
        interface_xml = LibXML::XML::Node.new('interface')
        interface_xml['type'] = 'ethernet'
        
        ip_xml = LibXML::XML::Node.new('ip')
        ip_xml['address'] = '10.10.1.135'
        
        interface_xml << ip_xml
        
        devices_xml << filesystem_xml
        devices_xml << interface_xml
        
        domain_xml << devices_xml
        domain_xml << LibXML::XML::Node.new('memory', '0')
        
        os_xml = LibXML::XML::Node.new('os')
        os_xml << LibXML::XML::Node.new('type', 'exe')
        os_xml << LibXML::XML::Node.new('init', '/sbin/init')
        
        domain_xml << os_xml
        domain_xml
      end
    end
  end
end
