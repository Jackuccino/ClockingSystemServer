const { Pool } = require("pg");

// Config for postgre
const config = {
  user: process.env.PGUSER,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  host: process.env.PGHOST,
  port: process.env.PGPORT,
  max: 10,
  idleTimeoutMillis: 30000,
};

// Create the new pool for postgre
const pool = new Pool(config);

exports.employees_get_all = (req, res, next) => {
  pool
    .connect()
    .then((client) => {
      const sql = 'SELECT * FROM "Kacjux"."Get_All_Employees"();';
      const params = [];
      return client
        .query(sql, params)
        .then((result) => {
          client.release();
          const response = {
            result: "ok",
            count: result.rowCount,
            employees: result.rows.map((employee) => {
              return {
                id: employee.id,
                employeeFName: employee.employeeFName,
                employeeLName: employee.employeeLName,
                startHour: employee.startHour,
                startMinute: employee.startMinute,
                totalHours: employee.totalHours,
                extraMinutes: employee.extraMinutes,
              };
            }),
          };
          res.status(200).json(response);
        })
        .catch((err) => {
          client.release();
          console.log(err);
          res.status(500).json({ error: err });
        });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ error: err });
    });
};

exports.employees_post = (req, res, next) => {
  const employee = {
    employeeFName: req.body.employeeFName,
    employeeLName: req.body.employeeLName,
    StartHour: req.body.startHour,
    StartMinute: req.body.startMinute,
    totalHours: req.body.totalHours,
    totalMinutes: req.body.extraMinutes,
  };
  const response = {
    result: "ok",
    employee: employee,
    message: "Handling POST requests to /employees",
  };
  res.status(200).json(response);
};

exports.employee_clock_in = (req, res, next) => {
  pool
    .connect()
    .then((client) => {
      const sql = 'CALL "Kacjux"."ClockIn"($1, $2, $3, $4);';
      const params = [
        req.body.employeeFName,
        req.body.employeeLName,
        req.body.startHour,
        req.body.startMinute,
      ];
      return client
        .query(sql, params)
        .then((result) => {
          client.release();
          res.status(200).json({
            result: "ok",
            message: "clocking in... Done!",
          });
        })
        .catch((err) => {
          client.release();
          console.log(err);
          res.status(500).json({ error: err });
        });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ error: err });
    });
};

exports.employee_clock_out = (req, res, next) => {
  pool
    .connect()
    .then((client) => {
      const sql = 'CALL "Kacjux"."ClockOut"($1, $2, $3, $4);';
      const params = [
        req.body.employeeFName,
        req.body.employeeLName,
        req.body.totalHours,
        req.body.extraMinutes,
      ];
      return client
        .query(sql, params)
        .then((result) => {
          client.release();
          res.status(200).json({
            result: "ok",
            message: "clocking out... Done!",
          });
        })
        .catch((err) => {
          client.release();
          console.log(err);
          res.status(500).json({ error: err });
        });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ error: err });
    });
};

exports.monthly_reset = (req, res, next) => {
  pool
    .connect()
    .then((client) => {
      const sql = 'CALL "Kacjux"."MonthlyReset"();';
      const params = [];
      return client
        .query(sql, params)
        .then((result) => {
          client.release();
          res.status(201).json({
            result: "ok",
            message: "Monthly reset successfully",
          });
        })
        .catch((err) => {
          client.release();
          console.log(err);
          res.status(500).json({ error: err });
        });
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ error: err });
    });
};
