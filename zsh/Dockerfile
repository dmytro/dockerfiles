FROM ortym/ruby2

MAINTAINER Dmytro Kovalov <dmytro.kovalov@gmail.com>

RUN apt-get install -y zsh

ENTRYPOINT . /etc/profile; /bin/zsh -l
RUN git clone https://github.com/dmytro/dotfiles.git /dotfiles
RUN /bin/zsh -lc ". /etc/profile && cd /dotfiles && rake install"

