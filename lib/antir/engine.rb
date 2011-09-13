require 'antir/engine/hypervisor_handler'
require 'antir/engine/vps'
require 'antir/server'

module Antir
  module Engine
    def self.start
      server = fork { Antir::Server.listen }
      wait = fork { Antir::Server.wait }
      Antir::Engine::Worker.start
    end
  end
end
