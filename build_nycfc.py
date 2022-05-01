import numpy as np
import os 
import pandas as pd 
import sqlite3

class DatabaseBuilder():
    def __init__(self):
        self.ddl = self._prepare_ddl()
        self.connection = self._reset_connection()
        ddl_in = ' '.join(self.ddl)
        
        self.match_data = pd.read_csv('match.csv')
        data_in = self._prepare_data()
        insert_values = lambda key, val: val.to_sql(
            key
            , self.connection
            , if_exists='append'
            , index=False
        )

        self.connection.cursor().executescript(ddl_in)
        [ insert_values(k, v) for k, v in data_in.items() ]
        self.connection.close()

    def _prepare_ddl(self):
        ddl_dirs = ['_sql_table', '_sql_view']
        ddl_sequence = [
            'dim_competition'
            , 'dim_opponent'
            , 'dim_stadium'
            , 'fact_matches'
            , 'vw_matches_comp'
            , 'vw_mls_regular_season'
        ]
        files = [ self._generate_lookup(d) for d in ddl_dirs ]
        lookup = { k: v for d in files for k, v in d.items() }
        lookup_paths = [ lookup[x] for x in ddl_sequence ]
        sql = [ self._read_file(lp) for lp in lookup_paths ]
        return sql

    def _generate_lookup(self, dir):
        files = [ f for f in os.listdir(dir) if f.endswith('.sql') ]
        names = [ f.split('.')[0] for f in files ]
        paths = [ os.path.join(dir, f) for f in files ]
        lookup_dict =  dict(zip(names, paths))
        return lookup_dict

    def _read_file(self, file):
        with open(file) as f:
            data = f.read().rstrip()
        assert_false = f'this SQL file does not end with a semi-colon: {file}'
        assert data.endswith(';'), assert_false
        return data

    def _reset_connection(self):
        db = 'nycfc.db'
        if os.path.exists(db):
            os.remove(db)
        connection = sqlite3.connect(db)
        return connection

    def _prepare_data(self):
        tables = self._transform_dims()
        tables['fact_matches'] = self.match_data
        return tables

    def _transform_dims(self):
        dimensions = {
            'competition': ['is_competitive_match']
            , 'opponent': ['opponent_nationality']
            , 'stadium': ['location_city', 'location_state', 'location_country']
        }
        dimensions = { f'dim_{k}': self._generate_dim(k, v) for k, v in dimensions.items() }
        return dimensions

    def _generate_dim(self, key, val):
        table_cols = [key, *val]
        df_data = self.match_data[table_cols].drop_duplicates()
        df_data = df_data[df_data[key].notna()]
        self.match_data.drop(columns=val, inplace=True)
        return df_data

def main():
    dbb = DatabaseBuilder()

if __name__ == '__main__':
    main()
