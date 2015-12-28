#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/http'
require 'chef/http/remote_request_id'
require 'chef/http/json_output'
require 'chef-analytics/http/token_authenticator'
require 'chef-analytics/http/full_response'

module ChefAnalytics
  class ServerAPI < Chef::HTTP
    attr_accessor :url, :authentication_token

    def initialize(url, token, options = {})
      options = options.dup
      options[:authentication_token] = token
      super(url, options)

      @authenticator = ChefAnalytics::HTTP::TokenAuthenticator.new(options)
      @request_id = Chef::HTTP::RemoteRequestID.new(options)

      @middlewares << ChefAnalytics::HTTP::FullResponse.new(options)
      @middlewares << Chef::HTTP::JSONOutput.new(options)
      @middlewares << @authenticator
      @middlewares << @request_id
    end

    def authentication_token
      authenticator.token
    end
  end
end
