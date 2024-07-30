-- Check tables in staging schema:
USE DATABASE student_data_db;
USE SCHEMA staging;
SHOW TABLES IN SCHEMA student_data_db.staging;

-- Data Transformation:
select * from staging.student_data_csv
    where
    test_preparation_course is null
    or math_score is null
    or writing_score is null
    or parental_level_of_education is null;

UPDATE staging.student_data_csv
    SET test_preparation_course = COALESCE(test_preparation_course, 'not completed'),
        writing_score = COALESCE(writing_score, 0),
        math_score = COALESCE(math_score, 0)
    where 
        test_preparation_course is null
        or math_score is null
        or writing_score is null
        or parental_level_of_education is null;


    -- find Inconsistent Data:
select * from staging.student_data_csv;
SELECT DISTINCT LUNCH FROM staging.student_data_csv;
SELECT DISTINCT GENDER FROM staging.student_data_csv;
SELECT DISTINCT RACE_ETHNICITY FROM staging.student_data_csv;
SELECT DISTINCT test_preparation_course FROM staging.student_data_csv;
    -- fix typeo
UPDATE staging.student_data_csv
    SET LUNCH = 'standard'
    where LUNCH = 'standarda' 
    or LUNCH = 'standards'
    or LUNCH = 'standardz'
    or LUNCH = '1-standard';

select * from staging.student_data_csv;

-- ---------------------------------------------------------------------------------------------------------------

-- Handling Duplicates:
-- Identify duplicates
SELECT
    GENDER, 
    RACE_ETHNICITY,
    parental_level_of_education,
    LUNCH,
    test_preparation_course,
    math_score,
    writing_score,
    reading_score,
    COUNT(*)
FROM 
    staging.student_data_csv
GROUP BY 
    GENDER, 
    RACE_ETHNICITY,
    parental_level_of_education,
    LUNCH,
    test_preparation_course,
    math_score,
    writing_score,
    reading_score
HAVING 
    COUNT(*) > 1;


-- Remove duplicates V0 byb creating duplicate table:
CREATE OR REPLACE TABLE staging.student_data_csv_dedup AS
SELECT DISTINCT * FROM staging.student_data_csv;
select count(*) from staging.student_data_csv_dedup;


-- Identify and Remove duplicates V1:
CREATE OR REPLACE transient TABLE dup_values as (
    SELECT 
    GENDER, 
        RACE_ETHNICITY,
        parental_level_of_education,
        LUNCH,
        test_preparation_course,
        math_score,
        writing_score,
        reading_score
    FROM 
        staging.student_data_csv
    GROUP BY 
        GENDER, 
        RACE_ETHNICITY,
        parental_level_of_education,
        LUNCH,
        test_preparation_course,
        math_score,
        writing_score,
        reading_score
    HAVING 
        COUNT(*) > 1
);
    -- Remove duplicates
begin transaction;
DELETE FROM staging.student_data_csv a
USING dup_values b
WHERE (a.math_score, a.writing_score, a.reading_score) = (b.math_score, b.writing_score, b.reading_score);
INSERT INTO staging.student_data_csv select * from dup_values;
commit;

-- Check if duplicate values presist
SELECT * FROM staging.dup_values;
SELECT COUNT(*) FROM staging.student_data_csv; -- check the number of rows before deleting the duplicated rows
SELECT * from staging.dup_values a join staging.student_data_csv b where (a.math_score, a.writing_score, a.reading_score) = (b.math_score, b.writing_score, b.reading_score);

SELECT * FROM staging.dup_values a LEFT JOIN student_data_csv b WHERE (a.math_score, a.writing_score, a.reading_score) = (b.math_score, b.writing_score, b.reading_score);
SELECT * FROM staging.dup_values;
SELECT COUNT(*) FROM staging.student_data_csv; -- check the number of rows after deleting the duplicated rows
SELECT COUNT(*) FROM staging.dup_student_data; -- check the number of rows of duplicated table that has duplicated rows
select * from staging.dup_values a join staging.student_data_csv b on (a.math_score, a.writing_score, a.reading_score) = (b.math_score, b.writing_score, b.reading_score);
select * from staging.student_data_csv where math_score = 71;



