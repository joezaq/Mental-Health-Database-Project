Use ocd_patient;

Show tables;
-- Checking duplicate primary key (patient_id)

SELECT 
	COUNT(*) AS total_rows,
	COUNT(DISTINCT patient_id) AS unique_patients,
	COUNT(*) - COUNT(DISTINCT patient_id) AS duplicate_rows
FROM dataset;
-- Total row: 1500, Unique patients:1393 Duplicate rows: 107


/*
1. I'd like to see the data that shows which year had the most visits by patients?
*/

SELECT 
  YEAR(ocd_diagnosis_date) AS year,
  COUNT(DISTINCT patient_id, YEAR(ocd_diagnosis_date), MONTH(ocd_diagnosis_date)) 
    AS monthly_distinct_visits
FROM dataset
GROUP BY year
ORDER BY monthly_distinct_visits DESC;
-- 2018: 203, 2022: 139, 2013: 18


/*
2. Next, let's investigate the 2018 spike. What types of medications were administered during the highest and lowest year visits?
*/

SELECT 
	YEAR(ocd_diagnosis_date) AS year,
	medications,
	COUNT(DISTINCT patient_id, YEAR(ocd_diagnosis_date), MONTH(ocd_diagnosis_date)) AS monthly_distinct_visits
FROM dataset
	WHERE YEAR(ocd_diagnosis_date) 
		AND medications <> 'None'
GROUP BY year, medications
ORDER BY monthly_distinct_visits DESC;

-- Benzodiazepine is the most used medication used in 2018 (58)
-- SSRI is the most used medication in 2013 (8)


/*
3. In addition, Benzodiazepine looks to be the most used, is this the same medication for genders?
*/

SELECT 
	gender,
	medications,
	COUNT(DISTINCT patient_id) AS prescription_count
FROM dataset
	WHERE medications <> 'None'
GROUP BY gender, medications
ORDER BY prescription_count DESC;
-- Male: Benzodiazepine (198)
-- Female: SNRI (192)


/*
4. Can you pull the data on the most frequently prescribed medication among patients of Hispanic ethnicity?
*/	

SELECT 
	gender,
	medications,
	COUNT(Distinct patient_id) AS prescription_count
FROM dataset
	WHERE ethnicity = 'Hispanic'
		AND medications <> 'None'
GROUP BY gender, medications
ORDER BY gender, prescription_count DESC;
-- Female: SNRI (58), Male: Benzodiazepine (53)


 /* 
 5. I'd love to see the top ethnicity diagnosed with PTSD?
*/

SELECT 
	ethnicity,
	COUNT(DISTINCT patient_id) AS ptsd_count
FROM dataset
	WHERE previous_diagnoses LIKE '%PTSD%'
GROUP BY ethnicity
ORDER BY ptsd_count DESC;
-- Asian: 82


/* 
6. Can you pull the data on MDD females who visited before 2022-02-10?
*/

SELECT 
	COUNT(DISTINCT patient_id) AS female_mdd
FROM dataset
	WHERE gender = 'Female'
		AND previous_diagnoses LIKE '%MDD%'
		AND ocd_diagnosis_date < '2022-02-10';
  -- MDD females: 149
  
  
/*
7. I'd like to see the number of high school patients with anxiety by gender? 
*/

SELECT
	gender,
	COUNT(DISTINCT patient_id) AS anxiety_highschool_patients
FROM dataset
	WHERE education_level = 'High School'
		AND anxiety_diagnosis = 'Yes'
GROUP BY gender
ORDER BY 2 DESC;
-- Male: 90
-- Female: 83
  