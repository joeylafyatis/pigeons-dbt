SHELL := /bin/zsh

init: 	#Creates a virtual environment with required Python packages 
	@pyenv virtualenv 3.8.12 nycfc; \
	. activate nycfc; \
	pip install -r requirements.txt

db: 	#Runs the Python script that refreshes the NYCFC SQLite database
	@. activate nycfc; \
	. python build_nycfc.py

help: 	#Generates this help menu
	@fgrep -h "#" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/#//'