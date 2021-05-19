module SortaRedis
  module Actor
    class Receiver < Ractor
      def self.new(pipe, logger)
        super(pipe, logger) do |pipe, logger|
          logger.info "[Receiver] Started"

          Ractor.current[:port] = 9009
          tcp_server = TCPServer.new('0.0.0.0', Ractor.current[:port])

          loop do
            socket = tcp_server.accept
            pipe.send(SortaRedis::Protocol::Client.new(socket, logger: logger), move: true)
          end
        rescue
          Ractor.yield([Ractor.current[:port]])
        end
      end
    end
  end
end