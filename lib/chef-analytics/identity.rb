require 'chef-analytics/token'
require 'chef/config'
require 'chef/http'
require 'chef/http/authenticator'
require 'chef/http/json_output'
require 'chef/util/path_helper'
require 'digest/md5'

module ChefAnalytics
  class Identity

    class IdentityServerAPI < Chef::HTTP
      attr_accessor :url

      def initialize(options)
        super(options[:identity_server_url], options)
      end
      use Chef::HTTP::Authenticator
      use Chef::HTTP::JSONOutput
    end

    def initialize(options = {})
      options = options.dup
      options[:identity_server_url] ||= default_identity_server_url
      options[:client_name] ||= Chef::Config[:node_name]
      options[:signing_key_filename] ||= Chef::Config[:client_key]

      Chef::Log.debug("Using Identity Server: #{options[:identity_server_url]}")

      @options = options
      @identity_server = IdentityServerAPI.new(options)
      @cache_file_name = construct_file_name(options[:identity_server_url],
                                             options[:client_name])
    end

    def token
      fs_token = token_from_filesystem
      if fs_token
        fs_token
      else
        token_from_signed_request
      end
    end

    def token_from_signed_request
      begin
        result = @identity_server.request(:post, "oauth/token?grant_type=password",
                                          {'Content-Type' => 'application/json'})
        token = ChefAnalytics::Token.from_hash(result)
        token.identity_server_url @options[:identity_server_url]
        token.client_name @options[:client_name]
        token.to_file(@cache_file_name)
        token
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET,
             EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
             Net::ProtocolError => e
        Chef::Log.error("Exception caught on getting token: #{e}")
        nil
      end
    end

    def token_from_filesystem
      if File.exists?(@cache_file_name) && File.readable?(@cache_file_name)
        Chef::Log.debug("Loading token from FS: #{@cache_file_name}")
        token = ChefAnalytics::Token.from_file(@cache_file_name)
        if token.expired?
          Chef::Log.debug("Found expired cached credentials: #{@cache_file_name}")
          return nil
        end

        token
      else
        Chef::Log.debug("Couldn't find cached credentials: #{@cache_file_name}")
        nil
      end
    end

    private

    def identity_cache_dir
      File.join(Chef::Config[:file_cache_path], 'identity')
    end

    def construct_file_name(url, client_name)
      md5 = Digest::MD5.new
      md5.update url
      md5.update client_name
      File.join(identity_cache_dir,"#{md5.hexdigest}.json")
    end

    def default_identity_server_url
      URI.join(Chef::Config[:chef_server_url],'/id').to_s
    end
  end
end
