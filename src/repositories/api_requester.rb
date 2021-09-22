require "faraday"
require "json"

module Repositories
  class ApiError < StandardError; end

  class ApiRequester
    def get(url, headers = {})
      raw_response = connection.get(url) do |req|
        req.headers = default_headers.merge(headers)
      end

      OpenStruct.new(status: raw_response.status, body: parsed_body(raw_response.body))
    rescue Faraday::Error
      raise ApiError
    end

    private

    def connection
      Faraday.new do |connection|
        connection.request :retry, retry_options
      end
    end

    def retry_options
      {
        max: 2,
        interval: 0.05,
        interval_randomness: 0.5,
        backoff_factor: 2
      }
    end

    def default_headers
      {
        "Content-Type" => "application/json"
      }
    end

    def parsed_body(json_body)
      JSON.parse(json_body)
    rescue JSON::ParserError
      {}
    end
  end
end
