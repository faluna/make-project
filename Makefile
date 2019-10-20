.PHONY: all
all: ;

.PHONY: setup
build: setup-homebrew setup-env setup-zsh setup-dotfiles setup-poetry neovim setup-alacritty setup-osx
#
# install Command LIne Tools in Mac OS X
#
.PHONY: xcode-select
xcode-select:
	xcode-select --install
#
# homebrew
#
#setup homebrew
.PHONY: setup-homebrew
setup-homebrew: homebrew brew-bundle
# install homebrew
.PHONY: homebrew
homebrew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# brew bundle
.PHONY: brew-bundle
brew-bundle:
	cp ~/make-project/Brewfile ~/.Brewfile
	brew bundle --global
#
# setup MacOS configration
#
.PHONY: setup-osx
setup-osx: osx-defaults

.PHONY: osx-defaults
osx-defaults:
	sh ~/make-project/osx.sh
#
# change shell to zsh
#
.PHONY: setup-zsh
setup-zsh: zsh zsh-completions

.PHONY: zsh
zsh:
	sh ~/make-project/zsh.sh
# zsh completions
.PHONY: zsh-completions
zsh-completions:
	rm -rf $$HOME/.zcompdump; compinit
#
# dotfile
#
# setup dotfiles
.PHONY: setup-dotfiles
setup-dotfiles: dotfiles

.PHONY: dotfiles
dotfiles:
	sh dotfiles.sh
#
# nvim setup
#
.PHONY: setup-neovim
setup-neovim: dotfiles neovim

.PHONY: neovim
neovim:
	zsh ~/dotfiles/nvim/init.sh
#
# font
#
.PHONY: font
font:
	cp -n $${HOME}/Library/Mobile\ Documents/com\~apple\~CloudDocs/fonts/* $${HOME}/Library/Fonts/
	fc-cache -fv
#
# rust
#
.PHONY: setup-rust
setup-rust: rustup rls
#
# rustup
#
.PHONY: rustup
rustup:
	curl https://sh.rustup.rs -sSf | sh
#
# rls
#
.PHONY: rls
rls:
	rustup component add rls-preview
	rustup component add rust-analysis
	rustup component add rust-src
	rustup component add rustfmt
#
# setup env
#
.PHONY: setup-env
setup-env: pyenv goenv nodenv
#
# pyenv
#
.PHONY: pyenv
pyenv:
	anyenv install pyenv
#
# goenv
#
.PHONY: goenv
goenv:
	anyenv install goenv
#
# nodenv
#
.PHONY: nodenv
nodenv:
	anyenv install nodenv
#
# language server protcol for python
#
.PHONY: pyls
pyls:
	pyenv global neovim3 && pip install --upgrade pip
	pyenv global neovim3 && pip install python-language-server
	pyenv global neovim3 && pip install 'python-language-server[yapf]'
	pyenv global neovim3 && pip install 'python-language-server[pycodestyle]'
#
#python
#
# setup poetry
.PHONY: setup-poetry
setup-poetry: poetry poetry-zsh poetry-config
#install poetry
.PHONY: poetry
poetry:
	curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python3
	source $$HOME/.zprofile
#setup for zsh
.PHONY: poetry-zsh
poetry-zsh:
	mkdir -p $$(brew --prefix)/share/zsh/site-functions
	poetry completions zsh > $$(brew --prefix)/share/zsh/site-functions/_poetry
# poetry config
.PHONY: poetry-config
poetry-config:
	mkdir -p $$HOME/.virtualenvs
	poetry config settings.virtualenvs.in-project false
	poetry config settings.virtualenvs.path "$$HOME/.virtualenvs"

#
# Setup alacritty
#
.PHONY: setup-alacritty
setup-alacritty:
	git clone https://github.com/jwilm/alacritty.git ${HOME}/alacritty
	make alacritty_manual
	make alacritty_shell_completions
	make alacritty_terminfo
	make alacritty_cleanup
# manual page
.PHONY: alacritty_manual
alacritty_manual:
	sudo mkdir -p /usr/local/share/man/man1
	cd ${HOME}/alacritty && gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
# shell completions for zsh
.PHONY: alacritty_shell_completions
alacritty_shell_completions:
	mkdir -p ${HOME}/.zsh_functions
	#echo 'fpath+=${HOME}/.zsh_functions' >> ${HOME}/.zshrc
	cd ${HOME}/alacritty && cp extra/completions/_alacritty ${HOME}/.zsh_functions/_alacritty
# Terminfo
.PHONY: alacritty_terminfo
alacritty_terminfo:
	cd ${HOME}/alacritty && sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
# cleanup
.PHONY: alacritty_cleanup
alacritty_cleanup:
	rm -rf ${HOME}/alacritty
