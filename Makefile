SOURCES=$(wildcard src/*.md)
BUILDS=$(addprefix build/,$(notdir $(SOURCES:.md=.html)))

ARTICLE_MDS=$(wildcard src/article/*.md)
ARTICLE_BUILDS=$(addprefix build/article/,$(notdir $(ARTICLE_MDS:.md=.html)))
SITE_NAME="ayu-mushi's website"
SITE_URI="http://ayu-mushi.github.io/"

all: $(BUILDS) $(ARTICLE_BUILDS) build/README.md

build/README.md:
	cp README.md build/README.md

build/mytheme/main.css : src/mytheme/main.sass
	sass $< $@

build/article/%.html : src/article/%.md build/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=../mytheme/main.css --template src/mytheme/layout.html --title-prefix=$(SITE_NAME)

build/%.html : src/%.md build/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=mytheme/main.css --template src/mytheme/layout.html --title-prefix=$(SITE_NAME)

.PHONY: all clean

clean:
	rm -f $(BUILDS) build/mytheme/main.css build/README.md $(ARTICLE_BUILDS)

rebuild: clean all
