# NYCFC Match Database

This repo contains a Python script that refreshes a SQLite database of NYCFC match data. The script first creates an architecture as defined in SQL files, and then inserts data retrieved and normalized from a CSV file. Here are two examples of analyses produced using this database:

- [NYCFC Points per Game: 2022 vs. Other MLS Seasons](https://public.tableau.com/views/NYCFCCumulativePPG2022vs_OtherMLSSeasons/NYCFCCumulativePPG2022vs_OtherMLSSeasons?:language=en-US&:display_count=n&:origin=viz_share_link)
- [NYCFC's Team Performance Under Past Managers](https://public.tableau.com/app/profile/joey.lafyatis/viz/NYCFCsTeamPerformanceUnderPastManagers/NYCFCsTeamPerformanceUnderPastManagers#1)
- [NYCFC Official Home Attendance by Stadium by Year](https://public.tableau.com/views/NYCFCOfficialHomeAttendancebyStadiumbyYear_16636412122790/NYCFCOfficialAttendanceatHomeStadiums?:language=en-US&:display_count=n&:origin=viz_share_link)

## Requirements

The Python script in this repo will only run successfully if the modules in `requirements.txt` are available to it.

## Overview

`build-nycfc.py` consists entirely of a `DatabaseBuilder` class that executes two independent processes:

### ETL Process

The main process within `DatabaseBuilder` is a simple ETL that expects `matches.csv`, a CSV of NYCFC match data, from which to to produce `nycfc.db`, a normalized SQLite database file. These data change files are not version-controlled within the repo, though the SQL files in `_sql_table/` and `_sql_view/` demonstrate the database architecture. 

### CSV Updates

An optional process within `build-nycfc.py` appends a new record of data from `match.json`, found within the `_json/` directory, to `matches.csv` prior to refreshing the database. This data change file is not version-controlled within the repo, though `template.json` demonstrates its schema and can be copied and renamed locally to enable its intended functionality.

## Disclaimer

This repo does not capture the data collection efforts that were a prerequisite to this work, as the speed at which new data is created has not seemed to immediately warrant it. The next iteration of this work will endeavor to create data models for player-level match information (such starting line-ups, goals, substitutions, and cards), which may impact the need to further automate data collection.
