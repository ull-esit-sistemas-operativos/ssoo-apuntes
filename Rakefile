Rake.add_rakelib 'lib/tasks'

task :config do |t|
    CONFIG[:asciidoctor_pdf_args] = [
        '--require', 'asciidoctor-mathematical', '-a', 'mathematical-format=svg',
    ]
    CONFIG[:htmlproofer_opts] = {
        url_ignore: [
            /github\.(io|com).*\/ssoo-apuntes/
        ]
    }
end

namespace :build do
    
    desc 'Generar el sitio web donde se alojan los apuntes'
    task :site do
        ENV['HTML_MULTIPAGE'] = '1'
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