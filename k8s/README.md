## Deploying Testnet to GCP

We use Google Cloud Platform's Kubernetes Engine (GKE) to easily bootstrap
and deploy Parity against Ropsten with an attached Chainlink node.

#### Requirements:

1. Valid GCP account.
2. [`gcloud` CLI tool](https://github.com/Homebrew/homebrew-core/issues/583#issuecomment-214024802) installed.
3. [`kubectl` CLI tool](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-homebrew-on-macos) installed.

#### Steps:

```
brew tap caskroom/cask
brew cask install google-cloud-sdk
brew install kubectl

# Create from scratch
make bootstrap-cluster

# which is the same as
make configure cluster testnet info

# Redeploy after updating images
make rollout
```
