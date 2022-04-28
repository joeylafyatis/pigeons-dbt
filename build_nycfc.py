import numpy as np
import os 
import pandas as pd 
import sqlite3

class DatabaseBuilder():
    def __init__(self):
        self.connection = self._reset_connection()
        self.build_order = [
            'dim_competition'
            , 'dim_opponent'
            , 'dim_stadium'
            , 'fact_matches'
            , 'vw_matches_comp'
            , 'vw_mls_regular_season'
        ]
        self._refresh_ddl()
        self._load_csv_data()

    def _reset_connection(self):
        db = 'nycfc.db'
        if os.path.exists(db):
            os.remove(db)
        connection = sqlite3.connect(db)
        return connection

    def _refresh_ddl(self):
        ddl_dirs = ['_sql_table', '_sql_view']
        sql = [ self._read_ddl_dir(x) for x in ddl_dirs ]
        sql = [ query for lst in sql for query in lst ]
        run_ddl = lambda x: self.connection.cursor().executescript(x)
        [ run_ddl(x) for x in sql ]
        
    def _read_ddl_dir(self, dir):
        files = [ f for f in os.listdir(dir) if f.endswith('.sql') ]
        filenames = [ f.split('.')[0] for f in files ]
        paths = [ os.path.join(dir, f) for f in files ]
        contents = [ open(p).read() for p in paths ]
        dict_lookup = dict(zip(filenames, contents))
        queries = [ dict_lookup[x] for x in self.build_order if x in dict_lookup.keys() ]
        return queries

    def _load_csv_data(self):
        tables = self._transform_csv_data()
        insert_values = lambda key, val: val.to_sql(
            key
            , self.connection
            , if_exists='append'
            , index=False
        )
        [ insert_values(k, v) for k, v in tables.items() ]

    def _transform_csv_data(self):
        with open('_csv/match.csv') as f:
            df_data = pd.read_csv(f)
        df_match = df_data.drop(columns=['opponent_nationality', 'location_city', 'location_state', 'location_country', 'is_competitive_match'])

        table_data = {
            'dim_competition': self._transform_dim_table(df_data, ['competition', 'is_competitive_match'])
            , 'dim_opponent': self._transform_dim_table(df_data, ['opponent', 'opponent_nationality'])
            , 'dim_stadium': self._transform_dim_table(df_data, ['stadium', 'location_city', 'location_state', 'location_country'])
            , 'fact_matches': df_match
        }
        return table_data

    def _transform_dim_table(self, df, list_cols):
        df = df[list_cols].drop_duplicates()
        df = df[df[df.columns[0]].notna()]
        return df

def main():
    dbb = DatabaseBuilder()

if __name__ == '__main__':
    main()