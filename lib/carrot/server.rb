require 'uri'
require 'net/http'
require 'rack'
require 'carrot/util/timeout'
require 'carrot/rails'

module Carrot
  class Server
    class Identify
      def initialize(app)
        @app = app
      end

      def call(env)
        if env["PATH_INFO"] == "/__identify__"
          [200, {}, @app.object_id.to_s]
        else
          @app.call(env)
        end
      end
    end

    class << self
      def ports
        @ports ||= {}
      end
    end

    attr_reader :app, :port

    def initialize(app)
      @app = app
    end

    def host
      "127.0.0.1"
    end

    def url(path)
      if path =~ /^http/
        path
      else
        (Carrot.app_host || "http://#{host}:#{Carrot.server_port || port}") + path.to_s
      end
    end

    def responsive?
      res = Net::HTTP.start(host, @port) { |http| http.get('/__identify__') }

      if res.is_a?(Net::HTTPSuccess) or res.is_a?(Net::HTTPRedirection)
        return res.body == @app.object_id.to_s
      end
    rescue Errno::ECONNREFUSED, Errno::EBADF
      return false
    end

    def boot
      if Carrot.external_ruby
         require 'carrot/extend_server'
         Carrot.external_server = ExtendServer.new
         Carrot.external_server.run

      elsif @app
        @port = Carrot::Server.ports[@app.object_id]

        if not @port or not responsive?
          @port = Carrot.server_port || find_available_port
          Carrot::Server.ports[@app.object_id] = @port

          Thread.new do
            begin
              require 'rack/handler/thin'
              Thin::Logging.silent = true
              Rack::Handler::Thin.run(Identify.new(@app), :Port => @port)
            rescue LoadError
              require 'rack/handler/webrick'
              Rack::Handler::WEBrick.run(Identify.new(@app), :Port => @port, :AccessLog => [], :Logger => WEBrick::Log::new(nil, 0))
            end
          end

          Carrot.timeout(10) { if responsive? then true else sleep(0.5) and false end }
        end
      end
    end


  private

    def find_available_port
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end

  end
end
