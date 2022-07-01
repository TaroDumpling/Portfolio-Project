--This project is done by myself
--The following data is found at the following link:
https://data.cityofnewyork.us/Housing-Development/Housing-New-York-Units-by-Building/hg8x-zxpr

USE PortfolioProject
GO
select *
From dbo.HousingNewYorkUnitsByBuild
order by ProjectID

--Removed the Space in between column names such as Project Name, Project Start Date, etc by going to object explorer and rename each individual columns with right click. This helps efficiency when doing the data cleaning, so I don't have to type space key and [] every time.

--Standardize Date Format

ALTER TABLE dbo.HousingNewYorkUnitsByBuild
ALTER COLUMN [ProjectStartDate] date

ALTER TABLE dbo.HousingNewYorkUnitsByBuild
ALTER COLUMN [ProjectCompletionDate] date

ALTER TABLE dbo.HousingNewYorkUnitsByBuild
ALTER COLUMN [BuildingCompletionDate] date

--Check to see if there is need to change Y and N to Yes and No or the other way around in "Extended Affordability Only" field.

Select ExtendedAffordabilityOnly, count(ExtendedAffordabilityOnly)
From dbo.HousingNewYorkUnitsByBuild
Group by ExtendedAffordabilityOnly

--It turns out this column is fine because it only has YES and NO as output. But if this is not the case and I also see Y and N in the ouputs, I can do the following:

UPDATE HousingNewYorkUnitsByBuild
SET ExtendedAffordabilityOnly = CASE WHEN ExtendedAffordabilityOnly = 'Y' Then 'YES'
WHEN ExtendedAffordabilityOnly = 'N' Then 'NO'
ELSE ExtendedAffordabilityOnly
END
FROM dbo.HousingNewYorkUnitsByBuild

--REMOVE DUPLICATES

With RowNumCTE as(
Select*,
	ROW_NUMBER() OVER (
	PARTITION BY ProjectName,
		         ProjectStartDate,
				 ProjectCompletionDate,
				 Street,
				 Postcode
				 ORDER BY
				 ProjectID
				 ) as Row_Num
FROM dbo.HousingNewYorkUnitsByBuild
)
DELETE
FROM RowNumCTE
WHERE Row_Num > 1

-- DELETE UNUSED COLUMNS

ALTER TABLE dbo.HousingNewYorkUnitsByBuild
DROP COLUMN Latitude, Longitude, [Latitude (Internal)], [Longitude (Internal)]
