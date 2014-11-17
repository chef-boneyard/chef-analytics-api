require 'chef/http'
require 'chef/http/json_output'
require 'chef-analytics/http/token_authenticator'

module ChefAnalytics
  class ServerAPI < Chef::HTTP
    attr_accessor :url, :authentication_token

    def initialize(url, token, options = {})
      options = options.dup
      options[:authentication_token] = token
      super(url, options)

      @authenticator = ChefAnalytics::HTTP::TokenAuthenticator.new(options)
      @request_id = RemoteRequestID.new(options)

      @middlewares << Chef::HTTP::JSONOutput.new(options)
      @middlewares << @authenticator
      @middlewares << @request_id
    end

    def authentication_token
      authenticator.token
    end
  end
end


