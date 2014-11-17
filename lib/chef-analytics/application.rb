require 'chef-analytics/identity'
require 'chef-analytics/server_api'
require 'chef/config_fetcher'
require 'mixlib/log'
require 'mixlib/cli'

module ChefAnalytics
  class Application < Chef::Application
    include Mixlib::CLI

    banner "Usage: chef-analytics sub-command (options)"

    option :config_file,
      :short => "-c CONFIG",
      :long  => "--config CONFIG",
      :description => "The configuration file to use",
      :proc => lambda { |path| File.expand_path(path, Dir.pwd) }

    option :identity_server_url,
      :long         => "--identity-server-url HOST",
      :description  => "URL of Chef identity server to use"

    option :analytics_server_url,
      :long         => "--analytics-server-url HOST",
      :description  => "URL of Chef analytics server to use"

    verbosity_level = 0
    option :verbosity,
      :short => '-V',
      :long  => '--verbose',
      :description => "More verbose output. Use twice for max verbosity",
      :proc  => Proc.new { verbosity_level += 1},
      :default => 0


    def setup_application
      quiet_traps
      apply_computed_config
    end

    def run_application
      options = {}

      options[:identity_server_url] = config[:identity_server_url] if config[:identity_server_url]

      identity = ChefAnalytics::Identity.new(options)
      token = identity.token

      if token.nil?
        Chef::Log.error("Can't get token")
        exit 1
      end

      Chef::Log.info("Token is #{token.to_json}")
      Chef::Log.info("Connecting to Analytics: #{Chef::Config[:analytics_server_url]}")

      analytics = ChefAnalytics::ServerAPI.new(Chef::Config[:analytics_server_url], token)

      actions = analytics.get('actions')
      pp actions
      action = analytics.get('https://analytics.opscode.piab/actions/ef315bdf-ff44-4470-b99b-ba5c0f1725fd')
      pp action
      exit 0
    end

    def quiet_traps
      trap("TERM") do
        exit 1
      end

      trap("INT") do
        exit 2
      end
    end

    def apply_computed_config
      case Chef::Config[:verbosity]
      when 0, nil
        Chef::Config[:log_level] = :error
      when 1
        Chef::Config[:log_level] = :info
      else
        Chef::Config[:log_level] = :debug
      end

      Mixlib::Log::Formatter.show_time = false
      Chef::Log.init(Chef::Config[:log_location])
      Chef::Log.level(Chef::Config[:log_level] || :error)
    end
  end
end
