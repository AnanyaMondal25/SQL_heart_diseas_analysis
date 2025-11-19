use heart_project;
select * from heart;
#1--  Check out total Records
SELECT COUNT(*) FROM heart;

#2--  Check for null values:
 SELECT * FROM heart WHERE chol IS NULL;
 
 #3-- Count by Categories
 select
 sex, count(*) as count from heart group by sex;
 
 #4--Check chest pain types
 select cp,count(*) as CP_Types from heart group by cp;
 
 #5-- Maximum and minimum cholesterol:
 select max(chol) as max_chol , min(chol) as min_chol from heart ;
 
 #6--Maximum and minimum resting blood pressure:
 SELECT MAX(trestbps) AS max_bp, MIN(trestbps) AS min_bp FROM heart;
 
 #7-- Patients with fasting blood sugar > 120:
 select *from heart;
 select count(*) as high_fbs from heart where fbs=1;
 
 #8-- Patients with heart disease:
 SELECT COUNT(*) AS heart_disease_patients 
FROM heart 
WHERE target = 1;

#### Combine Grouping + Aggregates #####

#9-- Find the youngest member who has high fbs and find the sex 
SELECT age,
       CASE 
           WHEN sex = 1 THEN 'Male'
           WHEN sex = 0 THEN 'Female'
       END AS gender
FROM heart
WHERE fbs = 1
ORDER BY age ASC
LIMIT 1;

#-- 10 Average cholesterol by heart diseas
SELECT target,  AVG(chol) AS avg_chol
FROM heart
GROUP BY target;

# 11-- Average age by gender:
select 
case
when sex=0 then "Female"
when sex=1 then "Male" end as gender ,avg(age) from heart group by sex;


# 12-- Patients with heart disease over age 50
select age , sex from heart  where age>50 and target =1;

# 13-- Top 5 oldest patients with heart disease
select age, sex, cp, chol, target from heart where target =1 order by age DESC LIMIT 5;


# 14--Top 5 patients with highest cholesterol
SELECT age, sex, chol, target
FROM heart
ORDER BY chol DESC
LIMIT 5;

#15-- Average cholesterol by heart disease status
SELECT target, AVG(chol) AS avg_chol
FROM heart
GROUP BY target; 

#16-- Average age by sex
select 
case when sex=1 then "Male" when sex=0 then "Female" end as Gender,avg(age),count(*) as total from heart group by sex;

#17-- Count of patients by chest pain type and target
select * from heart;
select cp,target,count(*) as total from heart group by cp,target order by cp,target;

#18-- Patients with high resting blood pressure and heart disease
select age ,sex trestbps , target from heart where trestbps>140 and target=1 ORDER BY trestbps DESC;

#19-- Average maximum heart rate by sex for heart disease patients
SELECT sex,
       AVG(thalach) AS avg_max_hr
FROM heart
WHERE target = 1
GROUP BY sex;
#20-- Patients with exercise induced angina (exang = 1) over age 60
SELECT age, sex, exang, target
FROM heart
WHERE exang = 1 AND age > 60
ORDER BY age DESC;

#21--Find Top 5 oldest patients with heart disease using RANK
select age,sex,target,
		rank() over (order by age DESC) as age_rank from heart
        where target=1 order by age_rank LIMIT 5;

#22--Find patients with highest cholesterol using DENSE_RANK
SELECT age, sex, chol,
       DENSE_RANK() OVER (ORDER BY chol DESC) AS chol_rank
FROM heart
LIMIT 10; 

#23-- Row number for each patient by age descending
select age ,sex ,
row_number() over(order by age ) as age_row
from heart LIMIT 10;

#24--Average cholesterol by heart disease status as a window function
SELECT *,
       AVG(chol) OVER (PARTITION BY target) AS avg_chol_per_target
FROM heart;

#25--Find top 3 oldest patients per chest pain type 
 SELECT *
FROM (
    SELECT age, sex, cp,
           RANK() OVER (PARTITION BY cp ORDER BY age DESC) AS rank_per_cp
    FROM heart
    WHERE target = 1
) AS ranked_data
WHERE rank_per_cp <= 3;
 