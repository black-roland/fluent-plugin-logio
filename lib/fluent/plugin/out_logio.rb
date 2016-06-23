require 'socket'

module Fluent

  class LogioOutput < Output

    Plugin.register_output('logio', self)

    config_param :output_type, :default => 'json'
    config_param :host, :string, :default => 'localhost'
    config_param :port, :integer, :default => 28777
    config_param :node, :string, :default => nil
    config_param :stream, :string, :default => nil
    config_param :log_level, :string, :default => 'info'
    config_param :node_key_name, :string, :default => 'hostname'
    config_param :stream_key_name, :string, :default => nil
    config_param :log_level_key_name, :string, :default => nil

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
      es.each do |time,record|
        stream = @stream ? @stream : tag
        node = @node ? @node : Socket.gethostname
        logLevel = @log_level

        stream = (record[@stream_key_name] or stream) if @stream_key_name
        node = (record[@node_key_name] or node) if @node_key_name
        logLevel = (record[@log_level_key_name] or logLevel) if @log_level_key_name

        @socket.puts "+log|#{stream}|#{node}|#{logLevel}|#{@formatter.format(tag, time, record).chomp}\r\n"
      end

      chain.next
    rescue => e
      log.error "emit", :error_class => e.class, :error => e.to_s
      log.error_backtrace
    end
  end
end
