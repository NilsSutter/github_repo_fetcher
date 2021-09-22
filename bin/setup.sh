#!/bin/bash

docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.7.1 bundle install
# docker build --tag github_repo_fetcher .
docker-compose build
