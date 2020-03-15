exports.employees_get_all = (req, res, next) => {
  const response = {
    result: "ok",
    message: "Handling GET requests to /employees"
  };
  res.status(200).json(response);
};

exports.employees_post = (req, res, next) => {
  const employee = {
    employeeId: req.body.employeeId,
    employeeName: req.body.employeeName,
    startTime: req.body.startTime,
    totalHours: req.body.totalHours
  };
  const response = {
    result: "ok",
    employee: employee,
    message: "Handling POST requests to /employees"
  };
  res.status(200).json(response);
};

exports.employee_get_by_name = (req, res, next) => {
  const name = req.params.employeeName;
  const response = {
    result: "ok",
    name: name,
    message: "Handling GET by ID requests to /employees/employeeId"
  };
  res.status(200).json(response);
};
