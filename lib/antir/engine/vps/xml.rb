require 'libxml'

module Antir
  class Engine
    class VPS
      class XML
        @@drivers = [:openvz, :xen]
  
        attr_accessor :driver
  
        def initialize(driver = :openvz, create = true)
          @driver = driver
          # check valid driver: @@types.include?(driver)
          vps_template = self.class.vps_template(@driver)
  
          @xml = LibXML::XML::Document.new
          @xml.root = vps_template
  
          self
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
  
        # def self.find(id)
  
        # end
  
        def self.parse(xml)
          # recibe de VPS::find(id) el xml del dominio y devuelve un objeto VPS::XMLRepresentation
          vps_xml = Antir::Engine::VPS::XML.new
  
          xml = LibXML::XML::Parser.string(xml).parse
          domain_xml = xml.find('//domain')[0]
  
          vps_xml.id = domain_xml['id']
          vps_xml.uuid = domain_xml.find('//uuid')[0].content
          vps_xml.name = domain_xml.find('//name')[0].content
          vps_xml.ip = domain_xml.find('//devices/interface/ip')[0]['address']
          vps_xml
        end
  
        def to_create
          # validate
          #   name presence
  
          xml = @xml.find('//domain')[0].to_s(:indent => true)
        end
  
        def to_s
          self.to_xml
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
end
