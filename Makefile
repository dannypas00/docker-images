IMAGES ?= php-cli frank node

.DEFAULT_TARGET: push

.PHONY: build push
build: $(IMAGES)
$(IMAGES):
	@echo Building $@/latest
	docker build . --file=$(@).Dockerfile \
		--parallel \
        --tag=dannypas00/$@:latest \
		--cache-to type=gha \
		--cache-from type=gha \
		--build-arg="PHP_VERSION=$(PHP_VERSION)" \
		--build-arg="FRANK_VERSION=$(FRANK_VERSION)" \
		--build-arg="NODE_VERSION=$(NODE_VERSION)";

push: build
	docker tag dannypas00/frank:latest dannypas00/frank:$(PHP_VERSION);
	docker push dannypas00/frank:$(PHP_VERSION);

	docker tag dannypas00/php-cli:latest dannypas00/php-cli:$(PHP_VERSION);
	docker push dannypas00/php-cli:$(PHP_VERSION);

	docker tag dannypas00/node:latest dannypas00/node:$(NODE_VERSION);
	docker push dannypas00/node:$(NODE_VERSION);
