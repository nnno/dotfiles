DOTFILES_GITHUB   := "https://github.com/nnno/dotfiles.git"
DOTFILES_EXCLUDES := .DS_Store .git .gitmodules
DOTFILES_TARGET   := $(wildcard .??*)
DOTFILES_DIR      := $(PWD)
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: install

help:
	@echo "make list        #=> List the files"
	@echo "make update      #=> Fetch changes"
	@echo "make deploy      #=> Create symlink"
	@echo "make init        #=> Setup environment"
	@echo "make install     #=> Update and deploy and initialize"
	@echo "make clean       #=> Remove the dotfiles"
	@echo "make brew        #=> Update brew packages"

list:
	@$(foreach val, $(DOTFILES_FILES), ls -dF $(val);)

update:
	git pull origin main
	git submodule init
	git submodule update

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -snfv $(abspath $(val)) $(HOME)/$(val);)

init:
	@$(foreach val, $(wildcard ./etc/init/*.sh), bash $(val);)

ifeq ($(shell uname), Darwin)
	@$(foreach val, $(wildcard ./etc/init/osx/*sh), bash $(val);)

homebrew:
	@bash $(DOTFILES_DIR)/etc/init/osx/install_homebrew.sh

brew: homebrew
	@-bash $(DOTFILES_DIR)/etc/init/osx/install_brew.sh

endif

install: update deploy init
	@exec $$SHELL

clean:
	@echo "Remove dotfiles in your home directory"
	@-$(foreach val, $(DOTFILES_FILES), rm -vrf $(HOME)/$(val);)
	-rm -rf $(DOTFILES_DIR)
