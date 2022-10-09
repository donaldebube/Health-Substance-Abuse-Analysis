SELECT *
FROM SubstanceAbuseProgramme

SELECT CONVERT(DATE, [Admission Date]), MONTH([Admission Date]), DATENAME(MONTH, [Admission Date])
FROM SubstanceAbuseProgramme
GO

-- For Analysis Purpose
SELECT DISTINCT Gender, COUNT(Gender) AS [Total Count]
FROM SubstanceAbuseProgramme
GROUP BY Gender


-- Clean the data

-- Convert the date format to show only date
SELECT DISTINCT [Admission Date]
FROM SubstanceAbuseProgramme

-- Create an Age Range for Analysis Purpose
SELECT DISTINCT Age
FROM SubstanceAbuseProgramme

-- Correct the names of the race ethnicity and update in the table
SELECT DISTINCT RaceEthnicity
FROM SubstanceAbuseProgramme

-- Correct the names of UsualCare to Usual Care
SELECT DISTINCT Program
FROM SubstanceAbuseProgramme

-- Replace F with Female and M with Male for better understanding.
SELECT DISTINCT Gender
FROM SubstanceAbuseProgramme

-- This column does not require any modification
SELECT DISTINCT MHDx
FROM SubstanceAbuseProgramme

-- This column does not require any modification
SELECT DISTINCT SUDx
FROM SubstanceAbuseProgramme

-- Replace the Null values with not given because null is giving a count of 0, which shouldnt't be possible
SELECT DISTINCT MedDx, COUNT(MedDx)
FROM SubstanceAbuseProgramme
GROUP BY MedDx

-- Get the avaerage, max, min of the DLA1 and DLA2.


-- UPDATE
-- Change Column names
EXEC sp_rename 'SubstanceAbuseProgramme.RaceEthnicity', 'Race Ethnicity' --'COLUMN'
EXEC sp_rename 'SubstanceAbuseProgramme.PsychAdmit', 'Psych Admit' --'COLUMN'

-- Convert the date format to show only date
ALTER TABLE SubstanceAbuseProgramme
ALTER COLUMN [Admission Date] DATE
GO
UPDATE SubstanceAbuseProgramme 
SET [Admission Date] = CONVERT(DATE, [Admission Date], 101)
GO

-- Correct the names of UsualCare to Usual Care
UPDATE SubstanceAbuseProgramme
SET Program = 'Usual Care'
WHERE Program = 'UsualCare'

-- Replace F with Female and M with Male for better understanding.
-- For Male
UPDATE SubstanceAbuseProgramme
SET Gender = 'Male' 
WHERE Gender = 'M'
-- For Female
UPDATE SubstanceAbuseProgramme
SET Gender = 'Female'
WHERE Gender = 'F'

-- Replace the Null values with 0 because null is giving a count of 0, which is incorrect
UPDATE SubstanceAbuseProgramme
SET MedDx = 0
WHERE MedDx = 6

-- Create an Age Range for Analysis Purpose
-- Age Range
-- 18-19 = Teenager
-- 20-39 = Young Adult
-- 40-59 = Adult
-- 60 > = Senior Citizen

-- Add new column
ALTER TABLE SubstanceAbuseProgramme
ADD [Age Range] VARCHAR(50)

ALTER TABLE SubstanceAbuseProgramme
    DROP COLUMN [Age Rnage]
GO
-- Insert values
-- Update rows in table 'SubstanceAbuseProgramme'
-- For Teenager Category
UPDATE SubstanceAbuseProgramme
SET
    [Age Range] = 'Teenager' 
WHERE Age < 20
GO

-- For Young Adult Category
UPDATE SubstanceAbuseProgramme
SET
    [Age Range] = 'Young Adult' 
WHERE Age BETWEEN 20 AND 39 
GO

-- For Adult Category
UPDATE SubstanceAbuseProgramme
SET
    [Age Range] = 'Adult' 
WHERE Age BETWEEN 40 AND 59 
GO

-- For Senior Citizen Category
UPDATE SubstanceAbuseProgramme
SET
    [Age Range] = 'Senior Citizen' 
WHERE Age >= 60
GO

-- Verify if there is any NULL value in the Age Range column
-- There is no NULL value
SELECT AGE, [Age Range]
FROM SubstanceAbuseProgramme
WHERE [Age Range] IS NULL
