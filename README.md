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


## Deploying Testnet

We use AWS ECS to easily bootstrap and deploy a cluster of docker containers
running Parity against Ropsten with an attached Chainlink node.

#### Requirements:

1. AWS credentials with access id and secret key, configured for region us-east-1.
2. [`aws` CLI tool](https://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html) installed and configured.
3. [`ecs-cli` CLI tool](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html) installed.

#### Steps:

```
./ecs-cli-configure
./ecs-cli-up
ecs-cli compose up
ecs-cli compose ps
```
