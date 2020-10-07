require "nokogiri"

READING_SPEED_IN_WORDS_PER_MINUTE = 200

PROJECT_DIR = Rake.application.original_dir

CONTENT_DIR = File.join(PROJECT_DIR, "content")
CONFIG_DIR = File.join(PROJECT_DIR, "config")
OUTPUT_DIR = File.join(PROJECT_DIR, "output")

DOCUMENT_MAIN_FILE = File.join(CONTENT_DIR, "main.adoc")
DOCSTATS_FILE = File.join(CONTENT_DIR, "docstats.adoc")

INCLUDED_FILES = FileList[File.join(CONTENT_DIR, "**/*.adoc"),
                          File.join(CONFIG_DIR, "**/*.adoc"),
                          File.join(CONFIG_DIR, "**/*.yml")
                        ].exclude(DOCUMENT_MAIN_FILE)

MEDIA_FILES = FileList[File.join(CONTENT_DIR, "**/images/**", "*.jpg"),
                       File.join(CONTENT_DIR, "**/images/**", "*.png"),
                       File.join(CONTENT_DIR, "**/images/**", "*.svg")]

OUTPUT_HTML_FILE = File.join(OUTPUT_DIR, "html", "index.html")
OUTPUT_HTML_DIR = File.dirname(OUTPUT_HTML_FILE)

OUTPUT_PDF_FILE = File.join(OUTPUT_DIR, "pdf", "sistemas-operativos.pdf")
OUTPUT_PDF_DIR = File.dirname(OUTPUT_PDF_FILE)

OUTPUT_EPUB_FILE = File.join(OUTPUT_DIR, "epub", "sistemas-operativos.epub")
OUTPUT_EPUB_DIR = File.dirname(OUTPUT_EPUB_FILE)

task :default => :build
task :build => [:docstats, :html]

desc 'Generar la versión en HTML de la documentación'
task :html => [OUTPUT_HTML_FILE, :html_media_files]

file OUTPUT_HTML_FILE => [OUTPUT_HTML_DIR, DOCUMENT_MAIN_FILE, *INCLUDED_FILES] do |t|
    sh "asciidoctor", "--backend", "html5", DOCUMENT_MAIN_FILE, "-o", t.name
end

file :html_media_files => OUTPUT_HTML_DIR do |t|
    MEDIA_FILES.each do |source|
        relative_part = source.dup
        relative_part.slice! CONTENT_DIR
        destination = File.join(OUTPUT_HTML_DIR, relative_part)
        destination_dir = File.dirname(destination)

        if File.exist? destination
            next if [File.ctime(source), File.mtime(source)].max <= \
                [File.ctime(destination), File.mtime(destination)].max
        end
        mkdir_p destination_dir
        cp_r source, destination
    end
end

directory OUTPUT_HTML_DIR

desc 'Generar la versión en PDF de la documentación'
task :pdf => OUTPUT_PDF_FILE

file OUTPUT_PDF_FILE => [OUTPUT_PDF_DIR, DOCUMENT_MAIN_FILE, *INCLUDED_FILES] do |t|
    sh "asciidoctor", "--require", "asciidoctor-pdf", "--backend", "pdf", DOCUMENT_MAIN_FILE, "-o", t.name
end

directory OUTPUT_PDF_DIR

desc 'Generar la versión en EPUB de la documentación'
task :epub => OUTPUT_EPUB_FILE

file OUTPUT_EPUB_FILE => [OUTPUT_EPUB_DIR, DOCUMENT_MAIN_FILE, *INCLUDED_FILES]  do |t|
    sh "asciidoctor", "--require", "asciidoctor-epub3", "--backend", "epub3", DOCUMENT_MAIN_FILE, "-o", t.name
end

directory OUTPUT_EPUB_DIR

desc 'Ejecutar los tests'
task :tests => :html do |t|
    typhoeus_config = '{"ssl_verifyhost": 0, "ssl_verifypeer": false}'
    sh "htmlproofer", "--typhoeus_config", typhoeus_config, OUTPUT_HTML_DIR
end

desc 'Limpiar todos los archivos generados'
task :clean do |t|
    rm_r OUTPUT_DIR
end

desc 'Generar el archivo de información estadística'
task :docstats do |t|
    # Contamos las palabras en la versión HTML del documento
    output_html = `asciidoctor --backend html5 #{DOCUMENT_MAIN_FILE} -o -`
    docstats = open(DOCSTATS_FILE, "w")

    document = Nokogiri::HTML.parse(output_html)
    document.css(".sect1 > h2 + .sectionbody").each do |sectionbody|
        if matches = /^(?<chapter_number>\d+)\. /.match(sectionbody.previous_element)
            chapter_number = matches['chapter_number'] 
            
            wordcount = sectionbody.text().scan(/[\p{Alnum}\-']+/).length()
            reading_time = (wordcount.to_f / READING_SPEED_IN_WORDS_PER_MINUTE).round

            # Construir la cadena de texto con el tiempo de lectura
            if reading_time == 1
                reading_time_string = "1 minuto"
            elsif reading_time < 60
                reading_time_string = "#{reading_time} minutos"
            elsif reading_time == 60
                reading_time_string = "1 hora"
            else
                reading_time_string = "#{reading_time / 60} horas y #{reading_time % 60} minutos"
            end

            docstats.puts ":C%02i_words: %i" % [chapter_number, wordcount]
            docstats.puts ":C%02i_reading_time: %s" % [chapter_number, reading_time_string]

            puts "C%02i: %8i %8i (%s)" % [chapter_number, wordcount, reading_time, reading_time_string]
        end
    end
end
