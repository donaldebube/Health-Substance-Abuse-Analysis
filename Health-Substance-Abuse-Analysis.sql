SELECT *
FROM SubstanceAbuseProgramme

SELECT CONVERT(DATE, [Admission Date]), MONTH([Admission Date]), DATENAME(MONTH, [Admission Date])
FROM SubstanceAbuseProgramme
GO

-- Clean the data

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
SET 
    Program = 'Usual Care'
WHERE Program = 'UsualCare'

-- Replace F with Female and M with Male for better understanding.
-- For Male
UPDATE SubstanceAbuseProgramme
SET 
    Gender = 'Male' 
WHERE Gender = 'M'
-- For Female
UPDATE SubstanceAbuseProgramme
SET 
    Gender = 'Female'
WHERE Gender = 'F'

-- Replace the Null values with 0 because null is giving a count of 0, which is incorrect
UPDATE SubstanceAbuseProgramme
SET 
    MedDx = 0
WHERE MedDx = 6


-- Change the values present in the Race Etnicity column for clarity
-- Hispanic = Hispanic or Latino
-- NativeAm = Native American
-- NonHispBlack = African American alone non-Hispanic
-- NonHispWhite = White alone non-Hispanic

-- Verification
SELECT DISTINCT [Race Ethnicity]
FROM SubstanceAbuseProgramme

-- Update data in column
-- For Hispanic or Latino Category 
UPDATE SubstanceAbuseProgramme
SET 
    [Race Ethnicity] = 'Hispanic or Latino'
WHERE [Race Ethnicity] = 'Hispanic'

-- For Native American
UPDATE SubstanceAbuseProgramme
SET 
    [Race Ethnicity] = 'Native American'
WHERE [Race Ethnicity] = 'NativeAm'

-- For African American alone non-Hispanic
UPDATE SubstanceAbuseProgramme
SET 
    [Race Ethnicity] = 'African American alone non-Hispanic'
WHERE [Race Ethnicity] = 'NonHispBlack'

-- For White alone non-Hispanic
UPDATE SubstanceAbuseProgramme
SET 
    [Race Ethnicity] = 'White alone non-Hispanic'
WHERE [Race Ethnicity] = 'NonHispWhite'



-- For Analysis

-- Create an Age Range for Analysis Purpose (1)
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


-- Gender Count (3)
SELECT DISTINCT Gender, COUNT(Gender) AS [Total Count]
FROM SubstanceAbuseProgramme
GROUP BY Gender


-- Here, we can see that the month of February had the highest number of admissions (4)
SELECT DISTINCT 
    TOP 10 [Admission Date], 
    DATENAME(MONTH, ([Admission Date])) AS Month, 
    COUNT([Admission Date]) AS Count
FROM SubstanceAbuseProgramme
GROUP BY [Admission Date]
ORDER BY [COUNT] DESC


--  Compare different hospitalization programs.(5)
-- What conclusion(s) can you draw from it?
SELECT DISTINCT *
FROM SubstanceAbuseProgramme

-- Total Insight
SELECT Program, Gender, [Age Range]
FROM SubstanceAbuseProgramme

-- Total Count of both Usual Care and Intervention Patients
SELECT DISTINCT Program, COUNT(Program) AS [Total Count]
FROM SubstanceAbuseProgramme
GROUP BY Program
GO



-- For Program

-- Create VIEWS FOR THE FOLLOWING:

-- Number of both Usual Care and Intervention Patients by Gender (Male)
CREATE VIEW VWProgramMale
AS
    SELECT DISTINCT Program, COUNT(Gender) AS [Total No of Male]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Male' 
    GROUP BY Program, Gender
GO

-- Run VWProgramMale View
SELECT *
FROM VWProgramMale
GO

-- Number of both Usual Care and Intervention Patients by Gender (Female)
CREATE VIEW VWProgramFemale
AS
    SELECT DISTINCT Program, COUNT(Gender) AS [Total No of Female]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Female'
    GROUP BY Program
GO

-- Run VWProgramFemale View
SELECT *
FROM VWProgramFemale
GO

-- Join the VWProgramFemale and the VWProgramMale VIEWS to create a single Table
SELECT 
    M.Program, 
    M.[Total No of Male], 
    F.[Total No of Female], 
    M.[Total No of Male] + F.[Total No of Female] AS [Total Gender]
FROM VWProgramMale M
INNER JOIN VWProgramFemale F
    ON M.Program = F.Program
GO


-- Create VIEWS FOR THE FOLLOWING:

-- Number of both Usual Care and Intervention Patients by Race Ethnicity (African American alone non-Hispanic) 
CREATE VIEW VWProgramByRaceEthnicityAfricanAmerican
AS
    SELECT DISTINCT Program, COUNT([Race Ethnicity]) AS [Total No of African American alone non-Hispanic ]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'African American alone non-Hispanic'
    GROUP BY Program
GO

-- Run VWProgramByRaceEthnicityAfricanAmerican View
SELECT *
FROM VWProgramByRaceEthnicityAfricanAmerican
GO

-- Number of both Usual Care and Intervention Patients by Race Ethnicity (Hispanic or Latino) 
CREATE VIEW VWProgramByRaceEthnicityHispanicorLatino
AS
    SELECT Program, COUNT([Race Ethnicity]) AS [Total No of Hispanic or Latino]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Hispanic or Latino'
    GROUP BY Program
GO

-- Run VWProgramByRaceEthnicityHispanicorLatino View
SELECT *
FROM VWProgramByRaceEthnicityHispanicorLatino
GO

-- Number of both Usual Care and Intervention Patients by Race Ethnicity (Native American) 
CREATE VIEW VWProgramByRaceEthnicityNativeAmerican
AS
    SELECT Program, COUNT([Race Ethnicity]) AS [Total No of Native American]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Native American'
    GROUP BY Program
GO

-- Run VWProgramByRaceEthnicityHispanicorLatino View
SELECT *
FROM VWProgramByRaceEthnicityNativeAmerican
GO

-- Number of both Usual Care and Intervention Patients by Race Ethnicity (Other) 
CREATE VIEW VWProgramByRaceEthnicityOther
AS
    SELECT Program, COUNT([Race Ethnicity]) AS [Total No of Other]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Other'
    GROUP BY Program
GO

-- Run VWProgramByRaceEthnicityNativeAmerican View
SELECT *
FROM VWProgramByRaceEthnicityOther
GO

-- Number of both Usual Care and Intervention Patients by Race Ethnicity (White alone non-Hispanic) 
CREATE VIEW VWProgramByRaceEthnicityWhitealonenonHispanic
AS
    SELECT Program, COUNT([Race Ethnicity]) AS [Total No of White alone non-Hispanic]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'White alone non-Hispanic'
    GROUP BY Program
GO

-- Run VWProgramByRaceEthnicityWhitealonenonHispanic View
SELECT *
FROM VWProgramByRaceEthnicityWhitealonenonHispanic
GO


-- JOIN VWProgramByRaceEthnicityWhitealonenonHispanic, VWProgramByRaceEthnicityNativeAmerican, VWProgramByRaceEthnicityHispanicorLatino and VWProgramByRaceEthnicityAfricanAmerican VIEWS
SELECT 
    AA.Program, 
    AA.[Total No of African American alone non-Hispanic ],
    HL.[Total No of Hispanic or Latino], 
    NA.[Total No of Native American], 
    O.[Total No of Other], 
    WH.[Total No of White alone non-Hispanic],
    AA.[Total No of African American alone non-Hispanic ] + HL.[Total No of Hispanic or Latino] + NA.[Total No of Native American] + O.[Total No of Other] + WH.[Total No of White alone non-Hispanic] AS [Total Count]
FROM VWProgramByRaceEthnicityAfricanAmerican AS AA
INNER JOIN VWProgramByRaceEthnicityHispanicorLatino AS HL
    ON AA.Program = HL.Program
INNER JOIN VWProgramByRaceEthnicityNativeAmerican AS NA
    ON AA.Program = NA.Program
INNER JOIN VWProgramByRaceEthnicityOther AS O
    ON AA.Program = O.Program
INNER JOIN VWProgramByRaceEthnicityWhitealonenonHispanic AS WH
    ON AA.Program = WH.Program
GO


-- Create VIEWS FOR THE FOLLOWING:

-- Number of both Usual Care and Intervention Patients by Age Range (Adult)
CREATE VIEW VWProgramByAgeRangeAdult 
AS 
    SELECT DISTINCT Program, COUNT([Age Range]) AS [Total No of Adult Category]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Adult'
    GROUP BY Program
GO

-- Run VWProgramByAgeRangeAdult View
SELECT *
FROM VWProgramByAgeRangeAdult 
GO


-- Number of both Usual Care and Intervention Patients by Age Range (Senior Citizen)
CREATE VIEW VWProgramByAgeRangeSeniorCitizen
AS   
    SELECT Program, COUNT([Age Range]) AS [Total No of Senior Citizen Category]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Senior Citizen'
    GROUP BY Program
GO

-- Run VWProgramByAgeRangeSeniorCitizen View
SELECT *
FROM VWProgramByAgeRangeSeniorCitizen 
GO


-- Number of both Usual Care and Intervention Patients by Age Range (Teenager)
CREATE VIEW VWProgramByAgeRangeTeenager
AS
    SELECT Program, COUNT([Age Range]) AS [Total No of Teenager Category]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Teenager'
    GROUP BY Program
GO

-- Run VWProgramByAgeRangeTeenager View
SELECT *
FROM VWProgramByAgeRangeTeenager 
GO


-- Number of both Usual Care and Intervention Patients by Age Range (Young Adult)
CREATE VIEW VWProgramByAgeRangeYoungAdult
AS
    SELECT Program, COUNT([Age Range]) AS [Total No of Young Adult Category]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Young Adult'
    GROUP BY Program
GO

-- Run VWProgramByAgeRangeYounGAdult View
SELECT *
FROM VWProgramByAgeRangeYoungAdult
GO

-- JOIN VWProgramByAgeRangeAdult, VWProgramByAgeRangeSeniorCitizen, VWProgramByAgeRangeTeenager AND VWProgramByAgeRangeYoungAdult
SELECT 
    A.Program,
    A.[Total No of Adult Category],
    SC.[Total No of Senior Citizen Category],
    T.[Total No of Teenager Category],
    YA.[Total No of Young Adult Category],
    A.[Total No of Adult Category] + SC.[Total No of Senior Citizen Category] + T.[Total No of Teenager Category] + YA.[Total No of Young Adult Category] AS [Total Count]
FROM VWProgramByAgeRangeAdult AS A
INNER JOIN VWProgramByAgeRangeSeniorCitizen AS SC
    ON A.Program = SC.Program
INNER JOIN VWProgramByAgeRangeTeenager AS T
    ON A.Program =T.Program
INNER JOIN VWProgramByAgeRangeYoungAdult AS YA
    ON A.Program = YA.Program
GO




--  For Race Ethnicity
SELECT DISTINCT [Race Ethnicity], COUNT([Race Ethnicity]) AS [Total Count]
FROM SubstanceAbuseProgramme
GROUP BY [Race Ethnicity]

SELECT DISTINCT [Race Ethnicity], COUNT(Gender) AS [Male Count]
FROM SubstanceAbuseProgramme
WHERE Gender = 'Male'
GROUP BY [Race Ethnicity]
GO

-- Create View For Just Male Gender in the Race Ethnicity Column
CREATE VIEW VWRaceEthnicityMale
AS
    SELECT DISTINCT [Race Ethnicity], COUNT(Gender) AS [Male Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Male'
    GROUP BY [Race Ethnicity]
GO

-- Run VWRaceEthnicityMale
SELECT *
FROM VWRaceEthnicityMale
GO

-- Create View For Just Female Gender in the Race Ethnicity Column
CREATE VIEW VWRaceEthnicityFemale
AS
    SELECT [Race Ethnicity], COUNT(Gender) AS [Female Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Female'
    GROUP BY [Race Ethnicity]
GO

-- Run VWRaceEthnicityFemale
SELECT *
FROM VWRaceEthnicityFemale

-- JOIN VWRaceEthnicityFemale and VWRaceEthnicityMale
SELECT 
    F.[Race Ethnicity], 
    F.[Female Count], 
    M.[Male Count], 
    F.[Female Count] + M.[Male Count] AS [Total Count]
FROM VWRaceEthnicityFemale AS F
INNER JOIN VWRaceEthnicityMale AS M
ON F.[Race Ethnicity] = M.[Race Ethnicity]
GO


-- I would like to find out the different Age Ranges that are prominent in the different Race Ethnicity.

SELECT DISTINCT [Age Range]
FROM SubstanceAbuseProgramme
GO


-- Create View For Just Adult category in the Race Ethnicity Column
CREATE VIEW VWRaceEthnicityAdult
AS
    SELECT [Race Ethnicity], COUNT([Age Range]) AS [Total Count for Adult]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Adult'
    GROUP BY [Race Ethnicity]
GO

-- Run VWRaceEthnicityAdult
SELECT *
FROM VWRaceEthnicityAdult
GO

-- Create View For Just Senior Citizen category in the Race Ethnicity Column
CREATE VIEW VWRaceEthnicitySeniorCitizen
AS
    SELECT [Race Ethnicity], COUNT([Age Range]) AS [Total Count for Senior Citizen]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Senior Citizen'
    GROUP BY [Race Ethnicity]
GO

-- Run VWRaceEthnicitySeniorCitizen
SELECT *
FROM VWRaceEthnicitySeniorCitizen
GO

-- Create View For Just Teenager category in the Race Ethnicity Column
CREATE VIEW VWRaceEthnicityTeenager
AS
    SELECT [Race Ethnicity], COUNT([Age Range]) AS [Total Count for Teenager]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Teenager'
    GROUP BY [Race Ethnicity]
GO

-- Run VWRaceEthnicityTeenager
SELECT *
FROM VWRaceEthnicityTeenager
GO

-- Create View For Just Young Adult category in the Race Ethnicity Column
CREATE VIEW VWRaceEthnicityYoungAdult
AS
    SELECT [Race Ethnicity], COUNT([Age Range]) AS [Total Count for Young Adult]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Young Adult'
    GROUP BY [Race Ethnicity]
GO

-- Run VWRaceEthnicityYoungAdult
SELECT *
FROM VWRaceEthnicityYoungAdult
GO

-- JOIN VWRaceEthnicityAdult, VWRaceEthnicitySeniorCitizen, VWRaceEthnicityTeenager and VWRaceEthnicityYoungAdult VIEWS
SELECT 
    A.[Race Ethnicity],
    A.[Total Count for Adult], 
    SC.[Total Count for Senior Citizen], 
    T.[Total Count for Teenager],
    YA.[Total Count for Young Adult],
    A.[Total Count for Adult] + SC.[Total Count for Senior Citizen] + T.[Total Count for Teenager] + YA.[Total Count for Young Adult] AS [Total Count]
FROM VWRaceEthnicityAdult AS A
INNER JOIN VWRaceEthnicitySeniorCitizen AS SC
    ON A.[Race Ethnicity] = SC.[Race Ethnicity]
INNER JOIN VWRaceEthnicityTeenager AS T
    ON A.[Race Ethnicity] = T.[Race Ethnicity]
INNER JOIN VWRaceEthnicityYoungAdult AS YA
    ON A.[Race Ethnicity] = YA.[Race Ethnicity]
GO




-- For MHDX:
-- MHDX By Gender
-- Create VIEW for the Male Count
CREATE VIEW VWMHDXMaleCount
AS 
    SELECT DISTINCT MHDx, COUNT(Gender) AS [Male Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Male'
    GROUP BY MHDx
GO

-- Run VWMHDXMaleCount
SELECT *
FROM VWMHDXMaleCount
GO

-- Create VIEW for the Male Count
CREATE VIEW VWMHDXMaleCount
AS 
    SELECT DISTINCT MHDx, COUNT(Gender) AS [Male Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Male'
    GROUP BY MHDx
GO

-- Run VWMHDXMaleCount
SELECT *
FROM VWMHDXMaleCount
GO









SELECT *
FROM SubstanceAbuseProgramme


-- Get the avaerage, max, min of the DLA1 and DLA2.

-- SELECT [Race Ethnicity], COUNT(Gender)
-- FROM SubstanceAbuseProgramme
-- WHERE [Race Ethnicity] = 'African American alone non-Hispanic'
-- GROUP BY [Race Ethnicity]



-- SELECT DISTINCT TOP 10 [Admission Date], DATENAME(MONTH, ([Admission Date])) AS MONTH, COUNT([Admission Date]) AS COUNT
-- FROM SubstanceAbuseProgramme
-- GROUP BY [Admission Date]
-- HAVING 
--     DATENAME(MONTH, ([Admission Date])) = 'January' OR 
--     DATENAME(MONTH, ([Admission Date])) = 'February' OR
--     DATENAME(MONTH, ([Admission Date])) = 'March'
-- ORDER BY [COUNT] DESC



