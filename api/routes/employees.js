const express = require("express");
const router = express.Router();
const EmployeeController = require("../controllers/employeeController");

router.get("/", EmployeeController.employees_get_all);

router.post("/", EmployeeController.employees_post);

router.patch("/clock-in", EmployeeController.employee_clock_in);

router.patch("/clock-out", EmployeeController.employee_clock_out);

router.patch("/monthly-reset", EmployeeController.monthly_reset);

module.exports = router;
