import pandas as pd
from sqlalchemy import create_engine
from snowflake.sqlalchemy import URL
from snowflake.connector.pandas_tools import write_pandas, pd_writer

# Load CSV data into DataFrame
csv_url = "http://127.0.0.1:PORT/csvdata"
csv_data = pd.read_csv(csv_url, index_col=False)

#rename columns:
print("Original columns:", csv_data.columns)
column_mapping = {
    'gender': 'GENDER',
    'race/ethnicity': 'RACE_ETHNICITY',
    'parental level of education': 'PARENTAL_LEVEL_OF_EDUCATION',
    'lunch': 'LUNCH',
    'test preparation course': 'TEST_PREPARATION_COURSE',
    'math score': 'MATH_SCORE',
    'reading score': 'READING_SCORE',
    'writing score': 'WRITING_SCORE'
}
csv_data.rename(columns=column_mapping, inplace=True)

# Print the updated column names and data types
print("Updated columns and data types:")
print(csv_data.dtypes)

#Create Snowflake connection URL
url = URL(
    user='miladkhl90',
    password='Mkhanlou90@',
    account='tpmlcpz-dh56639',
    database='student_data_db',
    schema='staging',
    warehouse='ETL_WAREHOUSE'
)

# Create SQLAlchemy engine
engine = create_engine(url)
with engine.connect() as connection:
    csv_data.to_sql('dup_student_data', connection, if_exists='replace', index=False, method=pd_writer)

### Verify data insertion by querying the table
try:
    # Create a connection using the SQLAlchemy engine
    with engine.connect() as connection:
        # Execute the query to check the data
        result = connection.execute("SELECT * FROM dup_student_data LIMIT 10")
        
        # Fetch and print the results
        for row in result:
            print(row)
except Exception as e:
    print(f"An error occurred while verifying data: {e}")
