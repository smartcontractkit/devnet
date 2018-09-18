# DevNet

Automation for chainlink and ethereum developer nodes.

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

This also maps the host machine's ports 18545 and 18546 to the container's ports 8545 and 8546 respectively.

```
docker run -p 18545:8545 -p 18546:8546 smartcontract/devnet:latest --config /devnet/testnet.toml
```

## Deployment

See the `k8s` or `ecs` folder.
