# NYCFC Match Database
This repo contains a Python script and supporting SQL files that expect a CSV of NYCFC match data, from which to refresh a normalized database for analyses. The script also accepts a single user input to indicate whether a new record of match data is available via a JSON file, to be appended to the CSV prior to the refresh.

## Disclaimer
This repo does not support the historical data collection efforts that have been requisite to this work, as the speed at which new data is created does not seem to immediately warrant it. The next iteration of this work will first endeavor to create data models that capture player-level information: changes to the roster, starting line-ups, and in-game events (goals, substitutions, and cards).
