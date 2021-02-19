require 'json'
require 'nokogiri'
require 'rake'
require 'tempfile'

require_relative './config.rb'

module Tests

    module HTMLProofer

        def get_typhoeus_config()
            cookie_file = Tempfile.create()
            return {
                :cookiefile => cookie_file.path(),
                :cookiejar => cookie_file.path(),
                :headers => {
                    "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0",
                },
                :ssl_verifyhost => 0,
                :ssl_verifypeer => false,
            }.to_json
        end
        module_function :get_typhoeus_config

        def htmlproofer(pathname)
            htmlproofer_opts = CONFIG[:htmlproofer_opts]
            Rake::FileUtilsExt.sh "htmlproofer", "--typhoeus_config", get_typhoeus_config(), *htmlproofer_opts, pathname
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