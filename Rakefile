PROJECT_DIR = Rake.application.original_dir

CONTENT_DIR = File.join(PROJECT_DIR, "content")
CONFIG_DIR = File.join(PROJECT_DIR, "config")
SCRIPTS_DIR = File.join(PROJECT_DIR, "scripts")
OUTPUT_DIR = File.join(PROJECT_DIR, "output")

INPUT_FILES = FileList[File.join(CONTENT_DIR, "**/*.adoc")]
CONFIG_FILES = FileList[File.join(CONFIG_DIR, "**/*.adoc"),
                        File.join(CONFIG_DIR, "**/*.yml")]
MEDIA_DIRS = FileList[File.join(CONTENT_DIR, "**/images")]

OUTPUT_HTML_FILE = File.join(OUTPUT_DIR, "html", "index.html")
OUTPUT_HTML_DIR = File.dirname(OUTPUT_HTML_FILE)

OUTPUT_PDF_FILE = File.join(OUTPUT_DIR, "pdf", "sistemas-operativos.pdf")
OUTPUT_PDF_DIR = File.dirname(OUTPUT_PDF_FILE)

OUTPUT_EPUB_FILE = File.join(OUTPUT_DIR, "epub", "sistemas-operativos.epub")
OUTPUT_EPUB_DIR = File.dirname(OUTPUT_EPUB_FILE)

DOCUMENT_MAIN_FILE = File.join(CONTENT_DIR, "main.adoc")
DOCSTATS_FILE = File.join(CONTENT_DIR, "docstats.adoc")

task :default => :html

desc 'Generar la versión en HTML de la documentación'
task :html => [:html_only, :html_media_files]
task :html_only => OUTPUT_HTML_FILE

file OUTPUT_HTML_FILE => [OUTPUT_HTML_DIR, *INPUT_FILES, *CONFIG_FILES] do |t|
    sh "asciidoctor", "--backend", "html5", DOCUMENT_MAIN_FILE, "-o", t.name
end

file :html_media_files => OUTPUT_HTML_DIR do |t|
    MEDIA_DIRS.each do |source|
    source_relative_path = source.dup
    source_relative_path.slice! CONTENT_DIR

    destination_dir = File.dirname(File.join(OUTPUT_HTML_DIR, source_relative_path))
    mkdir_p destination_dir
    
    cp_r source, destination_dir
    end
end

directory OUTPUT_HTML_DIR

desc 'Generar la versión en PDF de la documentación'
task :pdf => OUTPUT_PDF_FILE

file OUTPUT_PDF_FILE => [OUTPUT_PDF_DIR, *INPUT_FILES, *CONFIG_FILES] do |t|
    sh "asciidoctor", "--require", "asciidoctor-pdf", "--backend", "pdf", DOCUMENT_MAIN_FILE, "-o", t.name
end

directory OUTPUT_PDF_DIR

desc 'Generar la versión en EPUB de la documentación'
task :epub => OUTPUT_EPUB_FILE

file :epub => [OUTPUT_EPUB_DIR, *INPUT_FILES, *CONFIG_FILES]  do |t|
    sh "asciidoctor", "--require", "asciidoctor-epub3", "--backend", "epub3", DOCUMENT_MAIN_FILE, "-o", t.name
end

directory OUTPUT_EPUB_DIR

desc 'Generar el archivo de información estadística'
task :docstats => :html_only do |t|
    docstats_bin = File.join(SCRIPTS_DIR, "update-docstats")
    sh docstats_bin, CONTENT_DIR, DOCSTATS_FILE
end

desc 'Ejecutar los tests'
task :tests => :html do |t|
    typhoeus_config = '{"ssl_verifyhost": 0, "ssl_verifypeer": false}'
    sh "htmlproofer", "--typhoeus_config", typhoeus_config, OUTPUT_HTML_DIR
end

desc 'Limpiar todos los archivos generados'
task :clean do |t|
    rm_r OUTPUT_DIR
end