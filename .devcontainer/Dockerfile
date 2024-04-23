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
RUN mkdir /home/${USER}/tmp
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
RUN echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
# verify installation
RUN git clone https://gitlab.com/gitlab-org/gitlab-development-kit.git
WORKDIR /home/${USER}/gitlab-development-kit

RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> ~/.bashrc \
    && . /home/docker/.bashrc \
    && /bin/bash -c "rbenv install 3.2.3" \
    && /bin/bash -c "rbenv global 3.2.3" \
    && gem install gitlab-development-kit \
    && bundle install

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN . ~/.bashrc \
    && nvm install 20.12.2 \
    && nvm use 20.12.2 \
    && npm install -g yarn

RUN make bootstrap-packages

RUN sudo apt install postgresql postgresql-contrib -y

RUN sudo curl "https://dl.min.io/server/minio/release/linux-amd64/minio" --output /usr/local/bin/minio \
    && sudo chmod +x /usr/local/bin/minio

RUN sudo apt install -y wget
RUN wget https://go.dev/dl/go1.21.9.linux-amd64.tar.gz \
    && sudo tar -C /usr/local -xzf go1.21.9.linux-amd64.tar.gz

RUN echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc \
    && . ~/.bashrc \
    && go version

RUN wget https://download.redis.io/releases/redis-7.0.15.tar.gz \
    && tar xzf redis-7.0.15.tar.gz \
    && cd redis-7.0.15 \
    && sudo make install


RUN . ~/.bashrc \
    && gdk install gitlab_repo=https://gitlab.com/gitlab-community/gitlab
