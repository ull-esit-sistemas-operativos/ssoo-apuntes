require 'nokogiri'

module Docstats

    READING_SPEED_IN_WORDS_PER_MINUTE = 200

    def format_reading_time(minutes)
        hours = minutes / 60
        minutes = minutes % 60

        if hours == 0
            formatted_string = ""
        elsif hours == 1
            formatted_string = "1 hora"
        else
            formatted_string = "#{hours} horas"
        end

        if minutes > 0
            formatted_string += " y "
        end

        if minutes == 1
            formatted_string += "#{minutes} minuto"
        else
            formatted_string += "#{minutes} minutos"
        end

        return formatted_string
    end
    module_function :format_reading_time

    def get_body_stats(element)
        character_count = element.text().gsub(/\s/, "").length()
        word_count = element.text().scan(/[\p{Alnum}\-']+/).length()
        paragraph_count = element.css('.paragraph').length()

        reading_time = (word_count.to_f / READING_SPEED_IN_WORDS_PER_MINUTE).round
 
        return {
            :characters => character_count,
            :words => word_count,
            :paragraphs => paragraph_count,
            :reading_time => reading_time,
        }
    end
    module_function :get_body_stats

    def get_section_stats(section)
        sectionbody = section.at_css('.sectionbody')
        stats = get_body_stats(sectionbody)

        if ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'].include? sectionbody.previous_element&.name
            heading = sectionbody.previous_element
            stats[:id] = heading[:id]
            if matches = /^(?<section_number>[0-9.]+)\. /.match(heading.text())
                stats[:section_number] = matches['section_number']
            end
        end

        return stats
    end
    module_function :get_section_stats

    def get_document_stats(string_or_io)
        document = Nokogiri::HTML.parse(string_or_io)
        document_stats =  get_body_stats(document.css('#content'))

        document_stats[:sections] = document.css(".sect1").map do |section|
            get_body_stats(section)
        end

        return document_stats
    end
    module_function :get_document_stats

    def generate_docstats_document(document_stats, output_pathname)
        output_content = <<~EOF
        :document-characters: #{document_stats[:characters]}
        :document-words: #{document_stats[:words]}
        :document-paragraphs: #{document_stats[:paragraphs]}
        :document-reading-time: #{format_reading_time(document_stats[:reading_time])}
        EOF

        output_content += document_stats[:sections].map do |stats|
            next unless not stats[:sec1tion_number].nil?
            section_number = "%02i" % stats[:sec1tion_number]
            <<~EOF
            :S#{section_number}-characters: #{stats[:characters]}
            :S#{section_number}-words: #{stats[:words]}
            :S#{section_number}-paragraphs: #{stats[:paragraphs]}
            :S#{section_number}-reading-time: #{format_reading_time(stats[:reading_time])}
            EOF
        end.join()

        open(output_pathname, 'w') do |file|
            file.write(output_content)
        end
    end
    module_function :generate_docstats_document
    
end