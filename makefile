build-ubuntu-sops-container:
	docker build \
	-t "ionutvilie/sops:latest-ubuntu" \
	-f sops-ubuntu.Dockerfile .;

run-ubuntu-container:
	docker run --rm -i -t \
	-h ubuntu-sops-manager
	-v ${PWD}:/data/ \
	-e PGP_EMAIL=test@example.com \
	-e PGP_PASSPHRASE=somepassphrase \
	-e PS1='\u@\h : \w\n$ ' \
	ionutvilie/sops:latest-ubuntu bash

build-alpine-sops-container:
	docker build \
	-t "ionutvilie/sops:latest-alpine" \
	-f sops-alpine.Dockerfile .;

run-alpine-container:
	docker run --rm -i -t \
	-v ${PWD}:/data/ \
	-h alpine-sops-manager \
	-e PS1='\u@\h : \w\n$ ' \
	-e PGP_EMAIL=test@example.com \
	-e PGP_PASSPHRASE=somepassphrase \
	ionutvilie/sops:latest-alpine bash