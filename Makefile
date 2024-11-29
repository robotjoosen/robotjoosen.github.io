CURRENT_DIR = $(shell pwd)

.PHONY: serve
serve:
	docker run --volume="$(CURRENT_DIR):/srv/jekyll:Z" -p 4000:4000 -it jekyll/jekyll:4.2.2 jekyll serve


.PHONY: build
build:
	docker run --volume="$(CURRENT_DIR):/srv/jekyll:Z" -it jekyll/jekyll:4.2.2 jekyll build
