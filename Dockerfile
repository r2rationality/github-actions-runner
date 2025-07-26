FROM ubuntu:24.04
LABEL MAINTAINER="R2 Rationality <info@r2rationality.com>"
ENV DEBIAN_FRONTEND=noninteractive
ARG REPO

RUN mv /etc/apt/sources.list /etc/apt/sources.list.orig
RUN sed 's/archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list.orig > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y tzdata screen vim-nox dnsutils iputils-ping net-tools curl wget sudo strace gnupg2
RUN ln -fs /usr/share/zoneinfo/Europe/Tallinn /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN cp /etc/sudoers /etc/sudoers.orig
RUN awk '{ if (/^%sudo/) { print "%sudo\tALL=(ALL:ALL) NOPASSWD:ALL" } else { print } }' /etc/sudoers.orig > /etc/sudoers
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 31F54F3E108EAD31
RUN apt-get update
RUN apt-get install -y build-essential cmake pkg-config git zstd
RUN apt-get install -y pv telnet whois
RUN apt-get install -y libboost1.83-all-dev libboost-url1.83-dev libsodium-dev libsecp256k1-dev libzstd-dev libssl-dev libfmt-dev libspdlog-dev libbotan-2-dev
RUN apt-get install -y ninja-build libsecp256k1-dev
RUN apt-get install -y clang-19 clang-tools-19
RUN apt-get install -y docker.io
RUN useradd -m -s /bin/bash -d /home/dev -G sudo dev

USER dev
RUN mkdir -p /home/dev
WORKDIR /home/dev
RUN mkdir actions-runner
WORKDIR /home/dev/actions-runner
RUN curl -o actions-runner-linux-x64-2.308.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-x64-2.308.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.308.0.tar.gz
RUN --mount=type=secret,id=token,uid=1001,gid=1001 TOKEN=$(cat /run/secrets/token) && ./config.sh --url $REPO --token $TOKEN --name "dockerized-runner"
CMD [ "/home/dev/actions-runner/run.sh" ]
