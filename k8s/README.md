# Deploying to GCP

Kubernetes configurations for deploying chainlink and geth to Google Cloud
Platform.

This project uses a small tool called chainctl (in this directory) to manage
deployments.

## Requirements:

1. Valid GCP account.
2. Create project chainlink-testnet on GCP and enable the kubernetes engine by visiting [the web portal](https://console.cloud.google.com/kubernetes/list).
3. [`gcloud` CLI tool](https://github.com/Homebrew/homebrew-core/issues/583#issuecomment-214024802) installed.
4. [`kubectl` CLI tool](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-homebrew-on-macos) installed.
5. Bash shell

### Installing Requirements:

```
brew tap caskroom/cask
brew cask install google-cloud-sdk
brew install kubectl

# Create from scratch
PROJECT_ID=your-project-name make bootstrap-cluster

# which is the same as
PROJECT_ID=your-project-name make configure cluster testnet info

# Redeploy after updating images
make patch
```

## Using `chainctl`

`chainctl` is a simple script for working with Kubernetes on Google Container
Engine. It's designed to be invoked from one of the `deployments` directories.
These directories are intended to act as a workplace for an individual
deployment, keeping any `kubectl` configuration, deployment customization,
configmaps or secrets. The last two parts of a workspace's full path are a
convention that inform `chainctl` what project and cluster to work in.

When executed from within one of these 'workspaces', e.g:
`deployments/development-216217/ropsten/`; `chainctl` takes these components
from the path. In this case the `PROJECT_ID` will be `development-216217` and
the `CLUSTER_NAME` will be `ropsten`. If you specify either of these as
environment variables, that value will take preference.

Workspaces contain custom information for a specific deployment of a set of
kubernetes templates. The set of templates to use for a deployment are
specified using a `TEMPLATES` variable. This value is specified in the
workspace's `chainctl.env` file and contains a list of template file basenames,
e.g: `TEMPLATES=chainlink`.

### Authenticating with `chainctl`

The first time you use `chainctl` within one of these workspaces, it will try
to create a `gcloud` configuration for that workspace. This will likely open a
browser window to ask you to authenticate with `gcloud` and give it permissions
to manage your cluster.

You should only have to do this once!

Please note that the `gcloud` configuration is global, and that once a
configuration is activated, it will affect all `gcloud` (and likely `kubectl`)
sessions on your system. To return to your normal `gcloud` configuration,
you'll need to invoke:

    gcloud config configurations activate default

### KUBECONFIG

`chainctl` uses the environment variable `KUBECONFIG` to point `kubectl` to a
local configuration for the currently active workspace. If you want to execute
arbitrary `kubectl` commands within your workspace, export `KUBECONFIG` first,
like so:

    export KUBECONFIG=$PWD/.kube/config

### Pulling and pushing configuration

`chainctl` supports pulling down and replacement of secrets and configuration
maps. It uses a naming convention for these files to determine how to
synchronize them with your cluster. Secrets are named like so:
`$name.secret.$format` where `$name` is the name of the secret as it should
appear in `kubectl` and $format can be one of `yaml`, `env`, `crt` or `key`.

For configmaps the convention is `$name.configmap.$format` where `$name` is the
name of the configmap and `$format` can be one of `yaml` or `env`.

At any time, you should only ever have *one* format for a configuration type.
If you have more than one format, `chainctl` will error out and refuse to
continue.

#### Logs

You can see logs of containers by finding the corresponding pod
id with `make info` and using the commands below:

```
kubectl logs po/testnet-deploy-84c6b4686c-kkp5x chainlink
kubectl logs po/testnet-deploy-84c6b4686c-kkp5x ethereum
```

#### Copying Files

```
kubectl cp $POD_ID:data/chainlink/logs.jsonl ./your/local/directory
```

#### Restarting a Deployment

```
kubectl scale --replicas=0 deployment.extensions/ethereum-deploy
kubectl scale --replicas=1 deployment.extensions/ethereum-deploy
```
