DEPLOYMENT ?=
ROLLOUT_PATCH := '{"spec":{"template":{"spec":{"containers":[{"name":"CONTNAME","image":"CONTSHA"}]}}}}'

.PHONY: configure
configure: ## Configure google cloud credentials for PROJECT_ID (must be set)
	gcloud config set project $(PROJECT_ID)
	gcloud config set compute/zone us-central1-a
	gcloud auth login
	gcloud config list
	gcloud container clusters get-credentials $(CLUSTER_NAME)
	kubectl config current-context

.PHONY: cluster
cluster: ## Create a google cloud k8s cluster
	gcloud container clusters create $(CLUSTER_NAME) \
		--cluster-version 1.10

.PHONY: info
info: ## Use kubectl to display information about the running cluster
	kubectl config current-context
	kubectl cluster-info
	kubectl get secrets,pvc,pv,nodes,ingress,svc,deploy,po -o wide

.PHONY: proxy
proxy: ## Open up k8s dashboard by using kubectl to setup a proxy with gcloud
	open 'http://127.0.0.1:8001/ui'
	kubectl proxy

.PHONY: bootstrap-cluster
bootstrap-cluster: configure cluster secrets apply info ## One command to bootstrap a whole cluster from nothing. Make sure dotfiles are in place for secrets.

.PHONY: help
help:
	@echo ""
	@echo "Chainlink Deployment Commands"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
