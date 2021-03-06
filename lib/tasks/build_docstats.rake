require_relative '../task_helpers/docstats.rb'
require_relative '../task_helpers/project.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do
      
        desc "Generar el archivo de estadística de '#{document[:pathname]}'"
        task :docstats do |t|
            Rake::Task["#{document[:namespace_prefix]}build:html"].invoke
            html_output_document = open(document[:output_pathnames][:html])
            docstats = Docstats::get_document_stats(html_output_document)
            Docstats.generate_docstats_document(docstats, document[:docstats_pathname])
        end
    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar el archivo de estadísticas de todos los documentos del proyecto'
            task :docstats => "#{document[:namespace_prefix]}build:docstats"

        end
    end
end