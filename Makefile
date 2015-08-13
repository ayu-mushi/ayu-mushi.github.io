SOURCES=$(wildcard src/*.md)
BUILDS=$(addprefix build/,$(notdir $(SOURCES:.md=.html)))

ARTICLE_MDS=$(wildcard src/article/*.md)
ARTICLE_BUILDS=$(addprefix build/article/,$(notdir $(ARTICLE_MDS:.md=.html)))

all: $(BUILDS) $(ARTICLE_BUILDS) build/README.md

build/README.md:
	cp README.md build/README.md

build/mytheme/main.css : src/mytheme/main.sass
	sass $< $@

build/article/%.html : src/article/*.md build/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=../mytheme/main.css --template src/mytheme/layout.html --title-prefix="ayu-mushi's website"

build/%.html : src/%.md build/mytheme/main.css
	pandoc -f markdown -o $@ $< --css=mytheme/main.css --template src/mytheme/layout.html --title-prefix="ayu-mushi's website"

.PHONY: all clean

clean:
	rm -f build/*.html
	rm -f build/mytheme/main.css
	rm -f build/README.md
	rm -f build/article/*.html
