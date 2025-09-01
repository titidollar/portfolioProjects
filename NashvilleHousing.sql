-- Exemple de structure de table
CREATE TABLE nashville_housing (
    UniqueID INT PRIMARY KEY,
    ParcelID VARCHAR(15),
    LandUse VARCHAR(20)
    PropertyAddress TEXT,
    SaleDate DATE,
    SalePrice NUMERIC,
    LegalReference VARCHAR(25),
    SoldAsVacant VARCHAR(5),
    OwnerName TEXT,
    OwnerAddress TEXT,
    Acreage NUMERIC,
    TaxDistrict VARCHAR(20)
    LandValue INT,
    BuildingValue INT,
    TotalValue INT,
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath INT
);

-- psql -U [utilisateur] -d [base_de_données] -f [chemin_vers_fichier.sql]

-- Vérifier les données
SELECT *
FROM "nashville_housing";

-- Standardiser le format de la date

-- En PostgreSQL, il n’y a pas CONVERT, on utilise CAST ou TO_DATE
ALTER TABLE "nashville_housing"
ADD COLUMN "SaleDateConverted" DATE;

UPDATE "nashville_housing"
SET "SaleDateConverted" = CAST("saledate" AS DATE);

-- Remplir les PropertyAddress manquantes

SELECT *
FROM "nashville_housing"
ORDER BY "parcelid";

SELECT a."parcelid", a."propertyaddress", b."parcelid", b."propertyaddress",
       COALESCE(a."propertyaddress", b."propertyaddress")
FROM "nashville_housing" a
JOIN "nashville_housing" b
  ON a."parcelid" = b."parcelid"
 AND a."uniqueid" <> b."uniqueid"
WHERE a."propertyaddress" IS NULL;

UPDATE "nashville_housing" a
SET "propertyaddress" = COALESCE(a."propertyaddress", b."propertyaddress")
FROM "nashville_housing" b
WHERE a."parcelid" = b."parcelid"
  AND a."uniqueid" <> b."uniqueid"
  AND a."propertyaddress" IS NULL;


-- Découper l’adresse en colonnes (Adresse, Ville)

ALTER TABLE "nashville_housing"
ADD COLUMN "PropertySplitAddress" VARCHAR(50);

UPDATE "nashville_housing"
SET "PropertySplitAddress" = SPLIT_PART("propertyaddress", ',', 1);

ALTER TABLE "nashville_housing"
ADD COLUMN "PropertySplitCity" VARCHAR(50);

UPDATE "nashville_housing"
SET "PropertySplitCity" = SPLIT_PART("propertyaddress", ',', 2);


-- Découper l’adresse propriétaire en colonnes (Adresse, Ville, État)

ALTER TABLE "nashville_housing"
ADD COLUMN "OwnerSplitAddress" VARCHAR(50);

UPDATE "nashville_housing"
SET "OwnerSplitAddress" = SPLIT_PART("owneraddress", ',', 1);

ALTER TABLE "nashville_housing"
ADD COLUMN "OwnerSplitCity" VARCHAR(50);

UPDATE "nashville_housing"
SET "OwnerSplitCity" = SPLIT_PART("owneraddress", ',', 2);

ALTER TABLE "nashville_housing"
ADD COLUMN "OwnerSplitState" VARCHAR(50);

UPDATE "nashville_housing"
SET "OwnerSplitState" = SPLIT_PART("owneraddress", ',', 3);

-- Changer Y et N en Yes et No dans "SoldAsVacant"

UPDATE "nashville_housing"
SET "soldasvacant" = CASE 
    WHEN "soldasvacant" = 'Y' THEN 'Yes'
    WHEN "soldasvacant" = 'N' THEN 'No'
    ELSE "soldasvacant"
END;

-- Supprimer les doublons

DELETE FROM "nashville_housing" a
USING (
    SELECT "uniqueid"
    FROM (
        SELECT "uniqueid",
               ROW_NUMBER() OVER (
                 PARTITION BY "parcelid", "propertyaddress", "saleprice", "SaleDateConverted", "legalreference"
                 ORDER BY "uniqueid"
               ) AS row_num
        FROM "nashville_housing"
    ) t
    WHERE t.row_num > 1
) b
WHERE a."uniqueid" = b."uniqueid";

-- Supprimer les colonnes inutiles

ALTER TABLE "nashville_housing"
DROP COLUMN "owneraddress",
DROP COLUMN "taxdistrict",
DROP COLUMN "propertyaddress",
DROP COLUMN "saledate";

