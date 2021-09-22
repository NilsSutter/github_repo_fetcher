require_relative "../base"
require_relative "../../repositories/api_requester"

module Services
  module Github
    class Repository < Base
      BASE_URL = "https://api.github.com/search".freeze

      def initialize
        @api = Repositories::ApiRequester.new
      end

      def fetch_all(search_term)
        url = "#{BASE_URL}/repositories?q=#{search_term}&sort=stars&per_page=10"
        headers = { "accept": "application/vnd.github.v3+json" }

        interpret_response(@api.get(url, headers))
      rescue Repositories::ApiError
        failure(:server)
      end

      private

      # rubocop:disable Metrics/MethodLength
      def interpret_response(response)
        response_body = response.body

        case response.status
        when 200..299
          success(response_body.fetch("items", []))
        when 400
          failure(:malformed_request)
        when 403
          failure(:unauthorized)
        when 404..499
          failure(:third_party_config_issue)
        when 500..599
          failure(:server)
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
