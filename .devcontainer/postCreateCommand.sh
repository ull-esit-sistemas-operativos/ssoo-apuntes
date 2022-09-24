#!/bin/sh
bundle config set --local path.system true
bundle config set --local build.nokogiri --use-system-libraries
bundle config set --local without epub3
bundle install