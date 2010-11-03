require "java"
require 'carrot/util/timeout'
require 'uri'
require 'net/http'
require 'rack'
import java.lang.Runtime
import java.lang.Runnable
import java.io.InputStreamReader
import java.io.BufferedReader

module Carrot
  class ExtendServer
    attr_accessor :server_process, :shutdown_process 
    
    class ShutdownHook
      include Runnable
      def initialize( &block)
     	super()
     	@block=block
      end
      def run
        @block[]
      end
    end
          
    def self.at_exit( &block)
      	hook = ShutdownHook.new( &block)
       	Runtime.getRuntime().addShutdownHook(java.lang.Thread.new( hook ))
    end

    def run()
       Thread.new do
          command = ["/bin/bash","-c", "cd #{Carrot.project_path} ; #{Carrot.rails_command}"].to_java(java.lang.String)
          begin
             @server_process = Runtime.getRuntime().exec(command)
             if Carrot.server_debug
               buf = BufferedReader.new(InputStreamReader.new(@server_process.get_input_stream))
               while line = buf.readLine()
                 puts line
               end
             end
             ExtendServer.at_exit{ Carrot.shutdown }
             @server_process.wait_for
         rescue Exception => e
            puts e
         end

       end
      Carrot.timeout(60) { if responsive? then true else sleep(0.5) and false end }
    end

    def shutdown
      Thread.new do
          command = ["/bin/bash","-c", "cd #{Carrot.project_path} ; kill `cat #{Carrot.project_path}/tmp/pids/server.pid`"].to_java(java.lang.String)
          begin
             @shutdown_process = Runtime.getRuntime().exec(command)
             @shutdown_process.wait_for
             @shutdown_process.destroy
         rescue Exception => e
            puts e
         end
      end 
    end

    def responsive?
     host = "127.0.0.1"
     res = Net::HTTP.start(host, Carrot.server_port) { |http| http.get('/__identify__') }

      unless res.nil?
        return true 
      end
    rescue Errno::ECONNREFUSED, Errno::EBADF
      return false 
    end

  end
end
