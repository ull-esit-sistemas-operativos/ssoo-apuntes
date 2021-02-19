Rake.add_rakelib 'lib/tasks'

task :config do |t|
    CONFIG[:asciidoctor_pdf_opts] = [
        '--require', 'asciidoctor-mathematical', '-a', 'mathematical-format=svg',
    ]
end