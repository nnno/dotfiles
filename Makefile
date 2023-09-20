
CURRENT_DIR := $(PWD)

help:
	@echo "make install     #=> Install for osx"

install:
	@bash $(CURRENT_DIR)/bin/install_mac.sh