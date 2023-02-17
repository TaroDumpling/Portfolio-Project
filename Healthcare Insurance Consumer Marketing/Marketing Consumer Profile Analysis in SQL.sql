-- The age range for this dataset is 18-64
Select distinct age
FROM expense
ORDER BY age

-- The charge per person for middle age group = $15,193
-- The charge per person for adult group = $9,397
SELECT
avg(charges) as charge_per_person,
(CASE
WHEN age >= 18 AND age <=30 THEN 'adult'
WHEN age >30 AND age <=64 THEN 'middle_age'
END) as age_group
FROM expense
GROUP BY 
(CASE WHEN age >= 18 AND age <=30 THEN 'adult'
WHEN age >30 AND age <=64 THEN 'middle_age'
END)

-- The charge per person for middle age group is about 62% higher than adult age group.
SELECT
(AVG(CASE WHEN age >30 AND age <=64 THEN charges END)
/
AVG(CASE WHEN age >= 18 AND age <=30 THEN charges END)-1)*100
FROM expense


-- The charge per person for smoker = $32,050
-- The charge per person for non-smoker = $8,434
SELECT
avg(charges) as charge_per_person,
smoker
FROM expense
GROUP BY smoker

-- The charge per person for smoker is about 280% higher than non-smoker.
SELECT
(AVG(CASE WHEN smoker = 'yes' THEN charges END)
/
AVG(CASE WHEN smoker = 'no' THEN charges END)-1)*100
FROM expense

-- The total amount of the company's adult customers = 444
-- The total amount of the company's middle age customers = 894
select 
SUM(CASE WHEN age >= 18 AND age <=30 THEN 1 ELSE 0 END) as total_adult_customer,
SUM(CASE WHEN age >30 AND age <=64 THEN 1 ELSE 0 END) as total_middle_age_customer
FROM expense

-- The total amount of the company's smoking customers = 274
-- The total amount of the company's non-smoking customers = 1064
select 
SUM(CASE WHEN smoker = 'yes' THEN 1 ELSE 0 END) as total_smoking_customer,
SUM(CASE WHEN smoker = 'no' THEN 1 ELSE 0 END) as total_non_smoking_customer
FROM expense
