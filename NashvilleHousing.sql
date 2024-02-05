--Clearing data in SQL Queries

select *
from Portfolio_Project_Covid.dbo.NashvilleHousing;

---Standardize Date Format

select SaleDate, CONVERT(date, SaleDate)
from Portfolio_Project_Covid.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)


--- Populate property address data


select *
from Portfolio_Project_Covid.dbo.NashvilleHousing
--where PropertyAddress is null;
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio_Project_Covid.dbo.NashvilleHousing a
	join  Portfolio_Project_Covid.dbo.NashvilleHousing b
		on a.ParcelID = b.ParcelID
			and a.UniqueID <> b.UniqueID
	where a.PropertyAddress is null;



	update a
	set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	from Portfolio_Project_Covid.dbo.NashvilleHousing a
	join  Portfolio_Project_Covid.dbo.NashvilleHousing b
		on a.ParcelID = b.ParcelID
			and a.UniqueID <> b.UniqueID
	where a.PropertyAddress is null;



	---Breaking out Address into individual columns (Address,City, State)


	select PropertyAddress
	from Portfolio_Project_Covid.dbo.NashvilleHousing


	select 
	substring (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
	substring (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
	from Portfolio_Project_Covid.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring (PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


select *
from Portfolio_Project_Covid.dbo.NashvilleHousing;



select OwnerAddress
from Portfolio_Project_Covid.dbo.NashvilleHousing;

select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
from Portfolio_Project_Covid.dbo.NashvilleHousing;


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
Add  OwnerSplitCity nvarchar(255);

update NashvilleHousing
set  OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousing
Add  OwnerSplitState nvarchar(255);

update NashvilleHousing
set  OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)


select *
from Portfolio_Project_Covid.dbo.NashvilleHousing;


---Change Y and N to Yes and No in 'SoldAsVacant' field



select distinct(SoldAsVacant), count(SoldAsVacant)
from Portfolio_Project_Covid.dbo.NashvilleHousing
group by SoldAsVacant
order by 2;

select SoldAsVacant,
	case
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end 
from Portfolio_Project_Covid.dbo.NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end 
from Portfolio_Project_Covid.dbo.NashvilleHousing



---- Remove Duplicates

select * from Portfolio_Project_Covid.dbo.NashvilleHousing


with RowNumCTE
 as(
 select *,
ROW_NUMBER() over 
	(partition by 
		ParcelID, 
		PropertyAddress,
		SaleDate,
		SalePrice,
		LegalReference
			order by 
		UniqueID) as row_num
from Portfolio_Project_Covid.dbo.NashvilleHousing
--order by ParcelID
)


delete 
from RowNumCTE
where row_num > 1
--order by PropertyAddress

with RowNumCTE
 as(
 select *,
ROW_NUMBER() over 
	(partition by 
		ParcelID, 
		PropertyAddress,
		SaleDate,
		SalePrice,
		LegalReference
			order by 
		UniqueID) as row_num
from Portfolio_Project_Covid.dbo.NashvilleHousing
--order by ParcelID
)


select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress


--- Delete unused columns


select *
from Portfolio_Project_Covid.dbo.NashvilleHousing


alter table NashvilleHousing
drop column PropertyAddress, OwnerAddress, TaxDistrict

alter table NashvilleHousing
drop column SaleDate