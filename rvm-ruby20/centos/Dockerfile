FROM centos:6.6

MAINTAINER Dmytro Kovalov <dmytro.kovalov@gmail.com>

run yum install -y epel-release

RUN yum makecache

RUN yum install -y curl git

RUN useradd -ms /bin/bash deploy

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

RUN yum install -y which        # CentOS by default does not include
                                # which ???? RVM needs it.
RUN yum install -y tar          # same as above

# Install RVM and Ruby
# ----------------------
RUN \curl -sSL https://get.rvm.io | bash

RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.0.0-p247"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
