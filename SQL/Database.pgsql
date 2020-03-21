------ Table: "Kacjux"."Employees" ------
DROP TABLE "Kacjux"."Employees";

CREATE TABLE "Kacjux"."Employees"
(
  "EmployeeId" SERIAL NOT NULL PRIMARY KEY,
  "EmployeeName" VARCHAR(150) NOT NULL,
  "StartHour" INT NOT NULL,
  "StartMinute" INT NOT NULL,
  "TotalHours" INT NOT NULL,
  "Date" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Kacjux"."Employees"
  OWNER TO jackxu;

------ Add an employee ------
INSERT INTO "Kacjux"."Employees" ("EmployeeName", "StartHour", "StartMinute", "TotalHours")
VALUES('Jenny', -1, -1, 0);

------ Get all employees ------
SELECT * FROM "Kacjux"."Employees";

------ Get total hours ------
SELECT "EmployeeName", "TotalHours" FROM "Kacjux"."Employees";

DROP FUNCTION "Kacjux"."AllTotalHours";
CREATE FUNCTION "Kacjux"."AllTotalHours"()
RETURNS TABLE (employeename VARCHAR(150), totalhours INT)
LANGUAGE SQL
AS $$
    SELECT "EmployeeName" AS employeename, "TotalHours" AS totalhours
    FROM "Kacjux"."Employees"
$$;

SELECT * FROM "Kacjux"."AllTotalHours"();

------ Get total hours by name ------
-- SELECT "EmployeeName", "TotalHours"
-- FROM "Kacjux"."Employees"
-- WHERE "EmployeeName" = 'Jack';

-- DROP FUNCTION "Kacjux"."TotalHoursByName"(name VARCHAR(150));
-- CREATE FUNCTION "Kacjux"."TotalHoursByName"(name VARCHAR(150))
-- RETURNS TABLE (employeename VARCHAR(150), totalhours INT)
-- LANGUAGE SQL
-- AS $$
--     SELECT "EmployeeName" AS employeename, "TotalHours" AS totalhours
--     FROM "Kacjux"."Employees"
--     WHERE "EmployeeName" = name
-- $$;

-- SELECT * FROM "Kacjux"."TotalHoursByName"('Jack');

------ Clock in ------
UPDATE "Kacjux"."Employees"
SET "StartHour" = 12, "StartMinute" = 30
WHERE "EmployeeName" = 'Jack';

CREATE OR REPLACE PROCEDURE "Kacjux"."CheckIn"(name VARCHAR(150), hour INT, minute INT)
LANGUAGE SQL
AS $$
UPDATE "Kacjux"."Employees"
SET "StartHour" = hour, "StartMinute" = minute, "Date" = CURRENT_TIMESTAMP
WHERE "EmployeeName" = name
$$;

CALL "Kacjux"."CheckIn"('Jack', 12, 40);

------ Clock out ------
UPDATE "Kacjux"."Employees"
SET "StartHour" = -1, "StartMinute" = -1, "TotalHours" = 15
WHERE "EmployeeName" = 'Jack';

CREATE OR REPLACE PROCEDURE "Kacjux"."CheckOut"(name VARCHAR(150), totalhours INT)
LANGUAGE SQL
AS $$
UPDATE "Kacjux"."Employees"
SET "StartHour" = -1, "StartMinute" = -1, "TotalHours" = totalhours, "Date" = CURRENT_TIMESTAMP
WHERE "EmployeeName" = name
$$;

CALL "Kacjux"."CheckOut"('Jack', 50);

------ Monthly reset ------
UPDATE "Kacjux"."Employees"
SET "StartHour" = -1, "StartMinute" = -1, "TotalHours" = 0;

CREATE OR REPLACE PROCEDURE "Kacjux"."MonthlyReset"()
LANGUAGE SQL
AS $$
UPDATE "Kacjux"."Employees"
SET "StartHour" = -1, "StartMinute" = -1, "TotalHours" = 0, "Date" = CURRENT_TIMESTAMP
$$;

CALL "Kacjux"."MonthlyReset"();