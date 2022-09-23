DOCKER=docker run --rm --platform=linux/arm64 \
      -v `pwd`:/workdir \
      -w /workdir \
      -e BUILD_NUMBER=$(BUILD_NUMBER) \
      -e environment=$(ENVIRONMENT) \
      node \
      npm install

prune:
	npm prune --omit=dev
	find node_modules -name '*.d.ts' | xargs rm

package: prune
	mkdir -p bin && rm -rf bin
	npx pkg -c package.json --out-path bin src/index.js
	bzip2 -k bin/*

release:
	npx semantic-release

docker-build:
	docker build -f Dockerfile -t aws-emr-runner .

docker-package:
	$(DOCKER) make package

docker-shell:
	$(DOCKER) bash

unit-test:
	npx test


