module Fluent

  class LogioOutput < Output

    Plugin.register_output('logio', self)

    config_param :output_type, :default => 'json'
    config_param :host, :string, :default => 'localhost'
    config_param :port, :integer, :default => 28777

    def initialize
      super

      require 'socket'
    end

    def configure(conf)
      super

      @formatter = Plugin.new_formatter(@output_type)
      @formatter.configure(conf)
    end

    def start
      super
      puts @host
      puts @port
      @socket = TCPSocket.open(@host, @port)
    end

    def shutdown
      super

      @socket.close
    end

    def emit(tag, es, chain)
      es.each {|time,record|
        @socket.puts "+log|#{tag}|#{record[:hostname] or Socket.gethostname}||#{@formatter.format(tag, time, record).chomp}\r\n"
      }

      chain.next
    rescue => e
      log.error "emit", :error_class => e.class, :error => e.to_s
      log.error_backtrace
    end
  end
end
