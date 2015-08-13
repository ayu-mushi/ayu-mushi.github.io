SOURCES=$(wildcard src/*.md)
BUILDS=$(addprefix build/,$(notdir $(SOURCES:.md=.html)))

all: $(BUILDS)

build/mytheme/main.css : src/mytheme/main.sass
	sass $< $@

build/%.html : src/%.md build/mytheme/main.css
	pandoc -f markdown+definition_lists -o $@ $< --css=http://ayu-mushi.github.io/mytheme/main.css --template src/mytheme/layout.html --title-prefix="ayu-mushi's website"

.PHONY: all clean

clean:
	rm -f build/*.html
	rm -f build/mytheme/main.css
