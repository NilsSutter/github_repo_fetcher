# github_repo_fetcher

This is a simple application to play around with different architectures and fetchig Github repositories. 
This application's architecture is inspired by frameworks such as Nest.js (Typescript) and Hanami (Ruby).

It contains of an API layer, which wraps around Faraday and its single purpose is to fetch raw data. 
This data will then correspondingly be handled by the Services layer, whose purpose is currently to built the request, interpret the response and return a corresponding service result.

If there would be any specific business logic, another usecase layer could be wrapped around the services.

To run this application, you only need to have installed `Docker` and `docker compose`.

## Technology stack
Framework: Sinatra (Ruby)
Test framework: RSpec
Linting: Rubocop
Containerization: Docker

This sample application was written with Sinatra. The reason is that it contains of 2 very simple endpoints and thus, no heavy framework like Rails is needed for this.

## Setup instructions
1. To build the image, run: `./bin/setup.sh`
2. To start the server locally, run: `./bin/start.sh`
3. To lint the source code, run: `./bin/lint.sh`
4. To run the test suite, run: `./bin/test.sh`
