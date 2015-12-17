module ChefAnalytics
  module Exception
    class FetchTokenException < StandardError
      def initialize(msg = "Couldn't get OAuth2 token from OC-ID server.")
        super
      end
    end
  end
end
