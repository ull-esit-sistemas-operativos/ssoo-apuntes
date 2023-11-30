require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en DOCBOOK de '#{document[:pathname]}'"
        task :docbook => [ document[:output_pathnames][:docbook], :docbook_media_files ]

        task :docbook_media_files do |t|
            Utils.copy_files(document[:media_files], document[:output_directories][:docbook], document[:source_directory]) 
        end
 
        file document[:output_pathnames][:docbook] => [*document[:dependencies], :config] do |t|
            asciidoctor_args = CONFIG[:asciidoctor_args] + CONFIG[:asciidoctor_docbook_args]
            sh "asciidoctor", '--backend', 'docbook',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:docbook]}",
                              *asciidoctor_args,
                              '--out-file', t.name, t.prerequisites.first()
        end

    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión en DOCBOOK de todos los documentos del proyecto'
            task :docbook => "#{document[:namespace_prefix]}build:docbook"

        end
    end
end