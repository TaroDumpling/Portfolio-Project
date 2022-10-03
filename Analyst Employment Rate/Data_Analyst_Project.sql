-- Source from https://insights.stackoverflow.com/survey
-- The survey was fielded from May 11, 2022 to June 1, 2022
-- This data contains 5635211 counts of data. (over 5 millions)

----------------------------------------Data Cleaning--------------------------------------------------------
--1. Removing Duplicates
-- I can do this much easier in Excel, but when the dataset becomes too large, Excel might crash while removing the duplicates, so SQL is better in terms of handling larger dataset.
WITH row_num as (
SELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY
		MainBranch, 
		Employment, 
		RemoteWork,
		CodingActivities,
		EdLevel,
		LearnCode,
		LearnCodeOnline,
		LearnCodeCoursesCert,
		YearsCode,
		YearsCodePro,
		DevType,
		OrgSize,
		PurchaseInfluence,
		BuyNewTool,
		Country,
		Currency,
		CompTotal,
		CompFreq,
		LanguageHaveWorkedWith,
		LanguageWantToWorkWith,
		DatabaseHaveWorkedWith,
		DatabaseWantToWorkWith,
		PlatformHaveWorkedWith,
		PlatformWantToWorkWith,
		WebframeHaveWorkedWith,
		WebframeWantToWorkWith,
		MiscTechHaveWorkedWith,
		MiscTechWantToWorkWith,
		ToolsTechHaveWorkedWith,
		ToolsTechWantToWorkWith,
		NEWCollabToolsHaveWorkedWith,
		NEWCollabToolsWantToWorkWith,
		OpSysProfessionalUse,
		OpSysPersonalUse,
		VersionControlSystem,
		VCInteraction,
		VCHostingPersonalUse,
		VCHostingProfessionalUse, 
		OfficeStackAsyncWantToWorkWith,
		OfficeStackSyncHaveWorkedWith,
		OfficeStackSyncWantToWorkWith,
		Blockchain,
		NEWSOSites,
		SOVisitFreq,
		SOAccount,
		SOPartFreq,
		SOComm,
		Age,
		Gender,
		Trans,
		Sexuality,
		Ethnicity,
		Accessibility,
		MentalHealth,
		TBranch,
		ICorPM,
		WorkExp,
		Knowledge_1,
		Knowledge_2,
		Knowledge_3,
		Knowledge_4,
		Knowledge_5,
		Knowledge_6,
		Knowledge_7,
		Frequency_1,
		Frequency_2,
		Frequency_3,
		TimeSearching,
		TimeAnswering,
		Onboarding,
		ProfessionalTech,
		TrueFalse_1,
		TrueFalse_2,
		TrueFalse_3,
		SurveyLength,
		SurveyEase,
		ConvertedCompYearly
	ORDER BY ResponseId) as row_num
	FROM Cleaned_Project_Table
	)
DELETE
FROM row_num
WHERE row_num > 1;

--2. YearsCode (Including any education, how many years have you been coding in total?)
--this column has null values, since this column doesn't have 0, so I assume that NA stands for no experience in coding, so I will replace null values with 0, so it's easier to code and understand.
UPDATE Cleaned_Project_Table
SET YearsCode = 0
WHERE YearsCode is null;

--3. I can't populate any columns with NULL values because we don't have a reference point.

--4. Create a Company_Table with columns ResponseID, OrgSize, RemoteWork, CompTotal, CompFreq
-- This is just to make things more organized especially when this dataset contains so many columns.
SELECT 
	ResponseID, 
	OrgSize, 
	RemoteWork, 
	CompTotal, 
	CompFreq
INTO Company_Table
FROM Cleaned_Project_Table;

--5. Create a Background_Table with columns ResponseID, MainBranch, YearsCode, Edlevel, Country, Employment, 
-- PlatformHaveWorkedWith, LanguageHaveWorkedWIth, DatabaseHaveWorkedWith, OpSysProfessionalUse, Age, Gender, Ethnicity, WorkExp, DevType
SELECT 
	ResponseID, 
	MainBranch, 
	YearsCode, 
	Edlevel, 
	Country, 
	Employment,
	PlatformHaveWorkedWith, 
	LanguageHaveWorkedWIth, 
	DatabaseHaveWorkedWith, 
	OpSysProfessionalUse, 
	Age, 
	Gender, 
	Ethnicity, 
	WorkExp,
	DevType
INTO Background_Table
FROM Cleaned_Project_Table;

----------------------------------------Data Exploration Query--------------------------------------------------------
-- 1. Most popular/common Platform, Language, and Database total usage count for employed analyst worldwide

--PlatformHaveWorkedWith:
WITH Employed_Analyst_Table as(
	SELECT *
	FROM Background_Table
	WHERE employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND employment <> 'NA'
		  AND Devtype LIKE '%analyst%'
	),
PlatformSplits as (
	SELECT ResponseID, value as PlatformSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (PlatformHaveWorkedWith, ';')
	)
SELECT PlatformSplits, count(PlatformSplits) as Platform_Counts
FROM PlatformSplits
WHERE PlatformSplits != 'NA'
GROUP BY PlatformSplits
ORDER BY 2 DESC;

--LanguageHaveWorkedWith
WITH Employed_Analyst_Table as(
	SELECT *
	FROM Background_Table
	WHERE employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND employment <> 'NA'
		  AND Devtype LIKE '%analyst%'
	),
LanguageSplits as (
	SELECT ResponseID, value as LanguageSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (LanguageHaveWorkedWith, ';')
	)
SELECT LanguageSplits, count(LanguageSplits) as Language_Counts
FROM LanguageSplits
WHERE LanguageSplits != 'NA'
GROUP BY LanguageSplits
ORDER BY 2 DESC;

--DatabaseHaveWorkedWith
WITH Employed_Analyst_Table as(
	SELECT *
	FROM Background_Table
	WHERE employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND employment <> 'NA'
		  AND Devtype LIKE '%analyst%'
	),
DatabaseSplits as (
	SELECT ResponseID, value as DatabaseSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (DatabaseHaveWorkedWith, ';')
	)
SELECT DatabaseSplits, count(DatabaseSplits) as Database_Counts
FROM DatabaseSplits
WHERE DatabaseSplits != 'NA'
GROUP BY DatabaseSplits
ORDER BY 2 DESC;

-- 2. Analyst employment rate per country with less than 2 year of coding experience (any coding education also counts toward coding experience). Is it better if I set the sample size for each country to be at least 100?
-- Reason for why I divide by the total amount of people who are analyst is because I'm not competing against people from different careers such as developers and engineers for an analyst spot.
SELECT country,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND employment <> 'NA'
		  AND YearsCode < 2
		  AND Devtype LIKE '%analyst%'
	THEN employment END)
	/
	CAST(count(CASE WHEN Devtype LIKE '%analyst%' THEN employment END) AS FLOAT)),2) as candidate_success_rate
FROM Background_Table
WHERE country != 'NA'
AND DevType LIKE '%analyst%'
GROUP BY Country
ORDER BY 2 DESC;

-- To increase data accuracy, I add a fliter condition where there has to be at least 100 people whose job is analyst and employment status can't be null in order to be included in the result. 
-- This is to avoid certain countries with extremely small sample size.
WITH row_num as(
	SELECT *, row_number () over (partition by country order by country) as row_num
	FROM Background_Table
	WHERE Devtype LIKE '%analyst%'
	AND employment <> 'NA'
	)
SELECT country,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(count(CASE WHEN Devtype LIKE '%analyst%' THEN employment END) AS FLOAT)),2) as candidate_success_rate
FROM row_num
WHERE country != 'NA'
AND row_num >= 100
GROUP BY Country
ORDER BY 2 DESC;


-- 3. Percentage of data analyst employment rate per education level.
SELECT Edlevel,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND employment NOT LIKE 'NA'
		  AND Devtype LIKE '%analyst%'
	THEN employment END)
	/
	CAST(COUNT(*) AS FLOAT)),2) as candidate_success_rate
FROM Background_Table
WHERE Edlevel != 'NA'
GROUP BY Edlevel
ORDER BY candidate_success_rate DESC;


-- 4. Percentage of data analyst employment rate per working model (remote/hybrid/in-person) with less than 2 year of coding experience.
SELECT RemoteWork,
	   ROUND((COUNT(
	     CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment <> 'NA'
		  AND YearsCode < 2
		  AND Devtype LIKE '%analyst%'
	       THEN employment 
		     END)
	/
	CAST(COUNT(*) AS FLOAT)) *100,2) as candidate_success_rate
	FROM Background_Table b
	JOIN Company_Table c
		ON b.ResponseId = c.ResponseId
	WHERE RemoteWork <> 'NA'
	GROUP BY RemoteWork
	ORDER BY candidate_success_rate DESC;

-- 5. Percentage of data analyst global employment rate with less than 2 year of coding experience.

SELECT 
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment <> 'NA'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(COUNT(*) AS FLOAT)) *100,2) as candidate_success_rate
FROM Background_Table
WHERE country != 'NA'


-- Creating View to store data for later visualizations

--1. Platform_Popularity_Count
CREATE VIEW Platform_Popularity_View as

WITH Employed_Table as(
	SELECT PlatformHaveWorkedWith, LanguageHaveWorkedWith, DatabaseHaveWorkedWith, Employment, Country
	FROM Background_Table
	WHERE employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment <> 'NA'
	),
PlatformSplits as (
	SELECT Country, value as PlatformSplits
	FROM Employed_Table
	CROSS APPLY STRING_SPLIT (PlatformHaveWorkedWith, ';')
	)
SELECT PlatformSplits, count(PlatformSplits) as Platform_Counts
FROM PlatformSplits
WHERE PlatformSplits != 'NA'
GROUP BY PlatformSplits
--ORDER BY 2 DESC;

--2. Language_Popularity_Count
CREATE VIEW Language_Popularity_View as

WITH Employed_Table as(
	SELECT PlatformHaveWorkedWith, LanguageHaveWorkedWith, DatabaseHaveWorkedWith, Employment, Country
	FROM Background_Table
	WHERE employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment <> 'NA'
	),
LanguageSplits as (
	SELECT Country, value as LanguageSplits
	FROM Employed_Table
	CROSS APPLY STRING_SPLIT (LanguageHaveWorkedWith, ';')
	)
SELECT LanguageSplits, count(LanguageSplits) as Platform_Counts
FROM LanguageSplits
WHERE LanguageSplits NOT IN ('NA', ' ', 'V', 'TypeS')
GROUP BY LanguageSplits
--ORDER BY 2 DESC;

--3. Database_Popularity_Count
CREATE VIEW Database_Popularity_View as

WITH Employed_Table as(
	SELECT PlatformHaveWorkedWith, LanguageHaveWorkedWith, DatabaseHaveWorkedWith, Employment, Country
	FROM Background_Table
	WHERE employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment <> 'NA'
	),
DatabaseSplits as (
	SELECT Country, value as DatabaseSplits
	FROM Employed_Table
	CROSS APPLY STRING_SPLIT (DatabaseHaveWorkedWith, ';')
	)
SELECT DatabaseSplits, count(DatabaseSplits) as Platform_Counts
FROM DatabaseSplits
WHERE DatabaseSplits != 'NA'
GROUP BY DatabaseSplits
--ORDER BY 2 DESC;

--4. Employment Rate per country with less than 2 years of coding experience.
CREATE VIEW Employment_Success_Rate_Per_Country_View as
SELECT country,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment <> 'NA'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(COUNT(*) AS FLOAT)) *100,2) as candidate_success_rate
FROM Background_Table
WHERE country != 'NA'
GROUP BY Country
--ORDER BY 2 DESC;

--5. Percentage of data analyst employment rate per education level.
CREATE VIEW Employment_Success_Rate_Per_Education_View as

SELECT Edlevel,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE 'NA'
	THEN employment END)
	/
	CAST(COUNT(*) AS FLOAT)) *100,2) as candidate_success_rate
FROM Background_Table
WHERE Edlevel != 'NA'
GROUP BY Edlevel
--ORDER BY candidate_success_rate DESC;

-- 6. Which working model (remote/hybrid/in-person) has the most success rate in getting hired by a company for an employed person with less than 2 years of coding experience?
CREATE VIEW Employment_Success_Rate_Per_Working_Model_View as

SELECT RemoteWork,
	   ROUND((COUNT(
	     CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment <> 'NA'
		  AND YearsCode < 2
	       THEN employment 
		     END)
	/
	CAST(COUNT(*) AS FLOAT)) *100,2) as candidate_success_rate
	FROM Background_Table b
	JOIN Company_Table c
		ON b.ResponseId = c.ResponseId
	WHERE RemoteWork <> 'NA'
	GROUP BY RemoteWork
	--ORDER BY candidate_success_rate DESC;