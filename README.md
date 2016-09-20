Do as following...

```zsh
# For Vagrant 1.8.4 + Virtual Box 5.0
# I heard the 1.8.5 and 5.1 has some problems... :<

cd ~/repos
git clone git@github.com:kachick/my_vagrant.git
cp ./my_vgarant/Vagrantfile ./
cp ./my_vgarant/vagrant_scripts ./vagrant_scripts

vagrant box add ubuntu14.04.with_docker https://github.com/jose-lpa/packer-ubuntu_14.04/releases/download/v2.0/ubuntu-14.04.box
vagrant init ubuntu14.04.with_docker

# NOTE: We can not access as these when the origin directory has can not to be accessed from the guest OS
# ln -s exists_project1/ ./exists_project1
# ln -s exists_project2/ ./exists_project2
# Then it will be `cp -p` and `rsync` way? :cry:

# Edit the Vagrant
# vim Vagrantfile

vagrant up
vagrant ssh
```
