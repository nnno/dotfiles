# Makefile for Mac setup

.PHONY: mac-init mac-setup mac-brew mac-all \
        rpi4-init rpi4-setup rpi4-all \
        wsl_ubuntu-init wsl_ubuntu-setup wsl_ubuntu-all \
        all

# Mac targets
mac-init:
	sh bin/init_mac.sh

mac-setup:
	sh bin/setup_mac.sh

mac-brew:
	$(HOME)/.homebrew/bin/brew bundle --file=brew/Brewfile

mac-all: mac-init mac-setup mac-brew

# Raspberry Pi 4 targets
rpi4-init:
	bin/init_rpi4.sh

rpi4-setup:
	bin/setup_rpi4.sh

rpi4-all: rpi4-init rpi4-setup

# WSL Ubuntu targets
wsl_ubuntu-init:
	bin/init_wsl_ubuntu.sh

wsl_ubuntu-setup:
	bin/setup_wsl_ubuntu.sh

wsl_ubuntu-all: wsl_ubuntu-init wsl_ubuntu-setup

# Default: Mac
all: mac-all
# 他環境の場合は all: rpi4-all や all: wsl_ubuntu-all などに変更してください
