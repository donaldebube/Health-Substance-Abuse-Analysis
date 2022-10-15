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

-- Create VIEW for the Female Count
CREATE VIEW VWMHDXFemaleCount
AS 
    SELECT DISTINCT MHDx, COUNT(Gender) AS [Female Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Female'
    GROUP BY MHDx
GO

-- Run VWMHDXFemaleCount
SELECT *
FROM VWMHDXFemaleCount
GO

-- JOIN VWMHDXMaleCount and VWMHDXFemaleCount
SELECT 
    MC.MHDx, 
    MC.[Male Count], 
    FC.[Female Count],
    MC.[Male Count] + FC.[Female Count] AS [Total Count]
FROM VWMHDXMaleCount AS MC
INNER JOIN VWMHDXFemaleCount AS FC
    ON MC.MHDx = FC.MHDx
GO

SELECT DISTINCT [Age Range]
FROM SubstanceAbuseProgramme
GO

-- MHDX By Age Range (Adult)
-- Create VIEW for the Adult Count
CREATE VIEW VWMHDXAdult
AS    
    SELECT DISTINCT MHDx, COUNT([Age Range]) AS [Adult Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Adult'
    GROUP BY MHDx
GO

-- Run VWMHDXAdult
SELECT *
FROM VWMHDXAdult
GO

-- MHDX By Age Range (Senior Citizen)
-- Create VIEW for the Senior Citizen Count
CREATE VIEW VWMHDXSeniorCitizen
AS    
    SELECT DISTINCT MHDx, COUNT([Age Range]) AS [Senior Citizen Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Senior Citizen'
    GROUP BY MHDx
GO

-- Run VWMHDXSeniorCitizen
SELECT *
FROM VWMHDXSeniorCitizen
GO

-- MHDX By Age Range (Teenager)
-- Create VIEW for the Teenager Count
CREATE VIEW VWMHDXTeenager
AS    
    SELECT DISTINCT MHDx, COUNT([Age Range]) AS [Teenager Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Teenager'
    GROUP BY MHDx
GO

-- Run VWMHDXTeenager
SELECT *
FROM VWMHDXTeenager
GO

-- MHDX By Age Range (Young Adult)
-- Create VIEW for the Young Adult Count
CREATE VIEW VWMHDXYoungAdult
AS    
    SELECT DISTINCT MHDx, COUNT([Age Range]) AS [Young Adult Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Young Adult'
    GROUP BY MHDx
GO

-- Run VWMHDXYoungAdult
SELECT *
FROM VWMHDXYoungAdult
GO

-- JOIN VWMHDXAdult, VWMHDXSeniorCitizen, VWMHDXTeenager and VWMHDXYoungAdult
SELECT 
    A.MHDx, 
    A.[Adult Count], 
    SC.[Senior Citizen Count], 
    T.[Teenager Count], 
    YA.[Young Adult Count], 
    A.[Adult Count] + SC.[Senior Citizen Count] + T.[Teenager Count] + YA.[Young Adult Count] AS [Total Count]
FROM VWMHDXAdult AS A
INNER JOIN VWMHDXSeniorCitizen AS SC
    ON A.MHDx = SC.MHDx
INNER JOIN VWMHDXTeenager AS T
    ON A.MHDx = T.MHDx
INNER JOIN VWMHDXYoungAdult AS YA
    ON A.MHDx = YA.MHDx
GO




-- MHDX By Race Ethnicity
SELECT DISTINCT [Race Ethnicity]
FROM SubstanceAbuseProgramme
GO

-- MHDX By Race Ethnicity (African American alone non-Hispanic)
-- Create VIEW for the African American alone non-Hispanic Count
CREATE VIEW VWMHDXAfricanAmerican
AS
    SELECT MHDx, COUNT([Race Ethnicity]) AS [African American Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'African American alone non-Hispanic'
    GROUP BY MHDx
GO

-- Run VWMHDXAfricanAmerican
SELECT *
FROM VWMHDXAfricanAmerican
GO

-- Create VIEW for the Hispanic or Latino Count
CREATE VIEW VWMHDXHispanicorLatino
AS
    SELECT MHDx, COUNT([Race Ethnicity]) AS [Hispanic or Latino Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Hispanic or Latino'
    GROUP BY MHDx
GO

-- Run VWMHDXHispanicorLatino
SELECT *
FROM VWMHDXHispanicorLatino
GO

-- Create VIEW for the Hispanic or Latino Count
CREATE VIEW VWMHDXNativeAmerican
AS
    SELECT MHDx, COUNT([Race Ethnicity]) AS [Native American Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Native American'
    GROUP BY MHDx
GO

-- Run VWMHDXNativeAmerican
SELECT *
FROM VWMHDXNativeAmerican
GO

-- Create VIEW for the Other Count
CREATE VIEW VWMHDXOther
AS
    SELECT MHDx, COUNT([Race Ethnicity]) AS [Other Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Other'
    GROUP BY MHDx
GO

-- Run VWMHDXOther
SELECT *
FROM VWMHDXOther
GO

-- Create VIEW for the White alone non-Hispanic Count
CREATE VIEW VWMHDXWhitenonHispanic
AS
    SELECT MHDx, COUNT([Race Ethnicity]) AS [White alone non-Hispanic Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'White alone non-Hispanic'
    GROUP BY MHDx
GO

-- Run VWMHDXWhitenonHispanic
SELECT *
FROM VWMHDXWhitenonHispanic
GO

-- JOIN VWMHDXWhitenonHispanic, VWMHDXOther, VWMHDXNativeAmerican, VWMHDXHispanicorLatino and VWMHDXAfricanAmerican
SELECT 
    WH.MHDx, 
    WH.[White alone non-Hispanic Count],
    O.[Other Count],
    NA.[Native American Count],
    HL.[Hispanic or Latino Count],
    AA.[African American Count]
FROM VWMHDXWhitenonHispanic AS WH
INNER JOIN VWMHDXOther AS O
    ON WH.MHDx = O.MHDx
INNER JOIN VWMHDXNativeAmerican AS NA
    ON WH.MHDx = NA.MHDx
INNER JOIN VWMHDXHispanicorLatino AS HL
    ON WH.MHDx = HL.MHDx
INNER JOIN VWMHDXAfricanAmerican AS AA
    ON WH.MHDx = AA.MHDx
GO




-- For SUDx
SELECT DISTINCT [SUDx]
FROM SubstanceAbuseProgramme
GO

-- SUDx by Gender (Male)
-- CREATE VIEW
CREATE VIEW VWSUDXMALE
AS  
    SELECT SUDx, COUNT(Gender) AS [Male Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Male'
    GROUP BY SUDx
GO

-- Run VWSUDXMALE
SELECT *
FROM VWSUDXMALE
GO

-- SUDx by Gender (Female)
-- CREATE VIEW
CREATE VIEW VWSUDXFEMALE
AS  
    SELECT SUDx, COUNT(Gender) AS [Female Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Female'
    GROUP BY SUDx
GO

-- RUN VWSUDXFEMALE
SELECT *
FROM VWSUDXFEMALE

-- JOIN VWSUDXFEMALE and VWSUDXMALE
SELECT SF.SUDx, SF.[Female Count], SM.[Male Count]
FROM VWSUDXFEMALE AS SF
INNER JOIN VWSUDXMALE AS SM
    ON SF.SUDx = SM.SUDx
GO


-- SUDx by Age Range (Adult)
-- CREATE VIEW
CREATE VIEW VWSUDXAdult
AS    
    SELECT DISTINCT SUDx, COUNT([Age Range]) AS [Adult Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Adult'
    GROUP BY SUDx
GO

-- RUN VWSUDXAdult
SELECT *
FROM VWSUDXAdult
GO

-- SUDx by Age Range (Senior Citizen)
-- CREATE VIEW
CREATE VIEW VWSUDXSeniorCitizen
AS    
    SELECT DISTINCT SUDx, COUNT([Age Range]) AS [Senior Citizen Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Senior Citizen'
    GROUP BY SUDx
GO

-- RUN VWSUDXSeniorCitizen
SELECT *
FROM VWSUDXSeniorCitizen
GO

-- SUDx by Age Range (Teenager)
-- CREATE VIEW
CREATE VIEW VWSUDXTeenager
AS    
    SELECT DISTINCT SUDx, COUNT([Age Range]) AS [Teenager Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Teenager'
    GROUP BY SUDx
GO

-- RUN VWSUDXTeenager
SELECT *
FROM VWSUDXTeenager
GO

-- SUDx by Age Range (Young Adult)
-- CREATE VIEW
CREATE VIEW VWSUDXYoungAdult
AS    
    SELECT DISTINCT SUDx, COUNT([Age Range]) AS [Young Adult Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Young Adult'
    GROUP BY SUDx
GO

-- RUN VWSUDXYoungAdult
SELECT *
FROM VWSUDXYoungAdult
GO

-- JOIN VWSUDXYoungAdult, VWSUDXTeenager, VWSUDXSeniorCitizen and VWSUDXAdult
SELECT 
    SA.SUDx, 
    SA.[Adult Count], 
    SC.[Senior Citizen Count],
    ST.[Teenager Count],
    SY.[Young Adult Count]
FROM VWSUDXAdult AS SA
INNER JOIN VWSUDXSeniorCitizen AS SC
    ON SA.SUDx = SC.SUDx
INNER JOIN VWSUDXTeenager AS ST
    ON SA.SUDx = ST.SUDx
INNER JOIN VWSUDXYoungAdult AS SY
    ON SA.SUDx = SY.SUDx
GO



-- SUDx By Race Ethnicity
SELECT DISTINCT [Race Ethnicity]
FROM SubstanceAbuseProgramme
GO

-- SUDX By Race Ethnicity (African American alone non-Hispanic)
-- Create VIEW for the African American alone non-Hispanic Count
CREATE VIEW VWSUDXAfricanAmerican
AS
    SELECT SUDX, COUNT([Race Ethnicity]) AS [African American Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'African American alone non-Hispanic'
    GROUP BY SUDX
GO

-- Run VWSUDXfricanAmerican
SELECT *
FROM VWSUDXAfricanAmerican
GO

-- Create VIEW for the Hispanic or Latino Count
CREATE VIEW VWSUDXHispanicorLatino
AS
    SELECT SUDx, COUNT([Race Ethnicity]) AS [Hispanic or Latino Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Hispanic or Latino'
    GROUP BY SUDx
GO

-- Run VWSUDXHispanicorLatino
SELECT *
FROM VWSUDXHispanicorLatino
GO

-- Create VIEW for the Hispanic or Latino Count
CREATE VIEW VWSUDXNativeAmerican
AS
    SELECT SUDx, COUNT([Race Ethnicity]) AS [Native American Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Native American'
    GROUP BY SUDx
GO

-- Run VWSUDXNativeAmerican
SELECT *
FROM VWSUDXNativeAmerican
GO

-- Create VIEW for the Other Count
CREATE VIEW VWSUDXOther
AS
    SELECT SUDx, COUNT([Race Ethnicity]) AS [Other Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'Other'
    GROUP BY SUDx
GO

-- Run VWSUDXOther
SELECT *
FROM VWSUDXOther
GO

-- Create VIEW for the White alone non-Hispanic Count
CREATE VIEW VWSUDXWhitenonHispanic
AS
    SELECT SUDx, COUNT([Race Ethnicity]) AS [White alone non-Hispanic Count]
    FROM SubstanceAbuseProgramme
    WHERE [Race Ethnicity] = 'White alone non-Hispanic'
    GROUP BY SUDx
GO

-- Run VWSUDXWhitenonHispanic
SELECT *
FROM VWSUDXWhitenonHispanic
GO

-- JOIN VWSUDXWhitenonHispanic, VWSUDXOther, VWSUDXNativeAmerican, VWSUDXHispanicorLatino, VWSUDXAfricanAmerican
SELECT 
    SW.SUDx,
    SW.[White alone non-Hispanic Count],
    SO.[Other Count],
    SN.[Native American Count],
    SH.[Hispanic or Latino Count],
    SA.[African American Count]
FROM VWSUDXWhitenonHispanic AS SW
INNER JOIN VWSUDXOther AS SO
    ON SW.SUDx = SO.SUDx
INNER JOIN VWSUDXNativeAmerican AS SN
    ON SW.SUDx = SN.SUDx
INNER JOIN VWSUDXHispanicorLatino AS SH
    ON SW.SUDx = SH.SUDx
INNER JOIN VWSUDXAfricanAmerican AS SA
    ON SW.SUDx = SA.SUDx
GO






-- For Psych Admit
-- Total number of Pyschiatric admissions in the last year
SELECT DISTINCT SUM([Psych Admit]) AS [Total Number of Pyschiatric Admission]
FROM SubstanceAbuseProgramme
GO

-- Psych Admit by Gender (Male)
-- CREATE VIEW
CREATE VIEW VWPSYCHMALE
AS
    SELECT Gender, SUM([Psych Admit]) AS [Psych Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Male' 
    GROUP BY Gender
GO

-- To ALTER the data, do this
ALTER VIEW VWPSYCHMALE
AS
    SELECT Gender, SUM([Psych Admit]) AS [Psych Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Male' AND [Psych Admit] != 0
    GROUP BY Gender
GO

-- RUN VWPSYCHMALE
SELECT *
FROM VWPSYCHMALE
GO

-- Psych Admit by Gender (Female)
-- CREATE VIEW
CREATE VIEW VWPSYCHFEMALE
AS
    SELECT Gender, SUM([Psych Admit]) AS [Psych Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Female'
    GROUP BY Gender
GO

-- To ALTER the data, do this
ALTER VIEW VWPSYCHFEMALE
AS
    SELECT Gender, SUM([Psych Admit]) AS [Psych Count]
    FROM SubstanceAbuseProgramme
    WHERE Gender = 'Female' AND [Psych Admit] != 0
    GROUP BY Gender
GO

-- RUN VWPSYCHFEMALE
SELECT *
FROM VWPSYCHFEMALE
GO


-- USE UNION TO JOIN VWPSYCHMALE AND VWPSYCHFEMALE
SELECT *
FROM VWPSYCHMALE
UNION
SELECT*
FROM VWPSYCHFEMALE
GO





-- Psych Admit by Age Range (Adult)
-- CREATE VIEW
CREATE VIEW VWPSYCHADULT
AS
    SELECT [Age Range], COUNT([Psych Admit]) AS [Adult Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Adult' AND [Psych Admit] != 0
    GROUP BY [Age Range]
GO

-- RUN VWPSYCHADULT
SELECT *
FROM VWPSYCHADULT
GO

-- Psych Admit by Age Range (Senior Citizen)
-- CREATE VIEW
CREATE VIEW VWPSYCHSeniorCitizen
AS
    SELECT [Age Range], COUNT([Psych Admit]) AS [Senior Citizen Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Senior Citizen' AND [Psych Admit] != 0
    GROUP BY [Age Range]
GO

-- RUN VWPSYCHSeniorCitizen
SELECT *
FROM VWPSYCHSeniorCitizen
GO

-- Psych Admit by Age Range (Teenager)
-- CREATE VIEW
CREATE VIEW VWPSYCHTeenager
AS
    SELECT [Age Range], COUNT([Psych Admit]) AS [Teenager Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Teenager' AND [Psych Admit] != 0
    GROUP BY [Age Range]
GO

-- RUN VWPSYCHTeenager
SELECT *
FROM VWPSYCHTeenager
GO

-- Psych Admit by Age Range (Young Adult)
-- CREATE VIEW
CREATE VIEW VWPSYCHYoungAdult
AS
    SELECT [Age Range], COUNT([Psych Admit]) AS [Young Adult Count]
    FROM SubstanceAbuseProgramme
    WHERE [Age Range] = 'Young Adult' AND [Psych Admit] != 0
    GROUP BY [Age Range]
GO

-- RUN VWPSYCHYoungAdult
SELECT *
FROM VWPSYCHYoungAdult
GO

-- Maximum and Minimum DLA1 and DLA2 each day of each month
SELECT DISTINCT 
    [Admission Date], 
    MIN(DLA1) AS [Minimum DLA1],
    MIN(DLA2) AS [Minimum DLA2], 
    MAX(DLA1) AS [Maximum DLA1], 
    MAX(DLA2) AS [Maximum DLA2],
    ROUND(AVG(DLA1), 2) AS [Average DLA1],
    ROUND(AVG(DLA2), 2) AS [Average DLA2]
FROM SubstanceAbuseProgramme
GROUP BY [Admission Date]
GO





SELECT DISTINCT [Age Range]
FROM SubstanceAbuseProgramme

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



