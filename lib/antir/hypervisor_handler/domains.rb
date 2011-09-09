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
  module HypervisorHandler

    module DomainHandler

      def connection=(connection)
        @@connection = connection
      end

      def max_id
        @@connection.domains.collect(&:id).max
      end
    end

    class Domains
      include Antir::HypervisorHandler::DomainHandler
      include Singleton
    end
  end
end
