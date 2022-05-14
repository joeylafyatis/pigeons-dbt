# NYCFC Match Database

This repo contains a Python script and supporting SQL files that expect a CSV of NYCFC match data, from which to refresh a normalized database for analyses. The script also accepts a single user input to indicate whether a new record of match data is available via a JSON file, to be appended to the CSV prior to the refresh.

## Repo Architecture

### Requirements

The main script in this repo is written in Python and will only run if the modules in `requirements.txt` are available.

### DatabaseBuilder

The `build-nycfc.py` Python script consists entirely of a `DatabaseBuilder` class that executes two processes, described below. 

### Database Refresh

The main process within `build-nycfc.py` is a simple ETL that expects `matches.csv`, a CSV of NYCFC match data, from which to to produce `nycfc.db`, a normalized SQLite database file. Neither of these data change files are version-controlled within the repo. 

### SQL Directories

*Work in progress* 

### New Records

An optional process within `build-nycfc.py` appends a new record of match data from `match.json`, found within the `_json/` directory, to the CSV prior to refreshing the database. This data change file is similarly omitted from the repo, though `template.json` in the same directory demonstrates the expected schema structure.

## Disclaimer

This repo does not support the historical data collection efforts that have been requisite to this work, as the speed at which new data is created does not seem to immediately warrant it. The next iteration of this work will first endeavor to create data models that capture player-level information: changes to the roster, starting line-ups, and in-game events (goals, substitutions, and cards).
