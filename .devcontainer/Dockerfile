FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt update
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:git-core/ppa -y
RUN apt install git make curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev -y

ARG USER=docker
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}


USER docker
WORKDIR /home/${USER}

COPY setup.sh /home/${USER}/
RUN sudo chmod +x setup.sh
RUN ./setup.sh
