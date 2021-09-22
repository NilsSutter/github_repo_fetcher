require_relative "../../spec_helper"
require "./src/services/github/repository"

describe Services::Github::Repository do
  let(:api_requester_mock) { instance_double(Repositories::ApiRequester) }

  describe "#fetch_all" do
    subject(:fetch_github_repos) do
      described_class.new.fetch_all("node")
    end

    let(:response_mock) do
      OpenStruct.new(status: status, body: body)
    end
    let(:body) do
      {
        "items" => [
          { "repo_1" => "nodejs" },
          { "repo_2" => "ruby" }
        ]
      }
    end

    before do
      allow(Repositories::ApiRequester).to receive(:new).and_return(api_requester_mock)
    end

    context "when the API rises no error" do
      before do
        allow(api_requester_mock).to receive(:get).and_return(response_mock)
      end

      context "when the API returns a response with status 2xx" do
        let(:status) { 200 }

        it "returns a Services::Success" do
          expect(fetch_github_repos).to be_a(Services::Success)
        end

        it "returns the repositories" do
          expect(fetch_github_repos.value).to eq(body["items"])
        end

        context "when the API response does not contain a 'items' key" do
          let(:body) { {} }

          it "returns a Services::Success" do
            expect(fetch_github_repos).to be_a(Services::Success)
          end

          it "returns an empty array repositories" do
            expect(fetch_github_repos.value).to eq([])
          end
        end
      end

      context "when the API returns an error status code" do
        error_cases = [
          OpenStruct.new(status: 400, error_key: :malformed_request),
          OpenStruct.new(status: 403, error_key: :unauthorized),
          OpenStruct.new(status: 422, error_key: :third_party_config_issue),
          OpenStruct.new(status: 500, error_key: :server)
        ]

        error_cases.each do |test_case|
          context "when the status code is #{test_case.status}" do
            let(:status) { test_case.status }

            it "returns a Services::Failure" do
              expect(fetch_github_repos).to be_a(Services::Failure)
            end

            it "returns the right error code" do
              expect(fetch_github_repos.error_key).to be(test_case.error_key)
            end
          end
        end
      end
    end

    context "when the API rises an error" do
      let(:api_error) { instance_double(Repositories::ApiError) }

      before do
        allow(api_requester_mock).to receive(:get).and_raise(Repositories::ApiError)
      end

      it "returns a Services::Failure" do
        expect(fetch_github_repos).to be_a(Services::Failure)
      end

      it "returns a :server error key" do
        expect(fetch_github_repos.error_key).to be(:server)
      end
    end
  end
end
