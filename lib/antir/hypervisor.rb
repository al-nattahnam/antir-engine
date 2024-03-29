require 'libvirt'
require 'singleton'
require 'forwardable'

#HYPERVISOR = 'openvz' # [:openvz, :xen].include?() validar!

module Antir
  class Hypervisor
    include Singleton

    extend Forwardable
    def_delegators :@domain_handler, :find, :create, :max_id, :ids, :destroy # stop, reboot, etc...

    def initialize
      @connection = nil
      @domain_handler = Antir::Hypervisor::DomainHandler.instance
      @workers = []
    end
  
    def connect(driver, args={})
      @driver = driver if not args[:reload]
      @connection = Libvirt::connect("#{@driver}:///system")
    end

    def reload
      connect(@driver, :reload => true)
      @domain_handler.connection = @connection
    end

    def domains
      reload
      @domain_handler
    end
  end
end
