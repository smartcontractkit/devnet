.PHONY: configure cluster testnet ssh info proxy
.PHONY: rollout rollback bootstrap-cluster delete-testnet

CLUSTER_NAME=cluster-testnet
ROLLOUT_PATCH = '{"spec":{"template":{"spec":{"containers":[{"name":"CONTNAME","image":"CONTSHA"}]}}}}'

configure:
	gcloud config set project $(PROJECT_ID)
	gcloud config set compute/zone us-east1-c
	gcloud auth login
	gcloud config list
	gcloud container clusters get-credentials $(CLUSTER_NAME)

cluster:
	gcloud container clusters create $(CLUSTER_NAME) \
		--cluster-version 1.9

testnet:
	kubectl apply -f testnet/ethereum.yaml
	kubectl apply -f testnet/chainlink.yaml

sshchainlink:
	kubectl exec -it $(POD) -c chainlink -- /bin/sh

sshethereum:
	kubectl exec -it $(POD) -c ethereum -- /bin/bash

info:
	kubectl config current-context
	kubectl cluster-info
	kubectl get no,pvc,pv,svc,deploy,po -o wide

proxy:
	open 'http://127.0.0.1:8001/ui'
	kubectl proxy

rollout:
	-kubectl patch deployment ethereum-deploy -p \
		$(subst CONTSHA,$(shell ./docker-repodigest ethereum),$(subst CONTNAME,ethereum,$(ROLLOUT_PATCH)))
	-kubectl patch deployment chainlink-deploy -p \
		$(subst CONTSHA,$(shell ./docker-repodigest chainlink),$(subst CONTNAME,chainlink,$(ROLLOUT_PATCH)))

rollback:
	kubectl rollout undo deployment/testnet-deploy

bootstrap-cluster: configure cluster testnet info

delete-testnet:
	kubectl delete -f testnet/ethereum.yaml
	kubectl delete -f testnet/chainlink.yaml

secrets:
	kubectl create secret generic cl-environment --from-env-file=.env --dry-run=true -o yaml | kubectl apply -f -
