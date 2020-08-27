PROJECTDIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

INPUTDIR := $(PROJECTDIR)/content
INPUTFILE := $(INPUTDIR)/main.adoc
MEDIAINPUTFILES := $(INPUTDIR)/*/images/*

OUTPUTDIR := $(PWD)/output

HTMLOUTPUTDIR := $(OUTPUTDIR)/html
HTMLOUTPUTFILE := $(HTMLOUTPUTDIR)/index.html

PDFOUTPUTDIR := $(OUTPUTDIR)/pdf
PDFOUTPUTFILE := $(PDFOUTPUTDIR)/sistemas-operativos.pdf

EPUBOUTPUTDIR := $(OUTPUTDIR)/epub
EPUBOUTPUTFILE := $(EPUBOUTPUTDIR)/sistemas-operativos.epub

ASCIIDOCTOR_CMD := asciidoctor
ASCIIDOCTOR_OPTS :=

html: prepare-html $(HTMLOUTPUTFILE)
	@echo 'Hecho'

pdf: prepare-pdf $(PDFOUTPUTFILE)
	@echo 'Hecho'

epub: prepare-epub $(EPUBOUTPUTFILE)
	@echo 'Hecho'

$(HTMLOUTPUTFILE): $(INPUTFILE)
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --backend html5 $< -o $@

$(PDFOUTPUTFILE): $(INPUTFILE)
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --require asciidoctor-pdf --backend pdf $< -o $@

$(EPUBOUTPUTFILE): $(INPUTFILE)
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --require asciidoctor-epub3 --backend epub3 $< -o $@

all: html pdf epub

prepare-html:
	@mkdir --parents $(HTMLOUTPUTDIR)
	@cd $(INPUTDIR) &&\
		MEDIAINPUTFILES=$$(realpath --relative-to="$(INPUTDIR)" $(MEDIAINPUTFILES)) &&\
		cp --remove-destination --link --parents --recursive $$MEDIAINPUTFILES $(HTMLOUTPUTDIR)

prepare-pdf:
	@mkdir --parents $(PDFOUTPUTDIR)

prepare-epub:
	@mkdir --parents $(EPUBOUTPUTDIR)

.PHONY: html pdf epub all prepare-html prepare-pdf prepare-epub