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

require 'chef-analytics/identity'
require 'chef-analytics/exception//fetch_token_failure'

module ChefAnalytics
  module TokenManager
    def fetch_token(options = {})
      identity = get_identity_object(options)
      token = identity.token
      raise ChefAnalytics::Exception::FetchTokenException if token.nil?
      token
    end

    def get_identity_object(options)
      ChefAnalytics::Identity.new(options)
    end
  end
end
