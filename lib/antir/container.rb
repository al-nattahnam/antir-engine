require 'antir/container/vps'

module Antir
  module Container
    class << self
      def initialize
        @hypervisor = Hypervisor.new(:openvz)
      end
    end
  end
end
