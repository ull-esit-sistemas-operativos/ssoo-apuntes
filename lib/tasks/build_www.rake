require 'uri'

require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        desc "Generar la versión sitio web de '#{document[:pathname]}'"
        task :www, [:site_root] => [
                document[:output_pathnames][:www], :www_media_files, :www_index, :www_sitemap ] do |t, args|
        end

        file document[:output_pathnames][:www] => [*document[:dependencies], :config] do |t, args|
            asciidoctor_args = CONFIG[:asciidoctor_args] + CONFIG[:asciidoctor_html_args]
            if Utils::EnvVar.new('HTML_COMMENTS_ENABLED').to_boolean
                asciidoctor_args += ['--attribute', 'comments_enabled=true']
            end

            sh "asciidoctor", '--backend', 'multipage_html5',
                              '--require', 'asciidoctor-multipage',
                              '--require', './lib/time-admonition-block.rb',
                              '--require', './lib/autoxref-treeprocessor.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:www]}",
                              *asciidoctor_args,
                              '--destination-dir', document[:output_directories][:www], t.prerequisites.first()
        end

        task :www_media_files do |t|
           Utils.copy_files(document[:media_files], document[:output_directories][:www], document[:source_directory]) 
        end

        task :www_index do |t|
            open(File.join(document[:output_directories][:www], 'index.html'), 'w') do |f|
            f << <<~EOF
                <!DOCTYPE HTML>                                                                
                <html lang="es">                                                                
                    <head>                                                                      
                        <meta charset="utf-8">
                        <meta http-equiv="refresh" content="0;url=main.html">      
                        <link rel="canonical" href="main.html">                    
                    </head>                                                                                                                                                                  
                </html>
            EOF
            end
        end

        task :www_sitemap, [:site_root] do |t, args|
            args.with_defaults(:site_root => CONFIG[:site_root])
            
            output_directory = document[:output_directories][:www]
            open(File.join(output_directory, 'sitemap.xml'), 'w') do |f|
                f << <<~EOF
                    <?xml version="1.0" encoding="UTF-8"?>
                    <urlset
                        xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
                                http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
                EOF
                
                now = Time.now.iso8601
                Dir.glob('*.html', base: output_directory).each do |filename|
                    f << <<~EOF
                        <url>
                            <loc>#{URI.parse([args.site_root, URI.encode_www_form_component(filename)].join('/'))}</loc>
                            <lastmod>#{now}</lastmod>
                            <priority>#{filename == 'main.html' ? 1.0 : 0.5}</priority>
                        </url>
                    EOF
                end
    
                f << <<~EOF
                    </urlset>
                EOF
            end
        end
    end

    if ! document[:namespace_prefix].empty?
        namespace :build do

            desc 'Generar la versión sitio web de todos los documentos del proyecto'
            task :www => "#{document[:namespace_prefix]}build:www"

        end
    end
end