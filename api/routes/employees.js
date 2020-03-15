const express = require("express");
const router = express.Router();
const EmployeeController = require("../controllers/employeeController");

router.get("/", EmployeeController.employees_get_all);

router.post("/", EmployeeController.employees_post);

router.get("/:employeeName", EmployeeController.employee_get_by_name);

module.exports = router;
