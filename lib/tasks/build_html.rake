require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en HTML de '#{document[:pathname]}'"
        task :html => [ document[:output_pathnames][:html], :html_media_files ]

        file document[:output_pathnames][:html] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_html_opts]
            sh "asciidoctor", '--backend', 'html5',
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:html]}",
                              *asciidoctor_opts,
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