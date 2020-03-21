const { Pool } = require("pg");

// Config for postgre
const config = {
  user: process.env.PGUSER,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  host: process.env.PGHOST,
  port: process.env.PGPORT,
  max: 10,
  idleTimeoutMillis: 30000
};

// Create the new pool for postgre
const pool = new Pool(config);

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

exports.totalhours_get_all = (req, res, next) => {
  pool
    .connect()
    .then(client => {
      const sql = 'SELECT * FROM "Kacjux"."AllTotalHours"();';
      const params = [];
      return client
        .query(sql, params)
        .then(result => {
          client.release();
          const response = {
            result: "ok",
            count: result.rowCount,
            employees: result.rows.map(employee => {
              return {
                Name: employee.employeename,
                TotalHours: employee.totalhours
              };
            })
          };
          res.status(200).json(response);
        })
        .catch(err => {
          client.release();
          console.log(err);
          res.status(500).json({ error: err });
        });
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ error: err });
    });
};

// exports.totalhours_get_by_name = (req, res, next) => {
//   const employee_name = req.params.employeeName;
//   pool
//     .connect()
//     .then(client => {
//       const sql = 'SELECT * FROM "Kacjux"."TotalHoursByName"($1);';
//       const params = [employee_name];
//       return client
//         .query(sql, params)
//         .then(result => {
//           client.release();
//           if (!result.rowCount) {
//             return res.status(404).json({ message: "Employee not found" });
//           }
//           res.status(200).json({
//             result: "ok",
//             employees: {
//               Name: result.rows[0].employeename,
//               TotalHours: result.rows[0].totalhours
//             }
//           });
//         })
//         .catch(err => {
//           client.release();
//           console.log(err);
//           res.status(500).json({ error: err });
//         });
//     })
//     .catch(err => {
//       console.log(err);
//       res.status(500).json({ error: err });
//     });
// };

exports.employee_check_in = (req, res, next) => {
  const employee_name = req.params.employeeName;
  pool
    .connect()
    .then(client => {
      const sql = 'CALL "Kacjux"."CheckIn"($1, $2, $3);';
      const params = [employee_name, req.body.hour, req.body.minute];
      return client
        .query(sql, params)
        .then(result => {
          client.release();
          res.status(200).json({
            result: "ok",
            message: employee_name + " checking in... Done!"
          });
        })
        .catch(err => {
          client.release();
          console.log(err);
          res.status(500).json({ error: err });
        });
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ error: err });
    });
};

exports.employee_check_out = (req, res, next) => {
  const employee_name = req.params.employeeName;
  pool
    .connect()
    .then(client => {
      const sql = 'CALL "Kacjux"."CheckOut"($1, $2);';
      const params = [employee_name, req.body.totalhours];
      return client
        .query(sql, params)
        .then(result => {
          client.release();
          res.status(200).json({
            result: "ok",
            message: employee_name + " checking out... Done!"
          });
        })
        .catch(err => {
          client.release();
          console.log(err);
          res.status(500).json({ error: err });
        });
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ error: err });
    });
};

exports.monthly_reset = (req, res, next) => {
  pool
    .connect()
    .then(client => {
      const sql = 'CALL "Kacjux"."MonthlyReset"();';
      const params = [];
      return client
        .query(sql, params)
        .then(result => {
          client.release();
          res.status(201).json({
            result: "ok",
            message: "Monthly reset successfully"
          });
        })
        .catch(err => {
          client.release();
          console.log(err);
          res.status(500).json({ error: err });
        });
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({ error: err });
    });
};
