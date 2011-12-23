require 'libvirt'
require 'singleton'

# dom.xml
# dom.destroy
# dom.reboot
# dom.start
# dom.stop

module Antir
  class Hypervisor
    class DomainHandler
      include Singleton
  
      def connection=(connection)
        @connection = connection
      end
  
      def max_id
        @connection.domains.collect(&:id).max
      end

      def ids
        @connection.domains.collect(&:id)
      end
  
      def find(id)
        id = id.to_i
        @connection.domains.select{|d| d.id == id}[0].xml
      end

      def destroy(id)
        id = id.to_i
        dom = @connection.domains.select{|d| d.id == id}[0]
        puts dom.inspect
        dom.stop
        dom.undefine
      end

      def create(xml)
        # @connection.workers
        @connection.domains.create(xml)
      end
    end
  end
end
