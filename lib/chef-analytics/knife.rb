require 'chef-analytics/identity'
require 'chef/config'

module ChefAnalytics
  class Knife < Chef::Knife
    option :identity_server_url,
      :long         => "--identity-server-url HOST",
      :description  => "URL of Chef identity server to use"

    option :analytics_server_url,
      :long         => "--analytics-server-url HOST",
      :description  => "URL of Chef analytics server to use"

    def initialize(arg)
      super(arg)
    end

    #
    # helper functions
    #

    def fetch_token
      identity = ChefAnalytics::Identity.new(identity_server_url: @identity_server_url)
      token = identity.token
      if token.nil?
        ui.error "Couldn't get OAuth2 token from OC-ID server"
        exit 1
      end
      token
    end

    def validate_and_set_params
      @analytics_server_url ||= Chef::Config[:analytics_server_url]
      @analytics_server_url ||= config[:analytics_server_url]
      @identity_server_url ||= Chef::Config[:identity_server_url]
      @identity_server_url ||= config[:identity_server_url]

      unless @analytics_server_url
        ui.error "analytics_server_url not set in config or command line"
        exit 1
      end
    end

    def analytics_server_root
      URI.join(@analytics_server_url, '/').to_s
    end
  end
end
