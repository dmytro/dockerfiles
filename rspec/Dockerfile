FROM ortym/ruby2

MAINTAINER Dmytro Kovalov <dmytro.kovalov@gmail.com>

run aptitude update
run aptitude install firefox -y
workdir /app
add install_ruby.sh /


run bash -lc "rvm install 2.1.4"
run bash -lc "rvm use --default 2.1.4"
run bash -lc "gem install bundler --no-ri --no-rdoc"


run aptitude install -y xvfb

run aptitude install -y \
    ca-certificates \
    openjdk-7-jre-headless \
    unzip \
    wget

run aptitude install -y \
    fonts-ipafont-gothic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    xfonts-scalable

run git clone https://github.com/dmytro/selenium-minimal.git /app #4
#run /install_ruby.sh

run bash -lc "bundle install"

# RUN  mkdir -p /opt/selenium \
#   && wget --no-verbose http://selenium-release.storage.googleapis.com/2.44/selenium-server-standalone-2.44.0.jar -O /opt/selenium/selenium-server-standalone.jar

add run_test.sh /run_test.sh
cmd bash -lc /run_test.sh
