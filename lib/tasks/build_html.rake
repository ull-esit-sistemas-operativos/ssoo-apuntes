require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en HTML de '#{document[:pathname]}'"
        task :html => [ document[:output_pathnames][:html], :html_media_files ]

        file document[:output_pathnames][:html] => [*document[:dependencies], :config] do |t, args|
            asciidoctor_args = CONFIG[:asciidoctor_args] + CONFIG[:asciidoctor_html_args]
            backend_args = ENV.key?("HTML_MULTIPAGE") ? [
                    '--backend', 'multipage_html5',
                    '--require', 'asciidoctor-multipage'
                ] : [
                    '--backend', 'html5'
                ]
            sh "asciidoctor", *backend_args,
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:html]}",
                              *asciidoctor_args,
                              '--out-file', t.name, t.prerequisites.first()
        end

        task :html_media_files do |t|
           Utils.copy_files(document[:media_files], document[:output_directories][:html], document[:source_directory]) 
        end

    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión en HTML de todos los documentos del proyecto'
            task :html => "#{document[:namespace_prefix]}build:html"

        end
    end
end