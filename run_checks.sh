#!/bin/bash

echo "Running Brakeman..."
bin/brakeman --no-pager

echo "Running Importmap audit..."
bin/importmap audit

echo "Running Rubocop..."
bin/rubocop -f github

echo "Running ERB lint..."
./bin/erblint ./app/**/*.erb

echo "Running RSpec tests..."
bundle exec rspec
