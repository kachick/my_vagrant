# Below is adjusted to Ubuntu 14.0.4

# PostgreSQL 9.4.n # TODO How to specify the `.n` ?
# 
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
sudo apt-get update

sudo apt-get -y install postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib-9.4

# Mongo DB 3.2
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
# sudo apt-get install -y mongodb-org
sudo apt-get install -y mongodb-org=3.2.9 mongodb-org-server=3.2.9 mongodb-org-shell=3.2.9 mongodb-org-mongos=3.2.9 mongodb-org-tools=3.2.9

echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# chruby - rbenv? I'm okay for it. But it is not make any problem with this. Changing ruby is not a main role of this environment.
pushd /tmp
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
pushd chruby-0.3.9/
sudo make install
popd
popd
echo 'source /usr/local/share/chruby/chruby.sh' >> ~/.bashrc

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
# sudo ruby-install --system ruby 2.3.1 # `sudo` does not fit for this.
ruby-install ruby 2.3.1
source ~/.bashrc

# Redis
sudo apt-get install -y redis-server

cd /vagrant
bundle install

# I don't plan to install zsh and the more tools... Basically I want to develop on my Mac OS X. This script prepares running environment only :<