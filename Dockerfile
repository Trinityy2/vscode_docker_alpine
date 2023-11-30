FROM python:3.12.0-slim-bookworm as base

RUN apt-get update && apt-get upgrade &&\
    apt-get -y install wget  &&\
    apt-get -y install openssh-server &&\
    apt-get -y install gpg &&\
    apt-get -y install apt-transport-https &&\
    apt-get -y install git

RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm -f packages.microsoft.gpg && \
    apt-get update && \
    apt-get -y install code

RUN useradd -ms /bin/bash code_user

USER code_user
WORKDIR /home/code_user

CMD ["code", "tunnel", "--name", "home-server"]