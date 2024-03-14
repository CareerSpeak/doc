ifeq '$(findstring ;,$(PATH))' ';'
    UNAME := Windows
else
    UNAME := $(shell uname 2>/dev/null || echo Unknown)
    UNAME := $(patsubst CYGWIN%,Cygwin,$(UNAME))
    UNAME := $(patsubst MSYS%,MSYS,$(UNAME))
    UNAME := $(patsubst MINGW%,MSYS,$(UNAME))
endif

ROOTDIR := $(CURDIR)
CONTENTDIR := $(ROOTDIR)/content
BUILDDIR := $(ROOTDIR)/build
INTERMEDIATEDIR := $(BUILDDIR)/intermediate
FILES := $(wildcard $(CONTENTDIR)/*.md)

NATBIB_OPTIONS := square,sort,comma,numbers

define SED
	$(eval $@_EXPRESSION = $(1))
	$(eval $@_REPLACEMENT = $(2))
	$(eval $@_FILE = $(3))

	$(eval $@_WINDOWS_REPL_NON_ESCAPED = $(shell pwsh -Command $("$($@_REPLACEMENT)" -Replace "\\\\","\")))

	$(eval $@_EXPR_COMMA_REPL = '$($@_EXPRESSION)','$($@_WINDOWS_REPL_NON_ESCAPED)')

	$(eval $@_WINDOWS_SED = (Get-Content $($@_FILE)) -Replace $($@_EXPR_COMMA_REPL))
	$(eval $@_WINDOWS_UPDATE_FILE = Set-Content $($@_FILE))

	$(eval $@_SED = sed -i 's|$($@_EXPRESSION)|$($@_REPLACEMENT)|' $($@_FILE))

	$(if $(findstring $(UNAME),Windows),pwsh -Command $($@_WINDOWS_SED) | $($@_WINDOWS_UPDATE_FILE),$($@_SED))
endef

define ZIP
	$(eval $@_LOCATION = $(1))
	$(eval $@_ZIP_FILE = $(2))
	$(eval $@_CONTENTS = $(3))

	$(eval $@_WINDOWS_ZIP = pwsh -Command (Compress-Archive -Force -Path $($@_CONTENTS) -DestinationPath $($@_ZIP_FILE)))

	$(eval $@_ZIP = zip -r $($@_ZIP_FILE) $($@_CONTENTS))

	cd $($@_LOCATION);                                                        \
		$(if $(findstring $(UNAME),Windows),$($@_WINDOWS_ZIP),$($@_ZIP))
endef

define MKDIR
	$(eval $@_DIRECTORY = $(1))

	$(eval $@_WINDOWS_MKDIR = pwsh -Command md $($@_DIRECTORY) -ea 0)

	$(eval $@_MKDIR = mkdir -p $($@_DIRECTORY))

	$(if $(findstring $(UNAME),Windows),$($@_WINDOWS_MKDIR),$($@_MKDIR))
endef

define CP
	$(eval $@_SOURCE = $(1))
	$(eval $@_DESTINATION = $(2))

	$(eval $@_WINDOWS_CP = XCOPY /E $($@_SOURCE) $($@_DESTINATION))

	$(eval $@_CP = cp -r $($@_SOURCE) $($@_DESTINATION))

	$(if $(findstring $(UNAME),Windows),$($@_WINDOWS_CP),$($@_CP))
endef

define RM
	$(eval $@_DIR = $(1))

	$(eval $@_WINDOWS_RM = RMDIR /S /Q $($@_DIR))

	$(eval $@_RM = rm -rf $($@_DIR))

	$(if $(findstring $(UNAME),Windows),$($@_WINDOWS_RM),$($@_RM))
endef

$(ROOTDIR)/citation-style.csl:
	@curl -o citation-style.csl                                               \
		https://www.zotero.org/styles/ieee

%.tex: $(ROOTDIR)/citation-style.csl
	@echo Generating latex...;                                                \
	$(call MKDIR,$(INTERMEDIATEDIR));                                         \
	pandoc $(CONTENTDIR)/metadata.yml $(FILES)                                \
		--resource-path=$(CONTENTDIR)                                         \
		--from=markdown                                                       \
		--bibliography=$(CONTENTDIR)/bibliography.bib                         \
		--csl=$(ROOTDIR)/citation-style.csl                                   \
		--filter=pandoc-crossref                                              \
		--natbib                                                              \
		--template=$(ROOTDIR)/templates/template.latex                        \
		--pdf-engine=pdflatex                                                 \
		--to=latex                                                            \
		--output=$@;                                                          \
	$(call SED,\\usepackage{natbib},\\usepackage[$(NATBIB_OPTIONS)]{natbib},$@);\
	echo Generated $@

%.pdf: $(INTERMEDIATEDIR)/%.tex
	@echo Generating PDF...;                                                  \
	$(call MKDIR,$(INTERMEDIATEDIR)/content);                                 \
	$(call CP,$(CONTENTDIR)/bibliography.bib,$(INTERMEDIATEDIR)/content);     \
	$(call CP,$(CONTENTDIR)/images,$(INTERMEDIATEDIR)/content);               \
	cd $(INTERMEDIATEDIR);                                                    \
		pdflatex --interaction=batchmode paper;                               \
		bibtex paper;                                                         \
		pdflatex --interaction=batchmode paper;                               \
		pdflatex --interaction=batchmode paper;                               \
	$(call CP,$(INTERMEDIATEDIR)/$@,$(BUILDDIR));                             \
	echo Generated $(BUILDDIR)/$@

.PHONY: $(INTERMEDIATEDIR)/ publish cleanIntermediate clean

$(INTERMEDIATEDIR)/: paper.pdf

publish: $(INTERMEDIATEDIR)/$(wildcard *.pdf)
	@$(call ZIP,$(INTERMEDIATEDIR),../paper.zip,./*.bbl ./*.tex content/images/*.pdf)

cleanIntermediate:
	@$(call RM,$(INTERMEDIATEDIR))

clean:
	@$(call RM,$(BUILDDIR))
