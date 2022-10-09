SELECT *
FROM SubstanceAbuseProgramme

SELECT CONVERT(DATE, [Admission Date]), MONTH([Admission Date]), DATENAME(MONTH, [Admission Date])
FROM SubstanceAbuseProgramme
GO


-- Clean the data

-- Convert the date format to show only date
SELECT DISTINCT [Admission Date]
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
SELECT DISTINCT MedDx
FROM SubstanceAbuseProgramme

-- Get the avaerage, max, min of the DLA1 and DLA2.


-- UPDATE
-- Change Column names
EXEC sp_rename 'SubstanceAbuseProgramme.RaceEthnicity', 'Race Ethnicity' --'COLUMN'
EXEC sp_rename 'SubstanceAbuseProgramme.PsychAdmit', 'Psych Admit' --'COLUMN'