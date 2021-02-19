Struct.new('Config',
            :asciidoctor_opts,
            :asciidoctor_html_opts,
            :asciidoctor_epub_opts,
            :asciidoctor_pdf_opts,
            :htmlproofer_opts,
            keyword_init: true) do
    def initialize()
        default_values = {
            asciidoctor_opts: [],
            asciidoctor_html_opts: [],
            asciidoctor_epub_opts:  [],
            asciidoctor_pdf_opts: [],
            htmlproofer_opts:  ENV.key?('HTMLPROOFER_DISABLE_EXTERNAL') ? ["--disable-external"] : []
        }
        super(default_values)
    end
end

CONFIG = Struct::Config.new()