require 'rest_client'
require 'singleton'

require 'sigar'

CONFIG_PATH = '/opt/src/config2.yml'

module Antir
  class Engine
    attr_reader :outer_address, :inner_address, :hypervisor_driver, :worker_ports, :worker_pool
    include Singleton
    include Cucub::LiveObject

    live :channel, :reply

    def initialize
      load_config
      @hypervisor = Antir::Hypervisor.instance
      @hypervisor.connect(@hypervisor_driver)
    end

    def load_config
      config = YAML.load_file(CONFIG_PATH)
      begin
        #@outer_host = config['outer']['host']
        net_config = Sigar.new.net_interface_config('eth0')

        @outer_host = net_config.address
        @mac = net_config.hwaddr
        @outer_address = "#{config['outer']['host']}:#{config['outer']['port']}"
        #@inner_address = "#{config['inner']['host']}:#{config['inner']['port']}"
        @hypervisor_driver = config['hypervisor']
        # @worker_ports = config['workers']['beanstalkd_ports']
      rescue
        throw "Engine could not be initializated! Config is missing"
      end
    end

    def reconnect
      @hypervisor.reload
    end

    def domains
      @hypervisor.domains
    end

    # service
    # create  | xml
    # destroy | id
    # stop    | id

    def vps_create(options)
      #puts "#{@beanstalk.last_conn.addr}: create #{options['code']}\n"
      puts options.inspect
      vps = Antir::VPS.new

      code = options['code']
      vps.id = code
      vps.name = code
      vps.ip = "10.10.1.#{code}"
      puts vps.inspect
      vps.create

      #@report.send_string("created #{options['code']}")
    end

    #def destroy(options)

    def attach
      json = {'mac' => @mac, 'ip' => @outer_host}
      resp = RestClient.post 'http://10.0.0.3:3000/engines/register', json, :content_type => :json, :accept => :json

      #resource = RestClient::Resource.new('http://127.0.0.1:3000/engines')
      #resp = resource['register'].post :code => '03'
      #resource['3/show'].get

      # resp = JSON.parse(resp)
      # {'stat' => 'ok', 'code' => '00'}
      start
    end

    def start
      Cucub.start!(@outer_host)
    end

    def self.method_missing(name, *args)
      instance.send(name, *args)
    end
  end
end
