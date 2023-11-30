require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en Markdown de '#{document[:pathname]}' (requiere Pandoc)"
        task :markdown => [ document[:output_pathnames][:markdown] ]

        directory document[:output_directories][:markdown]

        file document[:output_pathnames][:markdown] => [:docbook, document[:output_directories][:markdown]] do |t|
            pandoc_opts = CONFIG[:pandoc_markdown_args]
            sh "pandoc", '--from', 'docbook',
                         '--to', 'markdown',
                         '--resource-path', document[:output_directories][:docbook],
                         *pandoc_opts,
                         '--output', t.name, document[:output_pathnames][:docbook]
        end
    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión en Markdown de todos los documentos del proyecto'
            task :markdown => "#{document[:namespace_prefix]}build:markdown"

        end
    end
end