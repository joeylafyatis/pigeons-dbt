# NYCFC Match Database

This repo contains a Python script that refreshes a SQLite database of NYCFC match data. The script first creates an architecture defined in SQL files, and then inserts data retrieved and normalized from a CSV file.

Analyses produced using this database:

- [NYCFC Points per Game: 2022 vs. Other MLS Seasons](https://public.tableau.com/app/profile/joey.lafyatis/viz/NYCFCPointsperGame2022vs_OtherMLSSeasons/CumulativePPGbyMLSMatchday)
- [NYCFC's Team Performance Under Past Managers](https://public.tableau.com/app/profile/joey.lafyatis/viz/NYCFCsTeamPerformanceUnderPastManagers/NYCFCsTeamPerformanceUnderPastManagers#1)

## Requirements

The Python script in this repo will only succeed if the modules in `requirements.txt` are installed and available.

## Overview

`build-nycfc.py` consists entirely of a `DatabaseBuilder` class that executes two independent processes:

### ETL Process

The main process within `DatabaseBuilder` is a simple ETL that expects `matches.csv`, a CSV of NYCFC match data, from which to to produce `nycfc.db`, a normalized SQLite database file. These data change files are not version-controlled within the repo, though the SQL files in `_sql_table/` and `_sql_view/` demonstrate the database architecture. 

### CSV Updates

An optional process within `build-nycfc.py` appends a new record of data from `match.json`, found within the `_json/` directory, to the CSV prior to refreshing the database. This data change file is not version-controlled within the repo, though `template.json` demonstrates its schema.

## Disclaimer

This repo does not include the historical data collection efforts that were requisite to this work, as the speed at which new data is created has not seemed to immediately warrant it. The next iteration of this work will endeavor to create data models that capture player-level information, such as: roster changes, starting line-ups, and in-game events (goals, substitutions, and cards).
