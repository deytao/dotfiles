git clone https://github.com/deytao/dotfiles.git ~/
cd ~/dotfiles/
git submobule update --init
./install.sh
vim +BundleInstall +qall
