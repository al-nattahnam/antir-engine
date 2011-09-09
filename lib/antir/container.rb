require 'antir/container/vps'
require 'antir/container/hypervisor'

module Antir
  module Container
    class << self
      def initialize
        @hypervisor = Hypervisor.new(:openvz)
      end
    end
  end
end
