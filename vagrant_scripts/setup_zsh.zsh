git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
mv -f /vagrant/vagrant_scripts/data/zpreztorc "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  # rm "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo 'source /usr/local/share/chruby/chruby.sh' >> ~/.zshrc
echo 'source /usr/local/share/chruby/auto.sh' >> ~/.zshrc
