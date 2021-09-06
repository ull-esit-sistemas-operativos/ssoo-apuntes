require 'rake'

module Project

    PROJECT_DIRECTORY = Rake.application.original_dir

    CONFIG_DIRECTORY = "config"
    SOURCE_DIRECTORY = "content"
    OUTPUT_DIRECTORY = "output"

    DOCUMENT_MAIN_FILE = "main.adoc"
    DOCUMENT_STATS_FILE = "docstats.adoc"
    DEFAULT_OUTPUT_NAME = File.basename DOCUMENT_MAIN_FILE, ".*"

    CONFIG_FILES = FileList[
        File.join(CONFIG_DIRECTORY, "**/*.adoc"),
        File.join(CONFIG_DIRECTORY, "**/*.yml"),
    ]

    def documents()
        @store ||= Project::find_documents()
    end
    module_function :documents

    def find_documents()
        FileList[File.join(SOURCE_DIRECTORY, "**/#{DOCUMENT_MAIN_FILE}")].map do |pathname|
            source_directory_regex = %r(^#{SOURCE_DIRECTORY}/?)
            source_directory = File.dirname pathname
            namespaces = source_directory.sub(source_directory_regex, "").split("/")
            output_directories = {
                :docbook => make_output_dirname(source_directory, "docbook"),
                :docx => make_output_dirname(source_directory, "docx"),
                :epub => make_output_dirname(source_directory, "epub"),
                :html => make_output_dirname(source_directory, "html"),
                :pdf => make_output_dirname(source_directory, "pdf"),
            }
            {
                :pathname => pathname,
                :namespace => namespaces.join(":"),
                :namespace_prefix => namespaces.empty? ? "" : [*namespaces, ""].join(":"),
                :source_directory => source_directory,
                :output_directories => output_directories,
                :dependencies => FileList[
                    pathname,
                    File.join(source_directory, "**/*.adoc"),
                    *CONFIG_FILES
                ],
                :media_files => find_media_files(source_directory),
                :output_pathnames => {
                    :docbook => File.join(output_directories[:docbook], get_output_filename(namespaces, "docbook")),
                    :docx => File.join(output_directories[:docx], get_output_filename(namespaces, "docx")),
                    :epub => File.join(output_directories[:epub], get_output_filename(namespaces, "epub")),
                    :html => File.join(output_directories[:html], "#{DEFAULT_OUTPUT_NAME}.html"), 
                    :pdf => File.join(output_directories[:pdf], get_output_filename(namespaces, "pdf")),
                },
                :docstats_pathname => File.join(source_directory, DOCUMENT_STATS_FILE),
            }
        end
    end
    module_function :find_documents

    def make_output_dirname(source_directory, backend)
        source_directory.sub(%r(^#{SOURCE_DIRECTORY}), File.join(Project::PROJECT_DIRECTORY, OUTPUT_DIRECTORY, backend))
    end
    module_function :make_output_dirname

    def find_media_files(source_directory)
        FileList[
            File.join(source_directory, "**/media/**/*.ico"),
            File.join(source_directory, "**/media/**/*.jpg"),
            File.join(source_directory, "**/media/**/*.mp4"),
            File.join(source_directory, "**/media/**/*.png"),
            File.join(source_directory, "**/media/**/*.svg"),
        ]
    end
    module_function :find_media_files

    def get_output_filename(namespaces, extension)
        envvar_name = [*namespaces, "DOCUMENT", "NAME"].join("_").upcase
        return "#{ENV[envvar_name] || namespaces.last || DEFAULT_OUTPUT_NAME}.#{extension}"
    end
    module_function :get_output_filename

end