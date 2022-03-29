
import sqlite3

# connecting to a sqlite db and running SQL tables
dbconn = sqlite3.connect('lcdb.db')
dbcursor = dbconn.cursor()
with open('lcdb-ddl.sql', 'r') as lmdb_table_script:
    sql_script = lmdb_table_script.read()
dbcursor.executescript(sql_script)
dbconn.commit()
dbcursor.close()
