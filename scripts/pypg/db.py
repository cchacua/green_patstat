import pandas as pd
from pathlib import Path
import psycopg2
from psycopg2 import pool
import io
import sys
sys.path.append('/home/jovyan/input/config')
import pgtkc as pgs

postgreSQL_pool = psycopg2.pool.SimpleConnectionPool(1,20, user = pgs.user,
                    password = pgs.password,
                    host = pgs.host,
                    port = pgs.port,
                    database = pgs.database)
connection  = postgreSQL_pool.getconn()
cursor = connection.cursor()

def create_pandas_table(sql_query, index_col=None, database = connection):
    table = pd.read_sql_query(sql_query, database, index_col)
    connection.commit()
    return table

def copyraw(dataframe, table, connection=connection): 
    # table=schema.table(var1, var2, etc)
    connection.commit()
    cursor = connection.cursor()
    output = io.StringIO() 
    dataframe.to_csv(output, sep='\t', header=False, index=False)
    output.seek(0) 
    copy_query =  f"""COPY {table} FROM STDOUT csv DELIMITER '\t' NULL ''  ESCAPE '\\' """
    cursor.copy_expert(copy_query, output)
    cursor.close()
    connection.commit()
    return True
