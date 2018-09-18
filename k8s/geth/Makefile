include ../Makefile

CLUSTER_NAME := $(DEPLOYMENT)-geth
ETHEREUM_IMAGE ?= smartcontract/devnet:latest

.PHONY: apply
apply: ## Apply k8s configuration changes to cluster
	kubectl apply -f shared/ethereum-svc.yaml
	kubectl apply -f shared/ethereum-pv-claim.yaml
	kubectl apply -f deployments/$(DEPLOYMENT)/ethereum.yaml

.PHONY: ssh
ssh: ## SSH into the ethereum container at POD env variable
	kubectl exec -it `kubectl get pods | grep -v NAME | grep ethereum | awk '{print$$1}'` -- /bin/bash

.PHONY: patch
patch: ## Update the cluster's container SHAs, effectively forcing them to bump to the latest docker image
	-kubectl patch deployment ethereum-deploy -p \
		$(subst CONTSHA,$(shell ../docker-repodigest $(ETHEREUM_IMAGE)),$(subst CONTNAME,ethereum,$(ROLLOUT_PATCH)))
