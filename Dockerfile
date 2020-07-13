FROM parity/parity:v2.7.2-stable
COPY . /devnet
USER root
RUN chown -R parity /devnet
USER parity
WORKDIR /devnet
CMD ["--force-sealing", "--config", "/devnet/miner.toml"]

EXPOSE 8546
EXPOSE 8545
EXPOSE 8180
EXPOSE 8080
EXPOSE 30303
EXPOSE 30303/udp
