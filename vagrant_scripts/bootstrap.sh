# Below is adjusted to Ubuntu 14.0.4

sudo apt-get update

# Git
# ref:
#  * http://qiita.com/cointoss1973/items/1d419e51dbb8eccae972
#  * http://qiita.com/strsk/items/3a46a27ed12c49740ad3
sudo apt-get install -y software-properties-common python-software-properties
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
# Skip grub ...
# ref: http://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get -y upgrade

# PostgreSQL 9.4.n # How to specify the `.n`?
#
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
sudo apt-get update

sudo apt-get -y install postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib-9.4

# Create `vagrant` role without interactive mode
# https://github.com/thoughtbot/laptop/issues/242#issuecomment-47358513
# https://github.com/diogob/activerecord-postgres-hstore/issues/99
# hstore requires superuser permission...
sudo -u postgres createuser --superuser vagrant

# Mongo DB 3.2
# I'm give up to use apt-get :grin:
# refs:
#   * http://dqn.sakusakutto.jp/2012/04/mongodb-install-linux-javascript.html
#   * https://www.mongodb.com/download-center#community
tmp_mongo_archive=$(mktemp --suffix .tgz)
curl https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-3.2.9.tgz > "$tmp_mongo_archive"
tar xzfv "$tmp_mongo_archive"
pushd mongodb-linux-x86_64-ubuntu1404-3.2.9
mkdir db
mkdir logs
./bin/mongod --fork --dbpath db --logpath logs/log
popd
# FYI: How to stop
# http://d.hatena.ne.jp/msnb125/20140603/1401803075

# chruby - rbenv? I'm okay for it. But it is not make any problem with this. Changing ruby is not a main role of this environment.
pushd /tmp
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
pushd chruby-0.3.9/
sudo make install
popd
popd
echo 'source /usr/local/share/chruby/chruby.sh' >> ~/.bashrc
echo 'source /usr/local/share/chruby/auto.sh' >> ~/.bashrc

# ruby-install
pushd /tmp
wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
tar -xzvf ruby-install-0.6.0.tar.gz
pushd ruby-install-0.6.0/
sudo make install
popd
popd

# Prepare to install Ruby
# ref: http://askubuntu.com/questions/75565/why-am-i-getting-authentication-errors-for-packages-from-an-ubuntu-repository
sudo apt-key update
sudo apt-get update

# Ruby
# sudo ruby-install --system ruby 2.3.1
ruby-install ruby 2.3.1
source ~/.bashrc
chruby ruby-2.3.1
gem update --system
gem install bundler

# Node.js
# ref: http://qiita.com/seibe/items/36cef7df85fe2cefa3ea
sudo apt-get install -y nodejs npm
sudo npm cache clean
sudo npm install n -g
sudo n 5.12.0
sudo ln -sf /usr/local/bin/node /usr/bin/node
sudo apt-get purge -y nodejs npm

sudo npm install -g gulp

# Images
sudo apt-get install -y imagemagick graphicsmagick

# For capybara-webkit ref: https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit
sudo apt-get install -y libqt4-dev libqtwebkit-dev

sudo apt-get install -y redis-server
sudo apt-get install -y memcached

# Config iptables
# ref: http://azwoo.hatenablog.com/entry/2015/03/11/143248
# http://askubuntu.com/questions/339790/how-can-i-prevent-apt-get-aptitude-from-showing-dialogs-during-installation
# sudo iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
# sudo iptables -A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT
sudo iptables -A INPUT -m state --state NEW -m tcp -p tcp -s 192.168.33.1 -m multiport --dports 0:65535 -j ACCEPT
# echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
# echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
# http://mktktmr.hatenablog.jp/entry/2016/04/08/213840
# sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent

# I don't plan to install zsh and the more tools... Basically I want to develop on my Mac OS X. This script prepares running environment only :<
# Updated the my thought :) I want minimumn zsh environments...
sudo apt-get install -y zsh
zsh /vagrant/vagrant_scripts/setup_zsh.zsh
sudo chsh -s /bin/zsh vagrant

# Finished the provision. Following codes are just for reminder how to use

# cd /vagrant
# cd exists_project1
# bundle install

# Run rails
# bundle exec rails server -p 3000 -b 0.0.0.0 # Since rails 4.2, The `-b 0.0.0.0` is mandatory for the VMs ref: http://qiita.com/hurukiyokimura/items/bd517c463d24ea9059f3
