require 'html-proofer'
require 'nokogiri'
require 'tempfile'

require_relative './config.rb'

module Tests

    module HTMLProofer

        def htmlproofer(pathname)
            htmlproofer_opts = {
                disable_external: ENV.key?('HTMLPROOFER_DISABLE_EXTERNAL'),
                typhoeus: {
                    headers: {
                        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0",
                    },
                    ssl_verifyhost: 0,
                    ssl_verifypeer: false
                }
            }
            htmlproofer_opts.merge! CONFIG[:htmlproofer_opts]
            Tempfile.create do |f|
                htmlproofer_opts[:typhoeus][:cookiefile] = f.path()
                htmlproofer_opts[:typhoeus][:cookiejar] = f.path()
                ::HTMLProofer.check_directory(pathname, htmlproofer_opts).run
            end
        end
        module_function :htmlproofer
        
    end

    def find_missing_variables(string_or_io)
        document = Nokogiri::HTML.parse(string_or_io)
        # Ignorar bloques stem: <div class='stemblock'> o \$texto\$
        variables = document.xpath('//body//text()[not(ancestor::div[@class="stemblock"])]').flat_map do |text|
            text.content.gsub(/\\\$.*?\\\$/, "").scan(/\{[\w-]+\}/)
        end

        return variables.uniq.sort
    end
    module_function :find_missing_variables

end