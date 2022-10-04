----- Link for Tableau Visualization: https://tinyurl.com/3ba3bk79


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

--Platform_Popularity_Count:
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
		  AND PlatformHaveWorkedWith <> 'NA'
	),
PlatformSplits as (
	SELECT ResponseID, value as PlatformSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (PlatformHaveWorkedWith, ';')
	)
SELECT PlatformSplits, count(PlatformSplits) as Platform_Counts
FROM PlatformSplits
GROUP BY PlatformSplits
ORDER BY Platform_Counts DESC;

--Language_Popularity_Count
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
		  AND LanguageHaveWorkedWith <> 'NA'
	),
LanguageSplits as (
	SELECT ResponseID, value as LanguageSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (LanguageHaveWorkedWith, ';')
	)
SELECT LanguageSplits, count(LanguageSplits) as Language_Counts
FROM LanguageSplits
GROUP BY LanguageSplits
ORDER BY Language_Counts DESC;

--Database_Popularity_Count
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
		  AND DatabaseHaveWorkedWith <> 'NA'
	),
DatabaseSplits as (
	SELECT ResponseID, value as DatabaseSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (DatabaseHaveWorkedWith, ';')
	)
SELECT DatabaseSplits, count(DatabaseSplits) as Database_Counts
FROM DatabaseSplits
GROUP BY DatabaseSplits
ORDER BY Database_Counts DESC;

-- 2. Analyst employment rate per country with less than 2 year of coding experience (any coding education also counts toward coding experience).
-- Reason for why I divide by the total amount of people who are analyst is because I'm not competing against people from different careers such as developers and engineers for an analyst spot.
-- To increase data accuracy, I add a fliter condition where there has to be at least 100 rows per country whose job is analyst and employment status can't be null. If less than 100 rows, it won't be included in the result. 
-- This is to avoid certain countries with extremely small sample size, since the results are not significant and they can skew the overall trend.
SELECT
	Country,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(count(*) AS FLOAT)),3) as candidate_success_rate
FROM 
	(SELECT 
		Country, 
		YearsCode, 
		Employment,
		DevType 
	FROM Background_Table 
	WHERE Devtype LIKE '%analyst%' 
	AND employment <> 'NA'
	AND Country <> 'NA'
	) as flitered_table
GROUP BY Country
HAVING sum(CASE WHEN Devtype LIKE '%analyst%' THEN 1 ELSE 0 END) >= 100
ORDER BY candidate_success_rate DESC

-- 3. Analyst employment rate per education level.
-- I will account for the case where there has to be at least 100 rows per education whose current job is analyst and employment status can't be null, making sure the result is significant.
SELECT
	Edlevel,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(count(*) AS FLOAT)),3) as candidate_success_rate
FROM 
	(SELECT 
		Edlevel, 
		YearsCode, 
		Employment,
		DevType 
	FROM Background_Table 
	WHERE Devtype LIKE '%analyst%' 
	AND employment <> 'NA'
	AND EdLevel <> 'NA'
	) as flitered_table
GROUP BY EdLevel
HAVING sum(CASE WHEN Devtype LIKE '%analyst%' THEN 1 ELSE 0 END) >= 100
ORDER BY candidate_success_rate DESC

-- 4. Analyst employment rate per working model (remote/hybrid/in-person) with less than 2 year of coding experience.
-- I will account for the case where there has to be at least 100 rows per working model whose current job is analyst and employment status can't be null, making sure the result is significant.
SELECT
	RemoteWork,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(count(*) AS FLOAT)),3) as candidate_success_rate
FROM 
	(SELECT 
		RemoteWork, 
		YearsCode, 
		Employment,
		DevType 
	FROM Background_Table b
	JOIN Company_Table c
		ON b.ResponseID = c.ResponseID
	WHERE Devtype LIKE '%analyst%' 
	AND employment <> 'NA'
	AND RemoteWork <> 'NA'
	) as flitered_table
GROUP BY RemoteWork
HAVING sum(CASE WHEN Devtype LIKE '%analyst%' THEN 1 ELSE 0 END) >= 100
ORDER BY candidate_success_rate DESC


-- 5. Analyst global employment rate with less than 2 year of coding experience.
SELECT 
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(COUNT(*) AS FLOAT)) ,3) as candidate_success_rate
FROM 
	(SELECT 
		YearsCode, 
		Employment,
		DevType 
	FROM Background_Table b
	JOIN Company_Table c
		ON b.ResponseID = c.ResponseID
	WHERE Devtype LIKE '%analyst%' 
	AND employment <> 'NA'
	) as flitered_table


-- Creating View to store data for later visualizations

--1. Platform_Popularity_Count
CREATE VIEW Platform_Popularity_View as

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
		  AND PlatformHaveWorkedWith <> 'NA'
	),
PlatformSplits as (
	SELECT ResponseID, value as PlatformSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (PlatformHaveWorkedWith, ';')
	)
SELECT PlatformSplits, count(PlatformSplits) as Platform_Counts
FROM PlatformSplits
GROUP BY PlatformSplits
--ORDER BY Platform_Counts DESC;

--2. Language_Popularity_Count
CREATE VIEW Language_Popularity_View as

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
		  AND LanguageHaveWorkedWith <> 'NA'
	),
LanguageSplits as (
	SELECT ResponseID, value as LanguageSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (LanguageHaveWorkedWith, ';')
	)
SELECT LanguageSplits, count(LanguageSplits) as Language_Counts
FROM LanguageSplits
GROUP BY LanguageSplits
--ORDER BY Language_Counts DESC;


--3. Database_Popularity_Count
CREATE VIEW Database_Popularity_View as

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
		  AND DatabaseHaveWorkedWith <> 'NA'
	),
DatabaseSplits as (
	SELECT ResponseID, value as DatabaseSplits
	FROM Employed_Analyst_Table
	CROSS APPLY STRING_SPLIT (DatabaseHaveWorkedWith, ';')
	)
SELECT DatabaseSplits, count(DatabaseSplits) as Database_Counts
FROM DatabaseSplits
GROUP BY DatabaseSplits
--ORDER BY Database_Counts DESC;

--4. Analyst Employment Rate per country with less than 2 years of coding experience.
CREATE VIEW Employment_Success_Rate_Per_Country_View as

SELECT
	Country,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(count(*) AS FLOAT)),3) as candidate_success_rate
FROM 
	(SELECT 
		Country, 
		YearsCode, 
		Employment,
		DevType 
	FROM Background_Table 
	WHERE Devtype LIKE '%analyst%' 
	AND employment <> 'NA'
	AND Country <> 'NA'
	) as flitered_table
GROUP BY Country
HAVING sum(CASE WHEN Devtype LIKE '%analyst%' THEN 1 ELSE 0 END) >= 100
--ORDER BY candidate_success_rate DESC

--5. Analyst Employment Rate per Education Level with less than 2 years of coding experience.
CREATE VIEW Employment_Success_Rate_Per_Education_View as

SELECT
	Edlevel,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(count(*) AS FLOAT)),3) as candidate_success_rate
FROM 
	(SELECT 
		Edlevel, 
		YearsCode, 
		Employment,
		DevType 
	FROM Background_Table 
	WHERE Devtype LIKE '%analyst%' 
	AND employment <> 'NA'
	AND EdLevel <> 'NA'
	) as flitered_table
GROUP BY EdLevel
HAVING sum(CASE WHEN Devtype LIKE '%analyst%' THEN 1 ELSE 0 END) >= 100
--ORDER BY candidate_success_rate DESC

-- 6. Analyst Employment Rate per working model (remote/hybrid/in-person) with less than 2 years of coding experience. 
CREATE VIEW Employment_Success_Rate_Per_Working_Model_View as

SELECT
	RemoteWork,
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(count(*) AS FLOAT)),3) as candidate_success_rate
FROM 
	(SELECT 
		RemoteWork, 
		YearsCode, 
		Employment,
		DevType 
	FROM Background_Table b
	JOIN Company_Table c
		ON b.ResponseID = c.ResponseID
	WHERE Devtype LIKE '%analyst%' 
	AND employment <> 'NA'
	AND RemoteWork <> 'NA'
	) as flitered_table
GROUP BY RemoteWork
HAVING sum(CASE WHEN Devtype LIKE '%analyst%' THEN 1 ELSE 0 END) >= 100
--ORDER BY candidate_success_rate DESC

--7. Analyst global employment rate with less than 2 year of coding experience.
CREATE VIEW Global_Employment_Success_Rate as

SELECT 
	ROUND((COUNT(
	CASE WHEN employment LIKE '%employed%' 
		  AND employment NOT LIKE '%not employed%' 
		  AND employment NOT LIKE '%retired%'
		  AND employment NOT LIKE 'I prefer not to say'
		  AND employment NOT LIKE '%independent contractor%'
		  AND YearsCode < 2
	THEN employment END)
	/
	CAST(COUNT(*) AS FLOAT)) ,3) as candidate_success_rate
FROM 
	(SELECT 
		YearsCode, 
		Employment,
		DevType 
	FROM Background_Table b
	JOIN Company_Table c
		ON b.ResponseID = c.ResponseID
	WHERE Devtype LIKE '%analyst%' 
	AND employment <> 'NA'
	) as flitered_table
