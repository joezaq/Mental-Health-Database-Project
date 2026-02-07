# Mental-Health-Database-Project
The Kaggle dataset is a synthetic collection of information of 1500 individuals diagnosed with Obsessive-Compulsive Disorder (OCD).

## Project Overview
This project focuses on an OCD patient dataset using **MySQL** to discover patterns in diagnosis and treatment. The analysis explores how demographic factors such as age, gender, ethnicity, marital status, and education level relate to depression and anxiety — showcasing trends over time, medication usage and other associated factors.

This project uses patient data to demonstrate how **SQL can be used to make data-driven decisions in mental health research**, answer real-world questions, and extract meaningful insights from structured data.

This project demonstrates practical skills in data cleaning, exploratory analysis, and healthcare analysis.


## Project Objectives
- Create a structured MySQL database for OCD patient records.
- Build data quality checks to ensure reliable results.
- Build efficient queries for mental health data analysis.
- Explore patterns in demographics, diagnosis, and time.
- Answer key clinical and research questions using SQL insights.


## Key Questions Asked 
- I'd like to see the data that shows which year had the most visits by patients?
- Next, let's investigate the 2018 spike. What types of medications were administered during the highest and lowest year visits?
- In addition, Benzodiazepine looks to be the most used, is this the same medication for genders?
- Can you pull the data on the most frequently prescribed medication among patients of Hispanic ethnicity?
- I'd love to see the top ethnicity diagnosed with PTSD?
- Can you pull the data on MDD females who visited before 2022-02-10?
- I'd like to see the number of high school patients with anxiety by gender?


## Data Dictionary
The data consists of 1500 rows, 1393 unique patient rows and 107 duplicate rows.

| Column Name                    | Description                            | Data Type |
|--------------------------------|----------------------------------------|-----------|
| patient_id                     | Unique patient identification          | Integer   |
| age                            | Patient age                            | Integer   |
| gender                         | Patient gender                         | Text      |
| ethnicity                      | Patient ethnicity                      | Text      |
| marital_status                 | Patient marital status                 | Text      |
| education_level                | Patient education level                | Text      |
| ocd_diagnosis_date             | Date of visit                          | Date      |
| duration_of_symptoms_month     | Number of symptoms per month           | Integer   |
| previous_diagnoses             | Patient intial diagnoses               | Text      |
| family_history_of_ocd          | hereditarical history of ocd           | Text      |
| obsession_type                 | Main reoccuring thoughts               | Text      |
| compulsion_type                | Mental action performed                | Text      |
|  y_bocs_score_obsessions       | severity of obsessive behaviors        | Integer   |
| y_bocs_score_compulsions       | severity of compulsive behaviors       | Integer   |
| depression_diagnosis           | Treatment response to depression       | Text      |
| anxiety_diagnosis              | Treatment response to anxiety          | Text      |
| medications                    | Prescribed medications                 | Text      |


## Tools used
- MySQL

## SQL analysis & Queries
#### 1. I'd like to see the data that shows which year had the most visits by patients?
```sql
SELECT 
  YEAR(ocd_diagnosis_date) AS year,
  COUNT(DISTINCT patient_id, YEAR(ocd_diagnosis_date), MONTH(ocd_diagnosis_date)) 
    AS monthly_distinct_visits
FROM dataset
GROUP BY year
ORDER BY monthly_distinct_visits DESC;
-- 2018: 203, 2022: 139, 2013: 18
```


#### 2. Next, let's investigate the 2018 spike. What types of medications were administered during the highest and lowest year visits?
```sql
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
```


#### 3. In addition, Benzodiazepine looks to be the most used, is this the same medication for genders?
```sql
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
```


#### 4. Can you pull the data on the most frequently prescribed medication among patients of Hispanic ethnicity?
```sql
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
```


####  5. I'd love to see the top ethnicity diagnosed with PTSD?
```sql
SELECT 
	ethnicity,
	COUNT(DISTINCT patient_id) AS ptsd_count
FROM dataset
	WHERE previous_diagnoses LIKE '%PTSD%'
GROUP BY ethnicity
ORDER BY ptsd_count DESC;
-- Asian: 82
```


#### 6. Can you pull the data on MDD females who visited before 2022-02-10?
```sql
SELECT 
	COUNT(DISTINCT patient_id) AS female_mdd
FROM dataset
	WHERE gender = 'Female'
		AND previous_diagnoses LIKE '%MDD%'
		AND ocd_diagnosis_date < '2022-02-10';
  -- MDD females: 149
  ```


#### 7. I'd like to see the number of high school patients with anxiety by gender? 
```sql
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
```

## Key Insights
- Patient visits peaked in **2018**.
- Males mainly used Benzodiazepines, while females used SNRIs.
- Female patients had the most prior MDD.
- Asian patients had the highest PTSD history.

## Conclusion
Patient visits peaked in 2018 (203), while 2013 recorded the lowest number (18), and 2022 showed a recent high (139). The difference between 2018 and 2022 was moderate, but the gap between 2018 and 2013 was significant, indicating a major increase in reported mental health cases over time.

Male patients were more likely to be prescribed Benzodiazepines (198) and SNRIs (174), while female patients showed a preference for SNRIs (192) and Benzodiazepines (183). Female patients also recorded the highest number of prior MDD cases before diagnosis.

Additionally, Asian patients had the highest history of PTSD (82), compared with African patients (63), highlighting notable differences in comorbidity across ethnic groups

Overall, the project highlights the importance of **SQL** in **healthcare analysis** and serves as a foundation for more advanced data analytical projects. 

## Data Source
kaggle [here](https://www.kaggle.com/datasets/ohinhaque/ocd-patient-dataset-demographics-and-clinical-data)
