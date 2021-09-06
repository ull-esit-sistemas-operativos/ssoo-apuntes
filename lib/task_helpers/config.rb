Struct.new('Config',
            :asciidoctor_opts,
            :asciidoctor_docbook_opts,
            :asciidoctor_epub_opts,
            :asciidoctor_html_opts,
            :asciidoctor_pdf_opts,
            :htmlproofer_opts,
            :pandoc_docx_opts,
            keyword_init: true) do
    def initialize()
        default_values = {
            asciidoctor_opts: [],
            asciidoctor_docbook_opts: [],
            asciidoctor_epub_opts:  [],
            asciidoctor_html_opts: [],
            asciidoctor_pdf_opts: [],
            htmlproofer_opts: {},
            pandoc_docx_opts: []
        }
        super(default_values)
    end
end

CONFIG = Struct::Config.new()