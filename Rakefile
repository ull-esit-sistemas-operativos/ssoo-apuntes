require 'uri'
require 'webrick'

Rake.add_rakelib 'lib/tasks'

task :config do |t|
    CONFIG[:html_multipage] = true
    CONFIG[:asciidoctor_pdf_args] = [
        '--require', 'asciidoctor-mathematical', '-a', 'mathematical-format=svg',
    ]
    CONFIG[:htmlproofer_opts] = {
        ignore_urls: [
            /github\.(io|com).*\/ssoo-apuntes/
        ]
    }
end

namespace :build do
    
    desc 'Generar el sitio web donde se alojan los apuntes'
    task :site, [:site_root] do |t, args|
        args.with_defaults(:site_root => CONFIG[:site_root])

        #ENV['HTML_COMMENTS_ENABLED'] = '1'
        Rake::Task['build:html'].invoke
       
        output_directory = File.dirname(Rake::Task['build:html'].prerequisites.first)
        open(File.join(output_directory, 'index.html'), 'w') do |f|
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
                        <loc>#{URI.join(args.site_root, URI.encode_www_form_component(filename))}</loc>
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

desc 'Iniciar el servidor web de desarrollo'
task :server, [:port] => 'build:site' do |t, args|
    args.with_defaults(:port => CONFIG[:server_port])

    website_root = File.dirname(Rake::Task['build:html'].prerequisites.first)
    server = WEBrick::HTTPServer.new :Port => args.port, :DocumentRoot => website_root

    # Interceptar señales para detener el servidor.
    ['TERM', 'INT'].each do |signal|
        trap signal do
            server.shutdown
        end
    end

    puts "=> Server starting on http://0.0.0.0:#{args.port}"
    server.start
end