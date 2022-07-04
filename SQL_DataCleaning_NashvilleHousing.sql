-- All the credit of this DataCleaning goes toward Alex The Analyst on Youtube, I just follow along with his data cleaning to teach myself how to do data cleaning. 
-- Here is the link for the video if you want to see: https://www.youtube.com/watch?v=8rO7ztF4NtU&list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f&index=6
-- I have PRACTICED everything in this Data Cleaning Work.

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  Select *
  From PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format

Alter TABLE NashvilleHousing
ALTER COLUMN [SaleDate] date

-- Populate Property Address Data (There are NULL values)

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [PortfolioProject].[dbo].[NashvilleHousing] as a
JOIN [PortfolioProject].[dbo].[NashvilleHousing] as b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)  --I can also do ISNULL(a.PropertyAddress,NO ADDRESS) , what this means is that when a.PropertyAddress IS NULL, the NULL box will be populated by the word 'NO ADDRESS'.
From [PortfolioProject].[dbo].[NashvilleHousing] as a
JOIN [PortfolioProject].[dbo].[NashvilleHousing] as b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address --In the PropertyAddress column, starts from the first character, then, looking for the number of position for comma from Property Address.  When you put -1, it moves 1 position to the left away from the comma.
, substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as City  --It's referring to the right side of the comma, and len(PropertyAddress) means length of the PropertyAddress, so it goes from 1 position from the right side of the comma to the end of the property address.
From PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySpiltAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySpiltAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)
From PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySpiltCity Nvarchar(255);

Update NashvilleHousing
SET PropertySpiltCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as OwnerSplitAddress   -- PARSENAME is only useful for period, and NOT comma. So you need to replace these comma with period.
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) as OwnerSplitCity
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) as OwnderSplitState
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(225);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(225);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(225);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant) as SoldAsVacantCount
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' Then 'YES'
WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
End
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' Then 'YES'
WHEN SoldAsVacant = 'N' Then 'No'
ELSE SoldAsVacant
End
FROM PortfolioProject.dbo.NashvilleHousing

-- Remove Duplicates
-- We need to partition on things that are unique to each row. In this case, I'm just pretending the UniqueID column doesn't exist.

With RowNumCTE as(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
		         SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) as Row_Num
FROM PortfolioProject.dbo.NashvilleHousing
)
DELETE
From RowNumCTE
Where Row_Num > 1

-- DELETE UNUSED COLUMNS : I know it's not a standard practice to delete data, this is just to show I can do this if needed.

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
