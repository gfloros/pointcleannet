# Default shell is sh, set to bash
SHELL := /bin/bash
# Run as single shell session
.ONESHELL:
# Use bash strict mode
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
.SHELLFLAGS := -eu -o pipefail -c
# Delete target if make rule fails
# https://innolitics.com/articles/make-delete-on-error/
.DELETE_ON_ERROR:

# Warn if using undefined variables
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

CURRENT_DIR := $(shell pwd)

.DEFAULT_GOAL := help

.PHONY: help install env

# Self documenting makefile
# To add documentation for a specific target
# add a comment starting with ## after the rule name
help:
	@echo "OpenSfM"
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

install: ## Install packages and editable install of OpenSfM
	source env/bin/activate
	pip install --trusted-host pypi.org --trusted-host pytorch.org \
		--trusted-host download.pytorch.org --trusted-host files.pypi.org \
		--trusted-host files.pytorch.org torch torchvision torchaudio \
		--index-url https://download.pytorch.org/whl/cpu

env: ## Create a virtual environment, requires virtualenv to already be installed (pip install virtualenv)
	virtualenv env
