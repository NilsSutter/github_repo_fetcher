require_relative "../spec_helper"
require "./src/repositories/api_requester"

describe Repositories::ApiRequester do
  let(:faraday_connection_mock) do
    instance_double(Faraday::Connection)
  end
  let(:faraday_request_mock) do
    instance_double(
      Faraday::Request
    )
  end
  let(:faraday_response_mock) do
    instance_double(
      Faraday::Response,
      status: status,
      body: body
    )
  end
  let(:status) { 200 }

  before do
    allow(Faraday).to receive(:new).and_return(faraday_connection_mock)
  end

  describe "#get" do
    subject(:make_get_request) { described_class.new.get(url) }

    let(:url) { "some_url" }

    before do
      allow(faraday_connection_mock).to receive(:get).with(url)
                                                     .and_yield(faraday_request_mock)
      allow(faraday_connection_mock).to receive(:get).with(url)
                                                     .and_return(faraday_response_mock)
    end

    context "when everything is successful" do
      let(:body) { parsed_body.to_json }
      let(:parsed_body) { { "working" => true } }

      it "returns the parsed body" do
        expect(make_get_request.body).to eq(parsed_body)
      end

      it "returns the right status code" do
        expect(make_get_request.status).to eq(faraday_response_mock.status)
      end
    end

    context "when the response body can't be parsed" do
      let(:body) { "invalid JSON" }

      it "returns an empty hash for the body" do
        expect(make_get_request.body).to eq({})
      end
    end
  end
end
