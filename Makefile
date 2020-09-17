

DOCKER=docker run -it --rm \
      -v `pwd`:/workdir \
      -w /workdir \
      -e BUILD_NUMBER=$(BUILD_NUMBER) \
      -e environment=$(ENVIRONMENT) \
      node

package:
	mkdir -p bin && rm -rf bin/*
	npx pkg -c package.json --out-path bin src/index.js
	bzip2 -k bin/*


docker-build:
	docker build -f Dockerfile -t aws-emr-runner .

docker-package:
	$(DOCKER) make package

docker-shell:
	$(DOCKER) bash
	