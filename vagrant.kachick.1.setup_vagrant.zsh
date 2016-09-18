# For Vagrant 1.8.4 + Virtual Box 5.0
# I heard the 1.8.5 and 5.1 has some problems... :<

cd ~
mkdir MyVagrant
cd MyVagrant

vagrant box add ubuntu14.04.with_docker https://github.com/jose-lpa/packer-ubuntu_14.04/releases/download/v2.0/ubuntu-14.04.box
vagrant init ubuntu14.04.with_docker

ln -s exists_project1 ./exists_project1
ln -s exists_project2 ./exists_project2

# Edit the Vagrant
# vim Vagrantfile

vagrant up
vagrant ssh