require 'libvirt'
require 'singleton'

# dom.xml
# dom.destroy
# dom.reboot
# dom.start
# dom.stop

module Antir
  module Engine
    module Hypervisor
      class DomainHandler
        include Singleton
  
        def connection=(connection)
          @@connection = connection
        end
  
        def max_id
          @@connection.domains.collect(&:id).max
        end

        def ids
          @@connection.domains.collect(&:id)
        end
  
        def find(id)
          @@connection.domains.select{|d| d.id == id}[0].xml
        end

        def destroy(id)
          dom = @@connection.domains.select{|d| d.id == id}[0]
          dom.stop
          dom.undefine
        end

        def create(xml)
          # @@connection.workers
          @@connection.domains.create(xml)
        end
      end
    end
  end
end
