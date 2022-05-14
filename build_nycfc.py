import numpy as np
import os 
import pandas as pd 
import sqlite3

class DatabaseBuilder():
    def __init__(self, csv_in):
        self.data = pd.read_csv(csv_in)
        insert_bool = self._prompt_user()
        if insert_bool:
            match = os.path.join('_json', 'match.json')
            self.record = pd.read_json(match, typ='series')
            self.data = self._insert_record(csv_in)

        self.ddl = self._prepare_ddl()
        self.connection = self._reset_connection()
        db_response = self._refresh_db()
        print(db_response)

        self.connection.close()

    def _prompt_user(self):
        message = 'Write new match data to CSV prior to re-building the database? '
        response = input(message)
        response_bool = response.lower() in ('y', 'yes')
        return response_bool

    def _insert_record(self, csv_file):
        is_complete = self._validate_completeness()
        is_unique = self._validate_uniqueness()

        df_record = pd.DataFrame([self.record.to_dict()])
        df_data = pd.concat([self.data, df_record])
        df_data.to_csv(csv_file, index=False)
        return df_data

    def _validate_completeness(self):
        required_fields = [
            'match_date'
            , 'competition'
            , 'opponent'
            , 'is_home_match'
            , 'nycfc_goals'
            , 'opponent_goals'
            , 'result'
        ]
        assertion = not self.record.loc[required_fields].isnull().values.any()
        when_false = 'New match data is missing required fields'
        assert assertion, when_false
        return True

    def _validate_uniqueness(self):
        pk = ['match_date', 'opponent']
        existing_records = self.data[pk]
        compare_values = lambda x: self.data[x] == self.record.get(x)
        assertion = not ((compare_values(pk[0])) & (compare_values(pk[1]))).any()
        when_false = 'New match data duplicates an existing record'
        assert assertion, when_false
        return True

    def _prepare_ddl(self):
        ddl_dirs = ['_sql_table', '_sql_view']
        ddl_sequence = [
            'dim_competition'
            , 'dim_opponent'
            , 'dim_manager'
            , 'dim_stadium'
            , 'dim_player'
            , 'fact_matches'
            , 'fact_lineups'
            , 'fact_goals'
            , 'vw_comp_matches'
            , 'vw_mls_regular_season'
            , 'vw_incomplete_data'
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
        assertion = data.endswith(';')
        when_false = f'this SQL file does not end with a semi-colon: {file}'
        assert assertion, when_false
        return data

    def _reset_connection(self):
        db = 'nycfc.db'
        if os.path.exists(db):
            os.remove(db)
        connection = sqlite3.connect(db)
        return connection

    def _refresh_db(self):
        ddl_in = ' '.join(self.ddl)
        df_in = self._prepare_data()
        insert_values = lambda key, val: val.to_sql(
            key
            , self.connection
            , if_exists='append'
            , index=False
        )
        self.connection.cursor().executescript(ddl_in)
        [ insert_values(k, v) for k, v in df_in.items() ]
        success = "nycfc.db successfully refreshed"
        return success

    def _prepare_data(self):
        tables = self._transform_dims()
        df = self.data
        df['match_year'] = df.match_date.astype('str').str.slice(stop=4).astype('int')
        df['match_month'] = df.match_date.astype('str').str.slice(start=4, stop=6).astype('int')
        df['match_day'] = df.match_date.astype('str').str.slice(start=6, stop=8).astype('int')
        tables['fact_matches'] = df
        return tables

    def _transform_dims(self):
        dimensions = {
            'competition': ['is_competitive_match']
            , 'opponent': ['opponent_nationality']
            , 'manager': ['manager_nationality', 'start_date', 'end_date']
            , 'stadium': ['location_city', 'location_state', 'location_country']
        }
        dimensions = { f'dim_{k}': self._generate_dim(k, v) for k, v in dimensions.items() }
        return dimensions

    def _generate_dim(self, key, val):
        table_cols = [key, *val]
        df_data = self.data[table_cols].drop_duplicates()
        df_data = df_data[df_data[key].notna()]
        self.data.drop(columns=val, inplace=True)
        return df_data

def main():
    dbb = DatabaseBuilder('matches.csv')

if __name__ == '__main__':
    main()
