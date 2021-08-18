--Cleaning data in SQL

--Standardize date format
select * 
from [dbo].[Nashville Housing ]

Select SaleDateConverted, CONVERT(Date, SaleDate)
from [dbo].[Nashville Housing ]

Update [dbo].[Nashville Housing ]
set SaleDate = CONVERT(Date, SaleDate)

Alter table [dbo].[Nashville Housing ]
Add SaleDateConverted Date;

Update [dbo].[Nashville Housing ]
set SaleDateConverted = CONVERT(Date, SaleDate)


--Populate property address data

Select a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, 
ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[Nashville Housing ] a
JOIN [dbo].[Nashville Housing ] b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[Nashville Housing ] a
JOIN [dbo].[Nashville Housing ] b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into individual columns (Address, City, State)

select PropertyAddress
from [dbo].[Nashville Housing ]

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

from [dbo].[Nashville Housing ]

Alter table [dbo].[Nashville Housing ]
Add PropertySplitAddress nvarchar(255);

Update [dbo].[Nashville Housing ]
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table [dbo].[Nashville Housing ]
Add PropertySplitCity nvarchar(255);

Update [dbo].[Nashville Housing ]
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select *
from [dbo].[Nashville Housing ]


--Splitting owner address

Select *
From [dbo].[Nashville Housing ]
where OwnerAddress is not null

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From [dbo].[Nashville Housing ]

Alter table [dbo].[Nashville Housing ]
Add OwnerSplitAddress nvarchar(255);

Update [dbo].[Nashville Housing ]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter table [dbo].[Nashville Housing ]
Add OwnerSplitCity nvarchar(255);

Update [dbo].[Nashville Housing ]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter table [dbo].[Nashville Housing ]
Add OwnerSplitState nvarchar(255);

Update [dbo].[Nashville Housing ]
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--Change Y and N to YES and NO in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From [dbo].[Nashville Housing ]
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' then 'YES'
	When SoldAsVacant = 'N' then 'NO'
	ELSE SoldAsVacant
END
From [dbo].[Nashville Housing ]

Update [dbo].[Nashville Housing ]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'YES'
	When SoldAsVacant = 'N' then 'NO'
	ELSE SoldAsVacant
END


--Remove Duplicates using CTE
--1. Finding Duplicates

WITH Row_NumCTE AS (
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
			UniqueID
			) Row_Num

from [dbo].[Nashville Housing ]
)
select *
from Row_NumCTE
Where Row_Num > 1
Order by PropertyAddress

--Deleting duplicates

WITH Row_NumCTE AS (
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
			UniqueID
			) Row_Num

from [dbo].[Nashville Housing ]
)
Delete
from Row_NumCTE
Where Row_Num > 1


--Deleting unused columns

select * 
from [dbo].[Nashville Housing ]

ALTER TABLE [dbo].[Nashville Housing ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [dbo].[Nashville Housing ]
DROP COLUMN SaleDate