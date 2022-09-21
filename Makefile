SHELL := /bin/zsh

init:
	@pyenv virtualenv 3.8.12 nycfc; \
	. activate nycfc; \
	pip install -r requirements.txt

db:
	@. activate nycfc; \
	. python build_nycfc.py
