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
    task :site do
        #ENV['HTML_COMMENTS_ENABLED'] = '1'
        Rake::Task['build:html'].invoke
       
        output_directory = File.dirname(Rake::Task['build:html'].prerequisites.first)
        open(File.join(output_directory, 'index.html'), 'w') do |f|
            f << <<~EOF
                <!DOCTYPE HTML>                                                                
                <html lang="es">                                                                
                    <head>                                                                      
                        <meta charset="utf-8">
                        <meta name='robots' content='noindex,nofollow'>
                        <meta http-equiv="refresh" content="0;url=main.html">      
                        <link rel="canonical" href="main.html">                    
                    </head>                                                                                                                                                                  
                </html>
            EOF
        end
    end
end

desc 'Iniciar el servidor web de desarrollo'
task :server, [:port] => 'build:site' do |t, args|
    args.with_defaults(:port => 8080)

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