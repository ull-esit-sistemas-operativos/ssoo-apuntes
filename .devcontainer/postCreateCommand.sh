#!/bin/sh
set -e

sudo apt-get -y update
sudo apt-get -y install --no-install-recommends \
    libxml2-dev libxslt1-dev \
    bison flex libffi-dev libxml2-dev libgdk-pixbuf-2.0-dev libcairo2-dev \
    libpango1.0-dev libwebp-dev libzstd-dev fonts-lyx cmake \
    pandoc

bundle config set --local path.system true
bundle config set --local build.nokogiri --use-system-libraries
bundle config set --local without epub3
bundle install