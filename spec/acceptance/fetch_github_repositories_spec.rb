require_relative "../spec_helper"
require "./src/app"

ENV['RACK_ENV'] = 'test'
describe "Fetch github repositories" do
  include Rack::Test::Methods

  def app
    App
  end

  describe "GET '/v0'" do
    before do
      get "/v0"
    end

    it "is successful" do
      expect(last_response).to be_ok
    end

    it "renders a form" do
      expect(last_response.body).to include("Search for your favourite Github repos")
    end
  end

  describe "GET '/v0/github_repositories'" do
    before do
      get "/v0/github_repositories?repo=node"
    end

    it "is successful" do
      expect(last_response).to be_ok
    end

    it "renders a form" do
      expect(last_response.body).to include("https://github.com/nodejs/node")
    end
  end
end
