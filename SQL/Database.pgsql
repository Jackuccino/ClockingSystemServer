------ Table: "Kacjux"."Employees" ------
DROP TABLE "Kacjux"."Employees";

CREATE TABLE "Kacjux"."Employees"
(
  "id" SERIAL NOT NULL PRIMARY KEY,
  "employeeFName" VARCHAR(150) NOT NULL,
  "employeeLName" VARCHAR(150) NOT NULL,
  "startHour" INT NOT NULL,
  "startMinute" INT NOT NULL,
  "totalHours" INT NOT NULL,
  "extraMinutes" INT NOT NULL,
  "date" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "Kacjux"."Employees"
  OWNER TO jackxu;

------ Remove all employee ------
TRUNCATE TABLE "Kacjux"."Employees"
RESTART IDENTITY

------ Add an employee ------
INSERT INTO "Kacjux"."Employees" ("employeeFName", "employeeLName", "startHour", "startMinute", "totalHours", "extraMinutes")
VALUES('Jenny', 'Chan', -1, -1, 0, 0);

INSERT INTO "Kacjux"."Employees" ("employeeFName", "employeeLName", "startHour", "startMinute", "totalHours", "extraMinutes")
VALUES('Jack', 'Xu', -1, -1, 0, 0);

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

------ Clock in ------
UPdATE "Kacjux"."Employees"
SET "startHour" = 12, "startMinute" = 30
WHERE "employeeFName" = 'Jack' AND "employeeLName" = 'Xu';

CREATE OR REPLACE PROCEDURE "Kacjux"."ClockIn"(fname VARCHAR(150), lname VARCHAR(150), hour INT, minute INT)
LANGUAGE SQL
AS $$
UPdATE "Kacjux"."Employees"
SET "startHour" = hour, "startMinute" = minute, "date" = CURRENT_TIMESTAMP
WHERE "employeeFName" = fname AND "employeeLName" = lname
$$;

CALL "Kacjux"."ClockIn"('Jack', 'Xu', 12, 40);

------ Clock out ------
UPdATE "Kacjux"."Employees"
SET "startHour" = -1, "startMinute" = -1, "totalHours" = 15
WHERE "employeeFName" = 'Jack' AND "employeeLName" = 'Xu'

CREATE OR REPLACE PROCEDURE "Kacjux"."ClockOut"(fname VARCHAR(150), lname VARCHAR(150), totalhours INT, extraminutes INT)
LANGUAGE SQL
AS $$
UPdATE "Kacjux"."Employees"
SET "startHour" = -1, "startMinute" = -1, "totalHours" = totalhours, "extraMinutes" = extraminutes, "date" = CURRENT_TIMESTAMP
WHERE "employeeFName" = fname AND "employeeLName" = lname
$$;

CALL "Kacjux"."ClockOut"('Jack', 'Xu', 50);

------ Monthly reset ------
UPdATE "Kacjux"."Employees"
SET "startHour" = -1, "startMinute" = -1, "totalHours" = 0;

CREATE OR REPLACE PROCEDURE "Kacjux"."MonthlyReset"()
LANGUAGE SQL
AS $$
UPdATE "Kacjux"."Employees"
SET "startHour" = -1, "startMinute" = -1, "totalHours" = 0, "extraMinutes" = 0, "date" = CURRENT_TIMESTAMP
$$;

CALL "Kacjux"."MonthlyReset"();