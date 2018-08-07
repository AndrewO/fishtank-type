SHELL := /bin/bash
PATH := ./node_modules/.bin:$(PATH)

DIST_FILES := dist/index.common.js dist/index.custom-properties.css dist/index.json dist/index.raw.json \
	dist/index.scss dist/_type.scss \
	dist/index.css \
	token_names.json

all: $(DIST_FILES)

dist/index.common.js dist/index.custom-properties.css dist/index.json dist/index.raw.json dist/_type.scss: *.yml type/*.yml
	theo index.yml --setup scripts/transformFontFamily.js \
		--transform web \
		--format custom-properties.css,scss,common.js,json,raw.json \
		--dest dist/
	mv dist/index.scss dist/_type.scss

dist/index.scss: index.scss
	cp index.scss dist/index.scss

dist/index.css: dist/index.scss dist/_type.scss
	node-sass dist/index.scss > $@

token_names.json: *.yml
	node scripts/get_token_names.js > $@

clean:
	rm -f $(DIST_FILES)

.PHONY: clean