# DevNet
Configuration for a light Ethereum network to develop and test against.

Provides funding for accounts used in various Smart Contract Kit test suites.

## Requirements

- [Docker](https://www.docker.com/)

## Install
```
docker pull smartcontract/devnet
```

## Run

```
docker run smartcontract/devnet
```

## Run Against Ropsten

This also maps the host machine's port 18545 and 18546 to the containter's ports 8545 and 8546 respectively.

```
docker run -p 18545:8545 -p 18546:8546 smartcontract/devnet:latest --config /devnet/testnet.toml
```


## Deploying Testnet

We use AWS ECS to easily bootstrap and deploy a cluster of docker containers
running Parity against Ropsten with an attached Chainlink node.

#### Requirements:

1. Valid AWS credentials with access id and secret key.
  - Set as ENV vars to `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
2. [`aws` CLI tool](https://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html) installed and configured.
3. [`ecs-cli` CLI tool](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html) installed.

#### Steps:

```
brew install awscli amazon-ecs-cli

# Configure awscli and set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY

./configure-ecs-cli
./testnet-cluster-up
# After completion wait for a minute for resources to be available

ecs-cli compose up
ecs-cli compose ps
ecs-cli logs --task-id 101754fe-2e3f-49a3-9e90-c97d14d505c2 # Replace with your task id
```

#### Splitting logs by container

Chainlink

```
ecs-cli logs --task-id 101754fe-2e3f-49a3-9e90-c97d14d505c2 --container-name chainlink
```

Parity

```
ecs-cli logs --task-id 101754fe-2e3f-49a3-9e90-c97d14d505c2 --container-name parity
```
