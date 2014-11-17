require 'chef/json_compat'
require 'chef/mixin/params_validate'
require 'chef/util/path_helper'

module ChefAnalytics
  class Token

    include Chef::Mixin::ParamsValidate

    def initialize
      @access_token = nil
      @token_type = nil
      @refresh_token = nil
      @expiry = nil
      @identity_server_url = nil
      @client_name = nil
    end

    def access_token(arg=nil)
      set_or_return(:access_token, arg,
                    :kind_of => String)
    end

    def token_type(arg=nil)
      set_or_return(:token_type, arg,
                    :kind_of => String)
    end

    def refresh_token(arg=nil)
      set_or_return(:refresh_token, arg,
                    :kind_of => String)
    end

    def expiry(arg=nil)
      set_or_return(:expiry, arg,
                    :kind_of => DateTime)
    end

    def identity_server_url(arg=nil)
      set_or_return(:identity_server_url, arg,
                    :kind_of => String)
    end

    def client_name(arg=nil)
      set_or_return(:client_name, arg,
                    :kind_of => String)
    end


    def authentication_header
      {"Authorization" => "Bearer #{access_token}"}
    end

    def to_hash
      {
        'access_token' => access_token,
        'token_type' => token_type,
        'refresh_token' => refresh_token,
        'expiry' => expiry.rfc3339,
        'client_name' => client_name,
        'identity_server_url' => identity_server_url
      }
    end

    def to_json(*a)
      Chef::JSONCompat.to_json(to_hash, *a)
    end

    def to_file(file_name)
      Chef::Log.debug("Saving token to #{file_name}")
      dir = ::File.dirname(file_name)
      ::FileUtils.mkdir_p(dir)
      #object = to_json
      File.open(file_name, "w") do |newfile|
        newfile.puts Chef::JSONCompat.to_json_pretty(self)
        newfile.flush
      end
    end

    def to_s
      "token[#{@access_token}]"
    end

    def inspect
      "ChefAnalytics::Token access_token:'#{access_token}' token_type:'#{token_type}' " +
        "refresh_token:'#{refresh_token}' expiry:'#{expiry.rfc3339}'"
    end

    def expired?
      @expiry < DateTime.now
    end

    def valid?
      !expired?
    end

    #
    # Class methods
    #
    def self.from_file(filename)
      if File.exists?(filename) && File.readable?(filename)
        contents = IO.read(filename)
        ChefAnalytics::Token.from_json(contents)
      else
        raise IOError, "Cannot open or read #{filename}!"
      end
    end

    def self.from_json(json)
      ChefAnalytics::Token.from_hash(Chef::JSONCompat.from_json(json))
    end

    def self.from_hash(hash)
      token = ChefAnalytics::Token.new
      token.access_token hash['access_token']
      token.token_type hash['token_type']
      token.refresh_token hash['refresh_token']
      if hash.has_key?('expires_in')
        token.expiry DateTime.now + Rational(hash['expires_in'],86400)
      else
        token.expiry DateTime.rfc3339(hash['expiry'])
      end
      token.identity_server_url hash['identity_server_url'] if hash['identity_server_url']
      token.client_name hash['client_name'] if hash['client_name']
      token
    end

    class << self
      alias_method :json_create, :from_json
    end
  end
end
