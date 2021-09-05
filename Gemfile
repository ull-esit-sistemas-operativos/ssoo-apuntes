# frozen_string_literal: true

source "https://rubygems.org"

gem "rake"
gem "asciidoctor"
gem "rouge"

group :docstats do
    gem "nokogiri"
end

group :html5 do
    gem "asciidoctor-multipage", git: "https://github.com/aplatanado/asciidoctor-multipage"
end

group :pdf do
    gem "asciidoctor-mathematical"
    gem "asciidoctor-pdf"
end

group :epub3 do
    gem "asciidoctor-epub3"
end

group :test do
    gem "nokogiri"
    gem "html-proofer"
end