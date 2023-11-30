require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en DOCX de '#{document[:pathname]}' (requiere Pandoc)"
        task :docx => [ document[:output_pathnames][:docx] ]

        directory document[:output_directories][:docx]

        file document[:output_pathnames][:docx] => [:docbook, document[:output_directories][:docx]] do |t|
            pandoc_opts = CONFIG[:pandoc_docx_args]
            sh "pandoc", '--from', 'docbook',
                         '--to', 'docx',
                         '--resource-path', document[:output_directories][:docbook],
                         *pandoc_opts,
                         '--output', t.name, document[:output_pathnames][:docbook]
        end
    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión en DOCX de todos los documentos del proyecto'
            task :docx => "#{document[:namespace_prefix]}build:docx"

        end
    end
end