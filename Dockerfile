FROM openethereum/openethereum:latest
COPY . /devnet
USER root
RUN chown -R openethereum /devnet
CMD ["--reseal-max-period", "1000", "--force-sealing", "--config", "/devnet/miner.toml"]

EXPOSE 8546
EXPOSE 8545
EXPOSE 8180
EXPOSE 8080
EXPOSE 30303
EXPOSE 30303/udp
