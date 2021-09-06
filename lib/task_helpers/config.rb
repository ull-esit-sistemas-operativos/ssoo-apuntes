Struct.new('Config',
            :asciidoctor_args,
            :asciidoctor_docbook_args,
            :asciidoctor_epub_args,
            :asciidoctor_html_args,
            :asciidoctor_pdf_args,
            :htmlproofer_opts,
            :pandoc_docx_args,
            keyword_init: true) do
    def initialize()
        default_values = {
            asciidoctor_args: [],
            asciidoctor_docbook_args: [],
            asciidoctor_epub_args:  [],
            asciidoctor_html_args: [],
            asciidoctor_pdf_args: [],
            htmlproofer_opts: {},
            pandoc_docx_args: []
        }
        super(default_values)
    end
end

CONFIG = Struct::Config.new()