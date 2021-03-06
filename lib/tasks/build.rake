require_relative '../task_helpers/project.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        task :default => [:docstats, :all]

        desc "Generar todas las versiones de '#{document[:pathname]}'"
        task :all => [:html, :pdf, :epub]

    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar todas las versiones de todos los documentos del proyecto'
            task :all => "#{document[:namespace_prefix]}build:all"

        end
    end
end