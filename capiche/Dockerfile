FROM ortym/ruby2

RUN apt-get install -y zsh

#
# Copy your *own* Github key as `github.key` into the directory with
# Dockerfile
#

ADD github.key /root/.ssh/github
ADD config /root/.ssh/config

RUN cd / ; git clone git@github.com:Coiney/capiche.git /capiche

RUN /bin/bash -lc  "cd /capiche ; source /etc/profile && bundle install"

RUN cd /capiche && git submodule update --init --recursive

RUN echo ". /etc/profile >> /root/.zsh_profile"

ENTRYPOINT . /etc/profile.d/rvm.sh; /bin/zsh -l
