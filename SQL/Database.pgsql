------ Table: "Kacjux"."Employees" ------
DROP TABLE "Kacjux"."Employees";

CREATE TABLE "Kacjux"."Employees"
(
  "employeeId" SERIAL NOT NULL PRIMARY KEY,
  "employeeName" VARCHAR(150) NOT NULL,
  "startHour" INT NOT NULL,
  "startMinute" INT NOT NULL,
  "totalHours" INT NOT NULL,
  "date" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Kacjux"."Employees"
  OWNER TO jackxu;

------ Add an employee ------
INSERT INTO "Kacjux"."Employees" ("employeeName", "startHour", "startMinute", "totalHours")
VALUES('Jenny', -1, -1, 0);

INSERT INTO "Kacjux"."Employees" ("employeeName", "startHour", "startMinute", "totalHours")
VALUES('Jack', -1, -1, 0);

------ Get all employees ------
SELECT * FROM "Kacjux"."Employees";

DROP FUNCTION "Kacjux"."Get_All_Employees";
CREATE OR REPLACE FUNCTION "Kacjux"."Get_All_Employees"()
RETURNS SETOF "Kacjux"."Employees"
LANGUAGE SQL
AS $$
SELECT * FROM "Kacjux"."Employees";
$$;

SELECT * FROM "Kacjux"."Get_All_Employees"();

------ Get total hours by name ------
-- SELECT "employeeName", "totalHours"
-- FROM "Kacjux"."Employees"
-- WHERE "employeeName" = 'Jack';

-- DROP FUNCTION "Kacjux"."totalHoursByName"(name VARCHAR(150));
-- CREATE FUNCTION "Kacjux"."totalHoursByName"(name VARCHAR(150))
-- RETURNS TABLE (employeename VARCHAR(150), totalhours INT)
-- LANGUAGE SQL
-- AS $$
--     SELECT "employeeName" AS employeename, "totalHours" AS totalhours
--     FROM "Kacjux"."Employees"
--     WHERE "employeeName" = name
-- $$;

-- SELECT * FROM "Kacjux"."totalHoursByName"('Jack');

------ Clock in ------
UPdATE "Kacjux"."Employees"
SET "startHour" = 12, "startMinute" = 30
WHERE "employeeName" = 'Jack';

CREATE OR REPLACE PROCEDURE "Kacjux"."CheckIn"(name VARCHAR(150), hour INT, minute INT)
LANGUAGE SQL
AS $$
UPdATE "Kacjux"."Employees"
SET "startHour" = hour, "startMinute" = minute, "date" = CURRENT_TIMESTAMP
WHERE "employeeName" = name
$$;

CALL "Kacjux"."CheckIn"('Jack', 12, 40);

------ Clock out ------
UPdATE "Kacjux"."Employees"
SET "startHour" = -1, "startMinute" = -1, "totalHours" = 15
WHERE "employeeName" = 'Jack';

CREATE OR REPLACE PROCEDURE "Kacjux"."CheckOut"(name VARCHAR(150), totalhours INT)
LANGUAGE SQL
AS $$
UPdATE "Kacjux"."Employees"
SET "startHour" = -1, "startMinute" = -1, "totalHours" = totalhours, "date" = CURRENT_TIMESTAMP
WHERE "employeeName" = name
$$;

CALL "Kacjux"."CheckOut"('Jack', 50);

------ Monthly reset ------
UPdATE "Kacjux"."Employees"
SET "startHour" = -1, "startMinute" = -1, "totalHours" = 0;

CREATE OR REPLACE PROCEDURE "Kacjux"."MonthlyReset"()
LANGUAGE SQL
AS $$
UPdATE "Kacjux"."Employees"
SET "startHour" = -1, "startMinute" = -1, "totalHours" = 0, "date" = CURRENT_TIMESTAMP
$$;

CALL "Kacjux"."MonthlyReset"();