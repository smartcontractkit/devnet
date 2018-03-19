REPO=smartcontract/devnet

.DEFAULT_GOAL := build
.PHONY: build push run ropsten


build:
	docker build -t $(REPO) .

run:
	docker run -p 18545:8545 -p 18546:8546 $(REPO):latest

push:
	docker push $(REPO)

ropsten:
	docker run -p 18545:8545 -p 18546:8546 $(REPO):latest --config ropsten.toml
