LAST_COMMIT_MSG := $(shell git log -1 --pretty=format:%B)

.PHONY: build deploy

build:
	jekyll build

init:
	gem install jekyll bundler:2.3.3
	bundle install

list-tags:
	sed -n -e 's/tags: \[\(.*\)\]/\1/p' _posts/* | sed 's/ *, */\n/g' | sort | uniq -c | sort -nr

deploy: build
	(cd _site && git add -A && git commit -m "$(LAST_COMMIT_MSG)" && git push)

