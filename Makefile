SOURCES=$(wildcard src/*.md)
BUILDS=$(addprefix build/,$(notdir $(SOURCES:.md=.html)))

ARTICLE_MDS=$(filter-out src/article/index.mdk, $(wildcard src/article/*.md) $(wildcard src/article/*.mdk))
ARTICLE_INDEX=src/article/index.mdk
ARTICLE_EXTENSIONS="\.mdk|\.md"
ARTICLE_HTMLS=$(shell echo $(ARTICLE_MDS) | perl -pe "s/"$(ARTICLE_EXTENSIONS)"/\.html/g")
ARTICLE_MARKDOWNIZED=$(addprefix build/md/, $(notdir $(shell echo $(ARTICLE_MDS) | perl -pe "s/"$(ARTICLE_EXTENSIONS)"/\.md/g")))
ARTICLE_PDFS=$(addprefix build/article/pdf/,$(notdir $(shell echo $(wildcard src/article/*.mdk) | perl -pe "s/\.mdk/\.pdf/g")))
ARTICLE_BUILDS=$(addprefix build/article/,$(notdir $(ARTICLE_HTMLS)))
SITE_NAME="ayu-mushi's website"
SITE_URI="http://ayu-mushi.github.io/"
COMMON_OPTS=--template src/mytheme/layout.html --title-prefix=$(SITE_NAME)
CURRENT_DIR = $(shell pwd)

all: $(BUILDS) build/mytheme/main.css build/README.md $(ARTICLE_BUILDS) build/article/index.html $(ARTICLE_MARKDOWNIZED)#$(ARTICLE_PDFS)

build/README.md: README.md
	cp README.md build/README.md

build/mytheme/main.css : src/mytheme/main.sass
	sass $< $@

src/article/index.mdk : $(ARTICLE_BUILDS) src/article/make_index.py src/mytheme/myprelude.mdk
	python src/article/make_index.py > src/article/index.mdk

build/article/%.html : src/article/%.md build/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=../mytheme/main.css $(COMMON_OPTS)

build/article/%.html : src/article/%.mdk src/mytheme/main.sass src/mytheme/myprelude.mdk
	madoko -v $< --odir=$(CURRENT_DIR)/build/article --meta=site-name:$(SITE_NAME)

build/md/%.md : build/article/%.html #for textlint, madoko file is transformated into plain markdown
	pandoc -o $@ $<

build/article/pdf/%.pdf: src/article/%.mdk src/mytheme/myprelude.mdk src/mytheme/myprelude_pdf.mdk
	madoko -v --pdf $< --odir=$(CURRENT_DIR)/build/article/pdf

build/%.html : src/%.md src/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=mytheme/main.css $(COMMON_OPTS)

.PHONY: all clean

clean:
	rm -f $(BUILDS) build/mytheme/main.css build/README.md $(ARTICLE_BUILDS)

rebuild: clean all
