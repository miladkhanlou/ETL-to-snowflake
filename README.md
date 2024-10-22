# Student Performance ETL Pipeline
This project implements an ETL pipeline to process and load student performance data into Snowflake using Python, Pandas, and SQLAlchemy. The project consists of a Flask web service to expose the dataset, followed by the extraction, transformation, and loading of data into Snowflake for further analysis.

## Project Overview:
* Source Data: The student performance dataset contains student scores across math, reading, and writing, along with demographic information such as gender, race/ethnicity, and parental education.
* ETL Pipeline: The ETL pipeline is built using a combination of Flask for serving the CSV data, Pandas for transformation, and SQLAlchemy for loading data into Snowflake.
* Data Storage: The transformed data is stored in a Snowflake database for further analysis and querying.


## Features:
### Flask API:
* Serves the CSV file via an endpoint.
* Provides both CSV and JSON formats for data retrieval.

### Data Transformation:
* Renames columns for better readability and standardization (e.g., race/ethnicity to RACE_ETHNICITY).
* Uses Pandas to perform the transformation.

### Loading to Snowflake:
* Data is loaded into a Snowflake table using SQLAlchemy and Snowflake Connector for Python.
* Automatically verifies the data insertion by querying the Snowflake table.


## Data Transformation & Loading steps (ETL Process)
### Extraction: 
Data is fetched from the Flask API (/csvdata).
### Transformation:
- Renames columns to uppercase and standardizes field names.
- Inspects data types for consistency.
### Loading:
- Uses SQLAlchemy to connect to Snowflake.
- Loads the transformed data into a Snowflake table.
- Verifies data loading by running a simple SELECT query.
### How to Run:
- Ensure the Flask API is running.
- Run the Load.py script to execute the ETL process.
---
## SQL Scripts for Data Staging and Transformation
- Files:
  - staging_data.sql: SQL scripts for staging raw data in Snowflake.
  - transformation.sql: SQL scripts for transforming staged data into the final table structure.
  - load.sql: SQL scripts for loading transformed data into the final table.

## Technologies Used:
- **Flask**: Web framework used to serve CSV and JSON data.
- **Pandas**: For data transformation and preparation.
- **Snowflake**: Cloud-based data warehousing solution where the data is stored and queried.
- **SQLAlchemy**: Used to connect to and interact with Snowflake.
- **Snowflake Connector**: For loading data into Snowflake directly from a Pandas DataFrame.

