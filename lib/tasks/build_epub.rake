require_relative '../task_helpers/project.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en EPUB de '#{document[:pathname]}'"
        task :epub => [ document[:output_pathnames][:epub] ]

        file document[:output_pathnames][:epub] => [*document[:dependencies], :config] do |t|
            asciidoctor_args = CONFIG[:asciidoctor_args] + CONFIG[:asciidoctor_epub_args]
            sh "asciidoctor", '--backend', 'epub3',
                              '--require', 'asciidoctor-epub3',
                              '--require', './lib/time-admonition-block.rb',
                              '--require', './lib/autoxref-treeprocessor.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:epub]}",
                              *asciidoctor_args,
                              '--out-file', t.name, t.prerequisites.first()
        end

    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión en EPUB de todos los documentos del proyecto'
            task :epub => "#{document[:namespace_prefix]}build:epub"

        end
    end
end