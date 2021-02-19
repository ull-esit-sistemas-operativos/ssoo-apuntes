require 'rake/clean'

require_relative '../task_helpers/config.rb'
require_relative '../task_helpers/docstats.rb'
require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/tests.rb'
require_relative '../task_helpers/utils.rb'

task :config

Project::find_documents().each do |document|
    namespace "#{document[:namespace_prefix]}build" do
        task :default => [:docstats, :html]

        desc "Generar todas las versiones de '#{document[:pathname]}'"
        task :all => [:html, :pdf, :epub]

        desc "Generar la versión en HTML de '#{document[:pathname]}'"
        task :html => [ document[:output_pathname][:html], :html_media_files ]

        file document[:output_pathname][:html] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_html_opts]
            sh "asciidoctor", '--backend', 'html5',
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              *asciidoctor_opts,
                              '--out-file', t.name, t.prerequisites.first()
        end

        task :html_media_files do |t|
           Utils.copy_files(document[:media_files], document[:output_directories][:html], document[:source_directory]) 
        end

        desc "Generar la versión en PDF de '#{document[:pathname]}'"
        task :pdf => [ document[:output_pathname][:pdf] ]

        file document[:output_pathname][:pdf] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_pdf_opts]
            sh "asciidoctor", '--backend', 'pdf',
                              '--require', 'asciidoctor-pdf',
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              *asciidoctor_opts,
                              '--out-file', t.name, t.prerequisites.first()
        end

        desc "Generar la versión en EPUB de '#{document[:pathname]}'"
        task :epub => [ document[:output_pathname][:epub] ]

        file document[:output_pathname][:epub] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_epub_opts]
            sh "asciidoctor", '--backend', 'epub3',
                              '--require', 'asciidoctor-epub3',
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              *asciidoctor_opts,
                              '--out-file', t.name, t.prerequisites.first()
        end

        desc "Generar el archivo de estadística de '#{document[:pathname]}'"
        task :docstats do |t|
            Rake::Task["#{document[:namespace_prefix]}build:html"].invoke
            html_output_document = open(document[:output_pathname][:html])
            docstats = Docstats::get_document_stats(html_output_document)
            Docstats.generate_docstats_document(docstats, document[:docstats_pathname])
        end
    end

    namespace :build do
        desc 'Generar la versión en HTML de todos los documentos del proyecto'
        task :html => "#{document[:namespace_prefix]}build:html"

        desc 'Generar la versión en PDF de todos los documentos del proyecto'
        task :pdf => "#{document[:namespace_prefix]}build:pdf"

        desc 'Generar la versión en EPUB de todos los documentos del proyecto'
        task :epub => "#{document[:namespace_prefix]}build:epub"

        desc 'Generar el archivo de estadísticas de todos los documentos del proyecto'
        task :docstats => "#{document[:namespace_prefix]}build:docstats"
    end

    namespace "#{document[:namespace_prefix]}tests" do
        task :default => :all

        desc "Ejecutar todos los tests sobre '#{document[:pathname]}'"
        task :all => [:missing_variables, :htmlproofer]
    
        desc "Ejecutar el test de HTMLProofer sobre '#{document[:pathname]}'"
        task :htmlproofer => 'build:html' do |t|
            Tests::HTMLProofer::htmlproofer document[:output_directories][:html]
        end
    
        desc "Ejecutar el test de variables no definidas sobre '#{document[:pathname]}'"
        task :missing_variables => document[:output_pathname][:html] do |t|
            missing = Tests::find_missing_variables(open(t.prerequisites.first()))
            fail "Se han encontrado #{missing.size} variables no definidas:\n#{missing.join("\n")}" unless missing.empty?
        end
    end

    namespace :tests do

        desc 'Ejecutar todos los tests en todos los documentos del proyecto'
        task :all => "#{document[:namespace_prefix]}tests:all"

        desc 'Ejecutar el test de HTMLProofer en todos los documentos del proyecto'
        task :htmlproofer => "#{document[:namespace_prefix]}tests:htmlproofer"

        desc 'Ejecutar el test de variables no definidas en todos los documentos del proyecto'
        task :missing_variables => "#{document[:namespace_prefix]}tests:missing_variables"

    end

    # Tareas de limpieza
    CLOBBER.include(document[:output_directory])
end