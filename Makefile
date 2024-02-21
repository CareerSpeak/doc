ifeq '$(findstring ;,$(PATH))' ';'
    UNAME := Windows
else
    UNAME := $(shell uname 2>/dev/null || echo Unknown)
    UNAME := $(patsubst CYGWIN%,Cygwin,$(UNAME))
    UNAME := $(patsubst MSYS%,MSYS,$(UNAME))
    UNAME := $(patsubst MINGW%,MSYS,$(UNAME))
endif

ROOTDIR := $(shell pwd)
CONTENTDIR := $(ROOTDIR)/content
BUILDDIR := $(ROOTDIR)/build
INTERMEDIATEDIR := $(BUILDDIR)/intermediate
FILES := $(wildcard $(CONTENTDIR)/*.md)

NATBIB_OPTIONS := square,sort,comma,numbers

define SED
	$(eval $@_EXPRESSION = $(1))
	$(eval $@_REPLACEMENT = $(2))
	$(eval $@_FILE = $(3))

	$(eval $@_WINDOWS_REPL_NON_ESCAPED = $(shell $("$($@_REPLACEMENT)" -Replace "\\\\","\")))

	$(eval $@_EXPR_COMMA_REPL = '$($@_EXPRESSION)','$($@_WINDOWS_REPL_NON_ESCAPED)')

	$(eval $@_WINDOWS_SED = (Get-Content $($@_FILE)) -Replace $($@_EXPR_COMMA_REPL))
	$(eval $@_WINDOWS_UPDATE_FILE = Set-Content $($@_FILE))

	$(eval $@_SED = sed -i 's|$($@_EXPRESSION)|$($@_REPLACEMENT)|' $($@_FILE))

	$(if $(findstring $(UNAME),Windows),$($@_WINDOWS_SED) | $($@_WINDOWS_UPDATE_FILE),$($@_SED))
endef

define ZIP
	$(eval $@_ZIP_FILE = $(1))
	$(eval $@_CONTENTS = $(2))

	$(eval $@_WINDOWS_ZIP = (Compress-Archive -Force -Path $($@_CONTENTS) -DestinationPath $($@_ZIP_FILE)))

	$(eval $@_ZIP = zip -qr $($@_ZIP_FILE) $($@_CONTENTS))

	$(if $(findstring $(UNAME),Windows),$($@_WINDOWS_ZIP),$($@_ZIP))
endef

define MKDIR
	$(eval $@_DIRECTORY = $(1))

	$(eval $@_WINDOWS_MKDIR = md $($@_DIRECTORY) -ea 0)

	$(eval $@_MKDIR = mkdir -p $($@_DIRECTORY))

	$(if $(findstring $(UNAME),Windows),$($@_WINDOWS_MKDIR),$($@_MKDIR))
endef

$(ROOTDIR)/citation-style.csl:
	@curl -o citation-style.csl                                               \
		https://www.zotero.org/styles/ieee

%.tex: $(ROOTDIR)/citation-style.csl
	@echo Generating latex...                                                 \
	mkdir -p $(INTERMEDIATEDIR);                                              \
		pandoc $(CONTENTDIR)/metadata.yml $(FILES)                            \
			--resource-path=$(CONTENTDIR)                                     \
			--from=markdown                                                   \
			--bibliography=$(CONTENTDIR)/bibliography.bib                     \
			--csl=$(ROOTDIR)/citation-style.csl                               \
			--filter=pandoc-crossref                                          \
			--natbib                                                          \
			--template=$(ROOTDIR)/templates/template.latex                    \
			--pdf-engine=pdflatex                                             \
			--to=latex                                                        \
			--output=$(INTERMEDIATEDIR)/$@;                                   \
	$(call SED,\\usepackage{natbib},\\usepackage[$(NATBIB_OPTIONS)]{natbib},$(INTERMEDIATEDIR)/$@);\
	echo Generated $(INTERMEDIATEDIR)/$@

%.pdf: %.tex
	@echo Generating PDF;                                                     \
	mkdir -p $(INTERMEDIATEDIR)/content;                                      \
	cp $(CONTENTDIR)/bibliography.bib $(INTERMEDIATEDIR)/content;             \
	cp $(CONTENTDIR)/images $(INTERMEDIATEDIR)/content -r;                    \
	cd $(INTERMEDIATEDIR);                                                    \
		pdflatex --interaction=batchmode paper;                               \
		bibtex paper;                                                         \
		pdflatex --interaction=batchmode paper;                               \
		pdflatex --interaction=batchmode paper;                               \
		cp $(INTERMEDIATEDIR)/$@ $(BUILDDIR);                                 \
	echo Generated $(BUILDDIR)/$@

.PHONY: $(INTERMEDIATEDIR)/ publish cleanIntermediate clean

$(INTERMEDIATEDIR)/: paper.pdf

publish: $(INTERMEDIATEDIR)/$(wildcard *.pdf)
	@cd $(INTERMEDIATEDIR);                                                   \
		$(call ZIP,../paper.zip,*.bbl *.tex content)

cleanIntermediate:
	@rm -rf $(INTERMEDIATEDIR)

clean:
	@rm -rf $(BUILDDIR)
