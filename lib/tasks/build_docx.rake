require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en DOCX de '#{document[:pathname]}' (requiere Pandoc)"
        task :docx => [ document[:output_pathnames][:docx] ]

        file document[:output_pathnames][:docx] => [:docbook, document[:output_directories][:docx]] do |t|
            pandoc_opts = CONFIG[:pandoc_docx_opts]
            sh "pandoc", '--from', 'docbook',
                         '--to', 'docx',
                         '--resource-path', document[:output_directories][:docbook],
                         *pandoc_opts,
                         '--output', t.name, document[:output_pathnames][:docbook]
        end

        directory document[:output_directories][:docx]

        task :docbook => [ document[:output_pathnames][:docbook], :docbook_media_files ]

        task :docbook_media_files do |t|
            Utils.copy_files(document[:media_files], document[:output_directories][:docbook], document[:source_directory]) 
        end
 
        file document[:output_pathnames][:docbook] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_docbook_opts]
            sh "asciidoctor", '--backend', 'docbook',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:docbook]}",
                              *asciidoctor_opts,
                              '--out-file', t.name, t.prerequisites.first()
        end

    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión en DOCX de todos los documentos del proyecto'
            task :docx => "#{document[:namespace_prefix]}build:docx"

        end
    end
end