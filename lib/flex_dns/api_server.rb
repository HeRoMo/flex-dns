# frozen_string_literal: true

require 'ipaddr'
require 'redis'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'

module FlexDns
  #
  # Rest API Server
  #
  class ApiServer < Sinatra::Base
    set :server, :puma
    set :bind, '0.0.0.0'

    def initialize
      super
      @redis = Redis.new(host: ENV.fetch('REDIS', 'localhost'))
    end

    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      json(message: 'flex DNS is alive')
    end

    post '/host' do
      if valid_host?(params['name']) && valid_ip?(params['address'])
        @redis.set(params['name'], params['address'])
        json(result: :ok)
      else
        json(result: :ng)
      end
    end

    delete '/host' do
      @redis.del(params['name']) if valid_host?(params['name'])

      json(result: :ok)
    end

    get '/list' do
      keys = @redis.keys('*')
      entries = keys.map do |key|
        [key, @redis.get(key)]
      end
      json entries.to_h
    end

    private

    def valid_host?(host)
      host.is_a?(String) && host.length.positive?
    end

    def valid_ip?(ip)
      !!IPAddr.new(ip) rescue false # rubocop:disable Style/RescueModifier, Style/DoubleNegation
    end
  end
end

FlexDns::ApiServer.run! if __FILE__ == $PROGRAM_NAME
