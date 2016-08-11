SOURCES=$(wildcard src/*.md)
BUILDS=$(addprefix build/,$(notdir $(SOURCES:.md=.html)))

ARTICLE_MDS=$(wildcard src/article/*.md) $(wildcard src/article/*.mdk)
ARTICLE_EXTENSIONS="\.mdk|\.md"
ARTICLE_HTMLS=$(shell echo $(ARTICLE_MDS) | perl -pe "s/"$(ARTICLE_EXTENSIONS)"/\.html/g")
ARTICLE_BUILDS=$(addprefix build/article/,$(notdir $(ARTICLE_HTMLS)))
SITE_NAME="ayu-mushi's website"
SITE_URI="http://ayu-mushi.github.io/"
COMMON_OPTS=--template src/mytheme/layout.html --title-prefix=$(SITE_NAME)

all: $(BUILDS) $(ARTICLE_BUILDS) build/README.md

build/README.md: README.md
	cp README.md build/README.md

build/mytheme/main.css : src/mytheme/main.sass
	sass $< $@

build/article/%.html : src/article/%.md build/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=../mytheme/main.css $(COMMON_OPTS)

build/article/%.html : src/article/%.mdk build/mytheme/main.css
	madoko -v --odir=build/article/ $<

build/%.html : src/%.md build/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=mytheme/main.css $(COMMON_OPTS)

.PHONY: all clean

clean:
	rm -f $(BUILDS) build/mytheme/main.css build/README.md $(ARTICLE_BUILDS)

rebuild: clean all
