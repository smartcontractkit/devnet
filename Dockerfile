FROM parity/parity:v1.11.8
COPY . /devnet
WORKDIR /devnet
ENTRYPOINT ["/parity/parity"]
CMD ["--config", "/devnet/miner.toml"]

EXPOSE 8546
EXPOSE 8545
EXPOSE 8180
EXPOSE 8080
EXPOSE 30303
EXPOSE 30303/udp
