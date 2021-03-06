require_relative '../task_helpers/project.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión en PDF de '#{document[:pathname]}'"
        task :pdf => [ document[:output_pathnames][:pdf] ]

        file document[:output_pathnames][:pdf] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_pdf_opts]
            sh "asciidoctor", '--backend', 'pdf',
                              '--require', 'asciidoctor-pdf',
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:pdf]}",
                              *asciidoctor_opts,
                              '--out-file', t.name, t.prerequisites.first()
        end

    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión en PDF de todos los documentos del proyecto'
            task :pdf => "#{document[:namespace_prefix]}build:pdf"

        end
    end
end