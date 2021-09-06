Rake.add_rakelib 'lib/tasks'

task :config do |t|
    CONFIG[:asciidoctor_pdf_args] = [
        '--require', 'asciidoctor-mathematical', '-a', 'mathematical-format=svg',
    ]
    CONFIG[:htmlproofer_opts] = {
        url_ignore: [
            '/github\.(io|com).*\/ssoo-apuntes/'
        ]
    }
end