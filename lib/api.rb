# frozen_string_literal: true

require 'redis'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'

module FlexDns
  class Api < Sinatra::Base
    IP_PATTERN = /\A[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\Z/.freeze
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
      @redis.get('mykey')
    end

    post '/host' do
      if IP_PATTERN.match? params['address']
        @redis.set(params['host'], params['address'])
        json(result: :ok)
      else
        json(result: :ng)
      end
    end

    get '/list' do
      keys = @redis.keys('*')
      entries = keys.map do |key|
        [key, @redis.get(key)]
      end
      json entries.to_h
    end
  end
end

FlexDns::Api.run! if __FILE__ == $PROGRAM_NAME
