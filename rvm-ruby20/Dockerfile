FROM ubuntu:14.04

MAINTAINER Dmytro Kovalov <dmytro.kovalov@gmail.com>

RUN apt-get update
RUN apt-get install -y aptitude curl git

RUN useradd -ms /bin/bash deploy

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash

RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.0.0-p247"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

ENTRYPOINT . /etc/profile.d/rvm.sh; /bin/bash -l
# USER deploy
