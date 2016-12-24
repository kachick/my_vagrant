Do as following...

* **For [Vagrant 1.8.4](https://releases.hashicorp.com/vagrant/1.8.4/) & [Virtual Box 5.0](https://www.virtualbox.org/wiki/Download_Old_Builds_5_0)**
* I heard the 1.8.5 and 5.1 has some problems... :<

```zsh
vagrant box add ubuntu14.04.with_docker https://github.com/jose-lpa/packer-ubuntu_14.04/releases/download/v2.0/ubuntu-14.04.box

cd ~/repos
git clone git@github.com:kachick/my_vagrant.git
cp -p ./my_vagrant/Vagrantfile ./
cp -rp ./my_vagrant/vagrant_scripts ./

# NOTE: We can not access as these when the origin directory has can not to be accessed from the guest OS
# ln -s exists_project1/ ./exists_project1
# ln -s exists_project2/ ./exists_project2
# Then it will be `cp -p` and `rsync` way? :cry:

vagrant up
vagrant ssh
```

How to check the network via one line HTTP server
---

On guest OS
```shell
chruby ruby-2.3.3
ruby -rwebrick -e 'WEBrick::HTTPServer.new(:DocumentRoot => "./", :Port => 8000).start'
```

On Host OS

1. Add `192.168.33.10   vagrant.develop` into your /etc/hosts
2. Access `http://vagrant.develop:8000`

Note
---

* 当初zsh周りとか触るつもりまったくなかったんだけど、rails server 叩くだけでもある程度要るなと思ったので最低限な感じで入れた。同じくgitの設定もしといた方が色々と楽になりそう。

使い方
---

1. Vagrant と VirtualBox インストールして
2. 自分のリポジトリトップへ移動して
3. Vagrantfile と vagrant_scripts をこのリポジトリからコピーして
4. `vagrant up` # 初回は大分時間かかる。
5. Add https://github.com/mitchellh/vagrant/blob/master/contrib/sudoers/osx into bottom of `sudo visudo` on your Mac OS X # http://qiita.com/yungsang/items/68f0ac35cd2774b3b957
6. `vagrant ssh` でログインして `cd /vagrant` すると、ゲストOSからリポジトリトップを触ることが出来る。
7.
  * ホストOS上のエディタで適当に開発する
  * ゲストOS上から `rails server` し、いつものオプションに `-b 0.0.0.0` を加えるようにする。
  * ホストOSからのアクセスは `192.168.33.10` 宛にする。
