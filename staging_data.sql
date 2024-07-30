-- Creating staging and final area insert raw data to staging area
-- create database and schemas for staging and final areas:
CREATE DATABASE student_data_db;
USE DATABASE student_data_db;
CREATE SCHEMA staging;
CREATE SCHEMA final;

-- Create Staging Tables csv and json:
CREATE TABLE staging.student_data_csv(
    gender STRING,
    race_ethnicity STRING,
    parental_level_of_education STRING,
    lunch STRING,
    test_preparation_course STRING,
    math_score NUMBER(38,0),
    reading_score NUMBER(38,0),
    writing_score NUMBER(38,0)
);
drop table staging.student_data_csv;

CREATE TABLE staging.student_data_json LIKE staging.student_data_csv;

-- Create Final Dimension Tables and fact table:
CREATE TABLE final.dim_lunch(
    lunch_id INT AUTOINCREMENT PRIMARY KEY,
    lunch STRING
);
CREATE TABLE final.dim_parental_education (
    parental_education_id INT AUTOINCREMENT PRIMARY KEY,
    parental_level_of_education STRING
);

CREATE TABLE final.dim_gender (
    gender_id INT AUTOINCREMENT PRIMARY KEY,
    gender STRING
);

CREATE TABLE final.dim_test_preparation_course (
    test_preparation_course_id INT AUTOINCREMENT PRIMARY KEY,
    test_preparation_course STRING
);

CREATE TABLE final.dim_race (
    race_id INT AUTOINCREMENT PRIMARY KEY,
    race STRING
);

-- Create fact table
CREATE TABLE final.fact_scores (
    score_id INT AUTOINCREMENT PRIMARY KEY,
    math_score INTEGER,
    reading_score INTEGER,
    writing_score INTEGER,
    gender_id INT,
    lunch_id INT,
    parental_education_id INT,
    test_preparation_course_id INT,
    race_id INT,
    FOREIGN KEY (gender_id) REFERENCES final.dim_gender(gender_id),
    FOREIGN KEY (lunch_id) REFERENCES final.dim_lunch(lunch_id),
    FOREIGN KEY (parental_education_id) REFERENCES final.dim_parental_education(parental_education_id),
    FOREIGN KEY (test_preparation_course_id) REFERENCES final.dim_test_preparation_course(test_preparation_course_id),
    FOREIGN KEY (race_id) REFERENCES final.dim_race(race_id)
);
-- to insert data from outside source, I ran an app.py tool to create a flask app that works as a end point
-- also a pytjhon script that connects to the flask, gets the data, connects to snowflake database using credentials and inserts data to the existing table


-- Create roles and assign privileges to it to insert data from various sources outside warehouse:
CREATE ROLE ETL_ROLE;
GRANT USAGE ON WAREHOUSE ETL_WAREHOUSE TO ROLE ETL_ROLE;
GRANT USAGE ON DATABASE student_data_db TO ROLE ETL_ROLE;
GRANT USAGE ON SCHEMA student_data_db.staging TO ROLE ETL_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA student_data_db.staging TO ROLE ETL_ROLE;
GRANT ALL PRIVILEGES ON DATABASE student_data_db TO ROLE ETL_ROLE;
-- Verify the Grants:
SHOW GRANTS TO ROLE ETL_ROLE;
-- Assign the Role to a User:
GRANT ROLE ETL_ROLE TO USER miladkhl90;
SHOW GRANTS TO USER miladkhl90;


-- Check tables in staging schema:
USE SCHEMA staging;
SHOW TABLES IN SCHEMA student_data_db.staging;
USE DATABASE student_data_db;

-- Check if data inserted to the table as the extraction part
SELECT * FROM student_data_csv;
SELECT * FROM staging.student_data_csv;

-- describe table to see types null values and other information
DESCRIBE TABLE staging."student_data_csv";
DESCRIBE TABLE staging.student_data;

-- Check tables in final stage:
Show tables in schema student_data_db.final;
use schema final;
select * from final.fact_scores;
