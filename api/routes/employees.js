const express = require("express");
const router = express.Router();
const EmployeeController = require("../controllers/employeeController");

router.get("/", EmployeeController.employees_get_all);

router.post("/", EmployeeController.employees_post);

router.get(
  "/get-employee/:employeeName",
  EmployeeController.employee_get_by_name
);

router.get("/total-hours", EmployeeController.totalhours_get_all);

// router.get(
//   "/total-hours/:employeeName",
//   EmployeeController.totalhours_get_by_name
// );

router.patch("/check-in/:employeeName", EmployeeController.employee_check_in);

router.patch("/check-out/:employeeName", EmployeeController.employee_check_out);

router.patch("/monthly-reset", EmployeeController.monthly_reset);

module.exports = router;
