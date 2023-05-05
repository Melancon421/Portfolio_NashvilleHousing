-- Removing Times from Date Format

Select *
From SQL_Portfolios.dbo.NashvilleHousingData

-- Removing Time from Date Format
-- The Update function would not register the original Row, so I used the ALTER TABLE Function in tandum with the UPDATE function

Alter table NashvilleHousingData
Add SaleDate_New Date;

Update NashvilleHousingData
Set SaleDate_New = convert(date,Saledate)

-- Replacing Null addresses with matching PARCEL ID values

Select *
From SQL_Portfolios.dbo.NashvilleHousingData
--where PropertyAddress is null
order by ParcelID


Select original.ParcelID, original.PropertyAddress, new.ParcelID, new.PropertyAddress, isnull(Original.PropertyAddress, NEW.PropertyAddress)
From SQL_Portfolios.dbo.NashvilleHousingData Original
join SQL_Portfolios.dbo.NashvilleHousingData NEW
	ON original.ParcelID = NEW.ParcelID
	AND original.[UniqueID ] <> NEW.[UniqueID ]
where original.PropertyAddress is null

Update Original
Set PropertyAddress = isnull(Original.PropertyAddress, NEW.PropertyAddress)
From SQL_Portfolios.dbo.NashvilleHousingData Original
join SQL_Portfolios.dbo.NashvilleHousingData NEW
	ON original.ParcelID = NEW.ParcelID
	AND original.[UniqueID ] <> NEW.[UniqueID ]
where original.PropertyAddress is null

-- Breaking up cells with Commas and period dividers

Select PropertyAddress
From SQL_Portfolios.dbo.NashvilleHousingData
--where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,  LEN(PropertyAddress)) as Address

From SQL_Portfolios.dbo.NashvilleHousingData

Alter table NashvilleHousingData
Add PropertySplitStreet nvarchar(255);

Update NashvilleHousingData
Set PropertySplitStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter table NashvilleHousingData
Add PropertySplitCity nvarchar(255);

Update NashvilleHousingData
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,  LEN(PropertyAddress))


Select *
From SQL_Portfolios.dbo.NashvilleHousingData


Select OwnerAddress
From SQL_Portfolios.dbo.NashvilleHousingData


Select
parsename(replace (OwnerAddress, ',','.'), 3)
, parsename(replace (OwnerAddress, ',','.'), 2)
, parsename(replace (OwnerAddress, ',','.'), 1)
From SQL_Portfolios.dbo.NashvilleHousingData

Alter table NashvilleHousingData
Add OwnerSplitStreet nvarchar(255);

Update NashvilleHousingData
Set OwnerSplitStreet = parsename(replace (OwnerAddress, ',','.'), 3)

Alter table NashvilleHousingData
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousingData
Set OwnerSplitCity = parsename(replace (OwnerAddress, ',','.'), 2)

Alter table NashvilleHousingData
Add OwnerSplitState nvarchar(255);

Update NashvilleHousingData
Set OwnerSplitState = parsename(replace (OwnerAddress, ',','.'), 1)



Select *
From SQL_Portfolios.dbo.NashvilleHousingData



-- Change y and n to "yes" and "no"

Select Distinct SoldAsVacant, Count(SoldAsVacant)
From SQL_Portfolios.dbo.NashvilleHousingData
Group by SoldAsVacant
Order by 2


Select Soldasvacant,
	case when SoldAsVacant = 'y' then 'Yes'
		when SoldAsVacant = 'n' then 'No'
		else SoldAsVacant
		end
From SQL_Portfolios.dbo.NashvilleHousingData


Alter table NashvilleHousingData
Add OwnerSplitState nvarchar(255);

Update NashvilleHousingData
Set SoldAsVacant = case when SoldAsVacant = 'y' then 'Yes'
		when SoldAsVacant = 'n' then 'No'
		else SoldAsVacant
		end
From SQL_Portfolios.dbo.NashvilleHousingData


--Remove Duplicates

WITH RownumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY PARCELID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
				 uniqueid
				 ) row_num
From SQL_Portfolios.dbo.NashvilleHousingData
--order by ParcelID
)
Select *
From RownumCTE
WHERE Row_num > 1
order by Propertyaddress



-- Deleting Unused Columns (Not to be used on "Raw Data"



Select *
From SQL_Portfolios.dbo.NashvilleHousingData


Alter table SQL_Portfolios.dbo.NashvilleHousingData
DROP Column Owneraddress, TaxDistrict, Propertyaddress


Select *
From SQL_Portfolios.dbo.NashvilleHousingData

Alter table SQL_Portfolios.dbo.NashvilleHousingData
DROP Column SaleDate

Select *
From SQL_Portfolios.dbo.NashvilleHousingData