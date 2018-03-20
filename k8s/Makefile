.PHONY: configure cluster testnet ssh info proxy
.PHONY: rollout rollback bootstrap-cluster delete-testnet

PROJECT_ID=chainlink-dimroc
ROLLOUT_PATCH = '{"spec":{"template":{"spec":{"containers":[{"name":"CONTNAME","image":"CONTSHA"}]}}}}'

configure:
	gcloud config set project $(PROJECT_ID)
	gcloud config set compute/zone us-east1-c
	gcloud auth login
	gcloud config list

cluster:
	gcloud container clusters create cluster-testnet \
		--cluster-version 1.9

testnet:
	kubectl apply -f testnet.yaml

ssh:
	kubectl exec -it $(POD) -- /bin/bash

info:
	kubectl cluster-info
	kubectl get ingress,services,deployments,rs,pods -o wide

proxy:
	open 'http://127.0.0.1:8001/ui'
	kubectl proxy --kubeconfig="$(HOME)/.kube/config"

rollout:
	kubectl patch deployment testnet-deploy -p \
		$(subst CONTSHA,$(shell ./docker-repodigest devnet),$(subst CONTNAME,ethereum,$(ROLLOUT_PATCH)))
	kubectl patch deployment testnet-deploy -p \
		$(subst CONTSHA,$(shell ./docker-repodigest chainlink),$(subst CONTNAME,chainlink,$(ROLLOUT_PATCH)))

rollback:
	kubectl rollout undo deployment/testnet-deploy

bootstrap-cluster: configure cluster testnet info

delete-testnet:
	kubectl delete -f testnet.yaml
