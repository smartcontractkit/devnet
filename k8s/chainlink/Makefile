include ../Makefile

CLUSTER_NAME := chainlink-$(DEPLOYMENT)
CHAINLINK_IMAGE ?= smartcontract/chainlink:latest
CERT := secrets/$(DEPLOYMENT).crt
KEY := secrets/$(DEPLOYMENT).key
DOMAIN := $(DEPLOYMENT)-node.chain.link
ifeq ($(DEPLOYMENT),production)
	DOMAIN := node.chain.link
endif
LETSENCRYPT ?= no

.PHONY: apply
apply: ## Apply k8s configuration changes to cluster
	kubectl apply -f chainlink.yaml

.PHONY: ssh
ssh: ## SSH into the chainlink container.
	kubectl exec -it `kubectl get pods | grep -v NAME | grep chainlink | awk '{print$$1}'` -- /bin/bash

.PHONY: patch
patch: ## Update the cluster's container SHAs, effectively forcing them to bump to the latest docker image
	-kubectl patch deployment chainlink-deploy -p \
		$(subst CONTSHA,$(shell ./docker-repodigest $(CHAINLINK_IMAGE)),$(subst CONTNAME,chainlink,$(ROLLOUT_PATCH)))

.PHONY: secrets
secrets: $(CERT) $(KEY) ## Update the cluster's secrets. Must have a populated secrets/ folder with ENVIRONMENT.* files. i.e. secrets/staging.env
	kubectl create secret generic cl-environment --from-env-file=secrets/$(DEPLOYMENT).env --dry-run=true -o yaml | kubectl apply -f -
	kubectl create secret generic cl-password --from-file=password=secrets/$(DEPLOYMENT).password --dry-run=true -o yaml | kubectl apply -f -
	kubectl create secret generic cl-api --from-file=api=secrets/$(DEPLOYMENT).api --dry-run=true -o yaml | kubectl apply -f -
	kubectl delete secret cl-sslcert --ignore-not-found=true
	kubectl create secret tls cl-sslcert --cert=$(CERT) --key=$(KEY)

$(CERT) $(KEY):
ifneq ($(LETSENCRYPT),yes)
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(KEY) \
		-out $(CERT) -subj "/OU=chainlink.development/CN=$(DOMAIN)/O=$(DOMAIN)"
else
	certbot -c certbot.ini -d $$DOMAIN --manual --preferred-challenges dns certonly
endif
