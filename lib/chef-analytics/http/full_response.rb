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

module ChefAnalytics
  class HTTP
    class FullResponse
      attr_accessor :last_response

      def initialize(opts={})
      end

      def handle_request(method, url, headers={}, data=false)
        [method, url, headers, data]
      end

      def handle_response(http_response, rest_request, return_value)
        # Duplicate the full response and the response body so we have access to
        # headers and the response code. This feels like a hack but it is the
        # only way to work around:
        # https://github.com/chef/chef/blob/master/lib/chef/http.rb#L147
        [http_response, rest_request, http_response]
      end

      def stream_response_handler(response)
        nil
      end

      def handle_stream_complete(http_response, rest_request, return_value)
        [http_response, rest_request, http_response]
      end
    end
  end
end
