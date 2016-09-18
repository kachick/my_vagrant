# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu14.04.with_docker"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3000 # I don't know why this is a mandatory ... :<

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    # Below is adjusted to Ubuntu 14.0.4

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
    sudo n stable
    sudo ln -sf /usr/local/bin/node /usr/bin/node
    sudo apt-get purge -y nodejs npm
    # sudo n 5.2.0
    
    # Config iptables
    # ref: http://azwoo.hatenablog.com/entry/2015/03/11/143248
    # http://askubuntu.com/questions/339790/how-can-i-prevent-apt-get-aptitude-from-showing-dialogs-during-installation
    sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT
    # echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
    # echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
    # http://mktktmr.hatenablog.jp/entry/2016/04/08/213840
    # sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent

    cd /vagrant
    # cd exists_project1
    bundle install

    # I don't plan to install zsh and the more tools... Basically I want to develop on my Mac OS X. This script prepares running environment only :<
    
    # Run rails
    # bundle exec rails server -p 3000 -b 0.0.0.0 # Since rails 4.2, The `-b 0.0.0.0` is mandatory for the VMs ref: http://qiita.com/hurukiyokimura/items/bd517c463d24ea9059f3
  SHELL
end
