SOURCES=$(wildcard src/*.md)
BUILDS=$(addprefix build/,$(notdir $(SOURCES:.md=.html)))

build/%.html : src/%.md
	pandoc -o $@ $<

.PHONY: all clean

all: $(BUILDS)

clean:
	rm -f build/*.html
