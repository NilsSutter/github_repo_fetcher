require "sinatra"
require_relative "./services/github/repository"
require_relative "./lib/presentation_error"

class App < Sinatra::Base
  get "/v0" do
    erb :github_repository_form
  end

  get "/v0/github_repositories" do
    search_term = params["repo"]
    github_result = Services::Github::Repository.new.fetch_all(search_term)

    handle_error(github_result.error_key) if github_result.is_a?(Services::Failure)

    @repos = github_result.value
    erb :show_repositories
  end

  error 404 do
    handle_error(404, :not_found)
  end

  error 500 do
    handle_error(500, :server)
  end

  private

  def handle_error(error_key, status = 422)
    @error = PresentationError.new(error_key)
    halt(status, erb(:error))
  end
end
