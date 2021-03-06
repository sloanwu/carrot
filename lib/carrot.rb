require 'timeout'
require 'nokogiri'
require 'xpath'

module Carrot
  class CarrotError < StandardError; end
  class DriverNotFoundError < CarrotError; end
  class ElementNotFound < CarrotError; end
  class UnselectNotAllowed < CarrotError; end
  class NotSupportedByDriverError < CarrotError; end
  class TimeoutError < CarrotError; end
  class LocateHiddenElementError < CarrotError; end
  class InfiniteRedirectError < TimeoutError; end

  class << self
    attr_accessor :asset_root, :app_host, :run_server, :default_host
    attr_accessor :server_port
    attr_accessor :driver
    attr_accessor :app
    attr_accessor :external_ruby, :rails_command, :project_path
    attr_accessor :external_server, :server_debug

    ##
    #
    # Configure Carrot to suit your needs.
    #
    #     Carrot.configure do |config|
    #       config.run_server = false
    #       config.app_host   = 'http://www.google.com'
    #     end
    #
    # === Configurable options
    #
    # [app_host = String]                 The default host to use when giving a relative URL to visit
    # [run_server = Boolean]              Whether to start a Rack server for the given Rack app (Default: true)
    #
   
    def configure
      yield self
    end
    
    def url(path)
      @rack_server.url(path)
    end

    def register_driver(obj)
      @driver = obj
      Carrot.boot
    end

    def boot
      @rack_server = Carrot::Server.new(@app)
      @rack_server.boot if Carrot.run_server
    end

    def shutdown
      @external_server.shutdown if @external_server
    end

  end

  autoload :Server,     'carrot/server'
  
end

Carrot.configure do |config|
  config.run_server = true
  config.external_ruby = false
  config.server_debug = false
  config.server_port = 3000
end

