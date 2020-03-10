# frozen_string_literal: true

require 'async/dns'
require 'redis'

module FlexDns
  #
  # DNS Server
  #
  class DnsServer < Async::DNS::Server
    UPSTREAM_DNS = [[:udp, '8.8.8.8', 53], [:tcp, '8.8.8.8', 53]].freeze

    def initialize(*)
      super
      @redis = Redis.new(host: ENV.fetch('REDIS', 'localhost'))
    end

    def process(name, resource_class, transaction)
      @logger.debug name
      @logger.debug resource_class

      address = @redis.get(name)
      if address
        transaction.respond!(address)
      else
        @resolver ||= Async::DNS::Resolver.new(UPSTREAM_DNS)
        transaction.passthrough!(@resolver)
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  server = FlexDns::DnsServer.new([[:udp, '0.0.0.0', 2346]])
  server.run
end
