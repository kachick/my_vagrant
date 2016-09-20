setopt EXTENDED_GLOB
mv ./data/zpreztorc "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
rm "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpreztorc
echo 'source /usr/local/share/chruby/chruby.sh' >> ~/.zshrc
echo 'source /usr/local/share/chruby/auto.sh' >> ~/.zshrc
sudo chsh -s /bin/zsh vagrant
