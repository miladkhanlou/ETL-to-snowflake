USE DATABASE student_data_db;

SELECT * FROM staging.student_data_csv;

-- Insert into dimension tables (_ID will be createed as we added auto incremental as data added to table)
INSERT INTO final.dim_lunch(lunch)
SELECT DISTINCT lunch FROM staging.student_data_csv;

INSERT INTO final.dim_gender(gender)
SELECT DISTINCT gender FROM staging.student_data_csv;

INSERT INTO final.dim_parental_education (parental_level_of_education)
SELECT DISTINCT parental_level_of_education FROM staging.student_data_csv;


INSERT INTO final.dim_race(race)
SELECT DISTINCT race_ethnicity FROM staging.student_data_csv order by race_ethnicity DESC;
SELECT * FROM final.dim_race;

-- #unsucessfull transforming race_id
WITH cte as (
    select 
    DENSE_RANK() OVER (ORDER BY race, case 
                            WHEN race = 'GROUP A' THEN 1
                            WHEN race = 'GROUP B' THEN 2
                            WHEN race = 'GROUP C' THEN 3
                            WHEN race = 'GROUP D' THEN 4
                            WHEN race = 'GROUP E' THEN 5
                            end) as race_id,
    race
        
    FROM final.dim_race
)
select * from cte;

--
DELETE FROM final.dim_race;
SELECT DISTINCT test_preparation_course FROM staging.student_data_csv;

INSERT INTO final.dim_test_preparation_course(test_preparation_course)
SELECT DISTINCT test_preparation_course FROM staging.student_data_csv;
SELECT * FROM final.dim_test_preparation_course;

-- insert into fact table:
insert into final.fact_scores(math_score, reading_score, writing_score, gender_id, lunch_id, parental_education_id, test_preparation_course_id, race_id)
SELECT 
    sc.math_score,
    sc.reading_score,
    sc.writing_score,
    g.gender_id,
    l.lunch_id,
    pe.parental_education_id,
    tpc.test_preparation_course_id,
    r.race_id
FROM staging.student_data_csv sc
JOIN final.dim_gender g ON sc.gender = g.gender
JOIN final.dim_lunch l ON sc.lunch = l.lunch
JOIN final.dim_parental_education pe ON sc.parental_level_of_education = pe.parental_level_of_education
JOIN final.dim_test_preparation_course tpc ON sc.test_preparation_course  = tpc.test_preparation_course
JOIN final.dim_race r ON sc.race_ethnicity = r.race;
select * from final.fact_scores;
