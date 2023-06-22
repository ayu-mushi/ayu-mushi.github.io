SOURCES=$(wildcard src/*.md)
BUILDS=$(addprefix docs/,$(notdir $(SOURCES:.md=.html)))

ARTICLE_MDS=$(filter-out src/article/index.mdk, $(wildcard src/article/*.md) $(wildcard src/article/*.mdk))
ARTICLE_INDEX=src/article/index.mdk
ARTICLE_EXTENSIONS="\.mdk|\.md"
ARTICLE_HTMLS=$(shell echo $(ARTICLE_MDS) | perl -pe "s/"$(ARTICLE_EXTENSIONS)"/\.html/g")
ARTICLE_MARKDOWNIZED=$(addprefix docs/md/, $(notdir $(shell echo $(ARTICLE_MDS) | perl -pe "s/"$(ARTICLE_EXTENSIONS)"/\.md/g")))
ARTICLE_PDFS=$(addprefix docs/article/pdf/,$(notdir $(shell echo $(wildcard src/article/*.mdk) | perl -pe "s/\.mdk/\.pdf/g")))
ARTICLE_BUILDS=$(addprefix docs/article/,$(notdir $(ARTICLE_HTMLS)))
SITE_NAME="ayu-mushi's website"
SITE_URI="http://ayu-mushi.github.io/"
COMMON_OPTS=--template src/mytheme/layout.html --title-prefix=$(SITE_NAME)
CURRENT_DIR = $(shell pwd)

all: $(BUILDS) docs/mytheme/main.css docs/README.md $(ARTICLE_BUILDS) docs/article/index.html $(ARTICLE_MARKDOWNIZED)#$(ARTICLE_PDFS)

docs/README.md: README.md
	cp README.md docs/README.md

docs/mytheme/main.css : src/mytheme/main.sass
	sass $< $@

src/article/index.mdk : src/article/make_index.py
	python src/article/make_index.py index > src/article/index.mdk

docs/atom.xml : src/article/make_index.py
	python src/article/make_index.py rss > docs/atom.xml

docs/article/%.html : src/article/%.md docs/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=../mytheme/main.css $(COMMON_OPTS)

docs/article/%.html : src/article/%.mdk src/mytheme/main.sass src/mytheme/myprelude.mdk
	madoko -v $< --odir=$(CURRENT_DIR)/docs/article --meta=site-name:$(SITE_NAME)

docs/md/%.md : docs/article/%.html #for textlint, madoko file is transformated into plain markdown
	pandoc -o $@ $<

docs/article/pdf/%.pdf: src/article/%.mdk src/mytheme/myprelude.mdk src/mytheme/myprelude_pdf.mdk
	madoko -v --pdf $< --odir=$(CURRENT_DIR)/docs/article/pdf

docs/%.html : src/%.md src/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=mytheme/main.css $(COMMON_OPTS)

.PHONY: all clean

clean:
	rm -f $(BUILDS) docs/mytheme/main.css docs/README.md $(ARTICLE_BUILDS)

docs/favicon.ico: src/images/favicon.png
	convert $< $@

rebuild: clean all
