FROM ubuntu:14.04

# Ruby
# ----------------------
MAINTAINER Dmytro Kovalov <dmytro.kovalov@gmail.com>

RUN apt-get update && \
    apt-get install -y  \
    aptitude \
    curl \
    git \
    ruby2.0 \
    ruby2.0-dev \
    build-essential

RUN update-alternatives \
    --install /usr/bin/ruby ruby /usr/bin/ruby2.0 50 \
    --slave /usr/bin/irb irb /usr/bin/irb2.0 \
    --slave /usr/bin/rake rake /usr/bin/rake2.0 \
    --slave /usr/bin/gem gem /usr/bin/gem2.0 \
    --slave /usr/bin/rdoc rdoc /usr/bin/rdoc2.0 \
    --slave /usr/bin/testrb testrb /usr/bin/testrb2.0 \
    --slave /usr/bin/erb erb /usr/bin/erb2.0 \
    --slave /usr/bin/ri ri /usr/bin/ri2.0

RUN update-alternatives --config ruby
RUN update-alternatives --display ruby

RUN gem install bundler --no-ri --no-rdoc
