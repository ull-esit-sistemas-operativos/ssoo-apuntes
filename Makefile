PROJECTDIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

ASCIIDOCTOR_CMD := asciidoctor
ASCIIDOCTOR_OPTS :=
DOCSTATS_BIN := scripts/update-docstats

INPUTDIR := $(PROJECTDIR)/content
INPUTFILE := $(INPUTDIR)/main.adoc
MEDIAINPUTFILES := $(shell find  $(INPUTDIR)/C*/images -type f \( -name *.jpg -or -name *.png -or -name *.svg \))

OUTPUTDIR := $(PWD)/output
HTMLOUTPUTDIR := $(OUTPUTDIR)/html
HTMLOUTPUTFILE := $(HTMLOUTPUTDIR)/index.html
PDFOUTPUTDIR := $(OUTPUTDIR)/pdf
PDFOUTPUTFILE := $(PDFOUTPUTDIR)/sistemas-operativos.pdf
EPUBOUTPUTDIR := $(OUTPUTDIR)/epub
EPUBOUTPUTFILE := $(EPUBOUTPUTDIR)/sistemas-operativos.epub

DOCSTATSFILE := $(INPUTDIR)/docstats.adoc

all: html # pdf epub

html: clean-html
	@mkdir --parents $(HTMLOUTPUTDIR)
	@cd $(INPUTDIR) &&\
		MEDIAINPUTFILES=$$(realpath --relative-to="$(INPUTDIR)" $(MEDIAINPUTFILES)) && \
		cp --remove-destination --link --parents --recursive $$MEDIAINPUTFILES $(HTMLOUTPUTDIR)
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --backend html5 $(INPUTFILE) -o $(HTMLOUTPUTFILE)

pdf:
	@mkdir --parents $(PDFOUTPUTDIR)
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --require asciidoctor-pdf --backend pdf $(INPUTDIR) -o $(PDFOUTPUTFILE)

epub:
	@mkdir --parents $(EPUBOUTPUTDIR)
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --require asciidoctor-epub3 --backend epub3 $(INPUTDIR) -o $(EPUBOUTPUTFILE)

docstats:
	$(DOCSTATS_BIN) $(INPUTDIR) $(DOCSTATSFILE)

tests:
	htmlproofer --typhoeus_config '{"ssl_verifyhost": 0, "ssl_verifypeer": false}' output/html/

clean:
	rm -r $(OUTPUTDIR)

clean-html:
	rm -r $(HTMLOUTPUTDIR)

.PHONY: html pdf epub all docstats clean clean-html