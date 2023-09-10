require 'webrick'

Rake.add_rakelib 'lib/tasks'

task :config do |t|
    CONFIG[:asciidoctor_pdf_args] = [
        '--require', 'asciidoctor-mathematical', '-a', 'mathematical-format=svg',
    ]
    CONFIG[:htmlproofer_opts] = {
        ignore_urls: [
            /github\.(io|com).*\/ssoo-apuntes/
        ]
    }
end

desc 'Iniciar el servidor web de desarrollo'
task :server, [:port] => 'build:www' do |t, args|
    args.with_defaults(:port => CONFIG[:server_port])

    website_root = File.dirname(Rake::Task['build:www'].prerequisites.first)
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

desc 'Publich release'
task :publish, [:yeartag] do |t, args|
    if ! args[:yeartag]
        raise "Argument 'yeartag' is required."
    end

    current_branch = `git branch --show-current`.strip!
    release_branch = "curso-#{args[:yeartag]}"
    release_tag = "so#{args[:yeartag]}"

    sh 'git', 'rebase', 'master', release_branch
    sh 'git', 'tag', '-f', release_tag, release_branch
    sh 'git', 'push', '--atomic', '-f', 'origin', release_branch, release_tag
    sh 'git', 'checkout', current_branch
end