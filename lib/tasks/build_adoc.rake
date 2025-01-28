require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en AsciiDoc de '#{document[:pathname]}'"
        task :adoc => [ document[:output_pathnames][:adoc], :adoc_media_files ]

        file document[:output_pathnames][:adoc] => [*document[:dependencies], :config] do |t|
            asciidoctor_args = CONFIG[:asciidoctor_args] + CONFIG[:asciidoctor_adoc_args]
            if Utils::EnvVar.new('HTML_COMMENTS_ENABLED').to_boolean
                asciidoctor_args += ['--attribute', 'comments_enabled=true']
            end
            
            sh "asciidoctor-reducer", '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:adoc]}",
                              *asciidoctor_args,
                              '--output', t.name, t.prerequisites.first()
        end

        task :adoc_media_files do |t|
           Utils.copy_files(document[:media_files], document[:output_directories][:adoc], document[:source_directory]) 
        end

    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión en AsciiDoc de todos los documentos del proyecto'
            task :adoc => "#{document[:namespace_prefix]}build:adoc"

        end
    end
end