require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/tests.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}tests" do
        task :default => :all

        desc "Ejecutar todos los tests sobre '#{document[:pathname]}'"
        task :all => [:missing_variables, :htmlproofer]
    
        desc "Ejecutar el test de HTMLProofer sobre '#{document[:pathname]}'"
        task :htmlproofer => 'build:html' do |t|
            Tests::HTMLProofer::htmlproofer document[:output_directories][:html]
        end
    
        desc "Ejecutar el test de variables no definidas sobre '#{document[:pathname]}'"
        task :missing_variables => document[:output_pathnames][:html] do |t|
            missing = Tests::find_missing_variables(open(t.prerequisites.first()))
            fail "Se han encontrado #{missing.size} variables no definidas:\n#{missing.join("\n")}" unless missing.empty?
        end
    end

    if ! document[:namespace_prefix].empty?
        namespace :tests do

            desc 'Ejecutar todos los tests en todos los documentos del proyecto'
            task :all => "#{document[:namespace_prefix]}tests:all"

            desc 'Ejecutar el test de HTMLProofer en todos los documentos del proyecto'
            task :htmlproofer => "#{document[:namespace_prefix]}tests:htmlproofer"

            desc 'Ejecutar el test de variables no definidas en todos los documentos del proyecto'
            task :missing_variables => "#{document[:namespace_prefix]}tests:missing_variables"

        end
    end
end