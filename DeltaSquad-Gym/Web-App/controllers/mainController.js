// Strict mode as per course requirements
"use strict";


const sql = require("mssql"),
    pool = new sql.ConnectionPool({
        user: "DeltaSquad_Node.js",
        password: "DeltaSquad123",
        database: "DeltaSquadDB",
        server: "localhost",
        port: 1433,
        options: {
            // instanceName: "SQLEXPRESS",
            encrypt: true,
            trustServerCertificate: true
        },
        pool: {
            max: 10,
            min: 0,
            idleTimeoutMillis: 30000
        }
    }), 
    // Create instance of path application object
    path = require("path");
// Create instance of JSON file using absolute path of "project_root/public"
// const fleet = require(path.join(__dirname, "../models/fleet.json"));

pool.connect(err => {
    console.log(err);
})

// http://localhost:3000/gym/locations
// TODO: Main page, session login for user ID, back button, footer link to main page
// TODO: Add accesibility to rating dots, link to classes page, 404 page
// TODO: Comment code

// Export the renderIndex function for app.js to access
exports.renderIndex = (req, res) => {
    // Render the response using the Index.ejs template
    res.render("index", {
        session: req.session,
        credentialCheck: req.credentialCheck
    });
};

// Export the getUser function for app.js to access
exports.getUser = (req, res, next) => {
    pool.query(`SELECT First_Name, Customer_ID 
            FROM Customer 
            WHERE First_Name = '${req.body.username}'`, 
    (err, customerResult) => {
        if (err) {
            console.error(`Error executing query: ${err}`);
        } else {
            if (customerResult.recordset[0]) {
                req.session.username = req.body.username;
                req.session.customerId = customerResult.recordset[0].Customer_ID;
                req.session.password = req.body.password;
                req.credentialCheck = true;
            } else {
                req.credentialCheck = false;
            }
            next();
        }
    });
};

// Export the logout function for app.js to access
exports.logout = (req, res, next) => {
    // req.session.destroy method executes code before data is removed from 
    // session table and session is destroyed
    req.session.destroy(() => {
        console.log("Session destroyed!")
    });
    next();
};


// Export the renderInfo function for app.js to access
exports.renderLocations = (req, res) => {
    pool.query("SELECT Name FROM Location", (err, locationsResult) => {
        if (err) {
            console.error(`Error executing query: ${err}`);
        } else {
            pool.query(`SELECT l.Name, 
                    COUNT(CASE WHEN v.Customer_ID = '${req.session.customerId}' THEN v.Visit_ID END) AS '# of Visits' 
                    FROM Location l 
                    LEFT JOIN Visit v 
                        ON v.Location_ID = l.Location_ID 
                    GROUP BY l.Name 
                    HAVING COUNT(CASE WHEN v.Customer_ID = '${req.session.customerId}' THEN v.Visit_ID END) > 0 
                    ORDER BY l.Name`, 
            (err, visitedGymsResult) => {
                if (err) {
                    console.error(`Error executing query: ${err}`);
                } else {
                    // Send query result as response
                    res.render("gymLocations", {
                        visited: visitedGymsResult.recordset,
                        locations: locationsResult.recordset, 
                    });
                }
            });
        }
    });
};
   
exports.renderLocationInfo = (req, res) => {
    // Queries to load gym information including related amenities and coach info
    pool.query("SELECT Name FROM Location", (err, result) => {
        if (err) {
            console.error(`Error executing query: ${err}`);
        } else {
            pool.query(`SELECT * 
                    FROM Location 
                    WHERE Name = '${req.params.location}'`, 
            (err, locationResult) => {
                if (err) {
                    console.error(`Error executing query: ${err}`);
                } else {
                    pool.query(`SELECT Amenity 
                            FROM LocationAmenity 
                            WHERE Location_ID = 
                                '${locationResult.recordset[0].Location_ID}'`, 
                    (err, amenityResult) => {
                        if (err) {
                            console.error(`Error executing query: ${err}`);
                        } else {
                            pool.query(`SELECT c.First_Name, c.Coach_ID 
                                    FROM Coach c 
                                    JOIN CoachLocation l 
                                        ON c.Coach_ID = l.Coach_ID 
                                    WHERE l.Location_ID = 
                                        '${locationResult.recordset[0].Location_ID}'`, 
                            (err, coachResult) => {
                                if (err) {
                                    console.error(`Error executing query: ${err}`);
                                } else {
                                    // Send query result as response
                                    res.render("locationInfo", {
                                        gymInfo: locationResult.recordset[0],
                                        amenityInfo: amenityResult.recordset,
                                        coachInfo: coachResult.recordset,
                                    });
                                }
                            });
                        }
                    });
                }
            });
        }
    });
};

exports.renderCoachList = (req, res) => {
    // Queries to load coach list including review & level ratings
    pool.query(`SELECT c.First_Name, c.Level, c.Coach_ID,
        ROUND(((CASE WHEN p.p_rating IS NULL THEN 0 ELSE p.p_rating END) +
        (CASE WHEN r.r_rating IS NULL THEN 0 ELSE r.r_rating END)) / 2.0, 0) AS 'Rating',
        COUNT(
            CASE WHEN v.Customer_ID = '${req.session.customerId}'
            THEN v.Visit_ID 
            END) AS '# of Visits'
        FROM Coach c
            LEFT JOIN (
                SELECT
                    Coach_ID,
                    AVG((Communication + Enthusiasm + Punctuality) / 3.0) AS p_rating
                FROM PersonalCoachReview
                GROUP BY Coach_ID
            ) p 
            ON p.Coach_ID = c.Coach_ID
            LEFT JOIN (
                SELECT
                    Coach_ID,
                    AVG((Communication + Enthusiasm + Punctuality) / 3.0) AS r_rating
                FROM ClassCoachReview
                GROUP BY Coach_ID
            ) r 
            ON r.Coach_ID = c.Coach_ID
            LEFT JOIN CoachLocation x
            ON c.Coach_ID = x.Coach_ID
            LEFT JOIN Appointment a 
            ON a.Coach_ID = c.Coach_ID
            LEFT JOIN Visit v
            ON v.Visit_ID = a.Visit_ID
        GROUP BY c.First_Name, c.Level, c.Coach_ID, p.p_rating, r.r_rating
        HAVING COUNT(
                CASE WHEN v.Customer_ID = '${req.session.customerId}'
                THEN v.Visit_ID 
                END) > 0
        ORDER BY '# of Visits' DESC;`, 
    (err, myCoachResult) => {
        if (err) {
            console.error(`Error executing query: ${err}`);
        } else {
            pool.query(`SELECT c.First_Name, c.Level, c.Coach_ID,
                ROUND(((CASE WHEN p.p_rating IS NULL THEN 0 ELSE p.p_rating END) +
                (CASE WHEN r.r_rating IS NULL THEN 0 ELSE r.r_rating END)) / 2.0, 0) AS 'Rating',
                COUNT(
                    CASE WHEN v.Customer_ID = '${req.session.customerId}' 
                    THEN v.Visit_ID 
                    END) AS '# of Visits'
                FROM Coach c
                    LEFT JOIN (
                        SELECT
                            Coach_ID,
                            AVG((Communication + Enthusiasm + Punctuality) / 3.0) AS p_rating
                        FROM PersonalCoachReview
                        GROUP BY Coach_ID
                    ) p 
                    ON p.Coach_ID = c.Coach_ID
                    LEFT JOIN (
                        SELECT
                            Coach_ID,
                            AVG((Communication + Enthusiasm + Punctuality) / 3.0) AS r_rating
                        FROM ClassCoachReview
                        GROUP BY Coach_ID
                    ) r 
                    ON r.Coach_ID = c.Coach_ID
                    LEFT JOIN CoachLocation x
                    ON c.Coach_ID = x.Coach_ID
                    LEFT JOIN Appointment a 
                    ON a.Coach_ID = c.Coach_ID
                    LEFT JOIN Visit v
                    ON v.Visit_ID = a.Visit_ID
                GROUP BY c.First_Name, c.Level, c.Coach_ID, p.p_rating, r.r_rating
                ORDER BY c.First_Name;`, 
            (err, coachListResult) => {
                if (err) {
                    console.error(`Error executing query: ${err}`);
                } else {
                    // Send query result as response
                    res.render("coachList", {
                        myCoach: myCoachResult.recordset,
                        coachList: coachListResult.recordset,
                    });
                }
            });
        }
    });
};

exports.renderCoachInfo = (req, res) => {
    // Queries to load coach info including review & level ratings
    pool.query(`SELECT c.First_Name, c.Level, c.Coach_ID, c.Philosophy,
        ROUND(((CASE WHEN p.p_rating IS NULL THEN 0 ELSE p.p_rating END) +
        (CASE WHEN r.r_rating IS NULL THEN 0 ELSE r.r_rating END)) / 2.0, 0) AS 'Rating'
        FROM Coach c
            LEFT JOIN (
                SELECT
                    Coach_ID,
                    AVG((Communication + Enthusiasm + Punctuality) / 3.0) AS p_rating
                FROM PersonalCoachReview
                GROUP BY Coach_ID
            ) p 
            ON p.Coach_ID = c.Coach_ID
            LEFT JOIN (
                SELECT
                    Coach_ID,
                    AVG((Communication + Enthusiasm + Punctuality) / 3.0) AS r_rating
                FROM ClassCoachReview
                GROUP BY Coach_ID
            ) r 
            ON r.Coach_ID = c.Coach_ID
            LEFT JOIN CoachLocation x
            ON c.Coach_ID = x.Coach_ID
            LEFT JOIN Appointment a 
            ON a.Coach_ID = c.Coach_ID
        GROUP BY c.First_Name, c.Level, c.Coach_ID, c.Philosophy, p.p_rating, r.r_rating
        HAVING c.Coach_ID = ${req.params.coach};`, 
    (err, coachResult) => {
        if (err) {
            console.error(`Error executing query: ${err}`);
        } else {
            // Queries to coach location info including review & level ratings
            pool.query(`SELECT l.Name
                FROM Coach c
                    LEFT JOIN CoachLocation x
                    ON c.Coach_ID = x.Coach_ID
                    LEFT JOIN Location l
                    ON x.Location_ID = l.Location_ID
                WHERE c.Coach_ID = ${req.params.coach};`, 
            (err, locationResult) => {
                if (err) {
                    console.error(`Error executing query: ${err}`);
                } else {
                    // Queries to load certificate info including review & level ratings
                    pool.query(`SELECT e.Certificate_Name
                        FROM Coach c
                            LEFT JOIN Certificate y
                            ON c.Coach_ID = y.Coach_ID
                            LEFT JOIN Course e
                            ON y.Course_ID = e.Course_ID
                        WHERE c.Coach_ID = ${req.params.coach};`, 
                    (err, certificateResult) => {
                        if (err) {
                            console.error(`Error executing query: ${err}`);
                        } else {
                            // Queries to load reference info including review & level ratings
                            pool.query(`SELECT a.First_Name, a.Last_Name, a.Phone, a.Email
                                FROM Coach c
                                    LEFT JOIN Reference z 
                                    ON c.Coach_ID = z.Coach_ID
                                    LEFT JOIN Customer a
                                    ON z.Customer_ID = a.Customer_ID
                                WHERE c.Coach_ID = ${req.params.coach};`, 
                            (err, referenceResult) => {
                                if (err) {
                                    console.error(`Error executing query: ${err}`);
                                } else {
                                    // Send query result as response
                                    res.render("coachInfo", {
                                        coach: coachResult.recordset[0],
                                        locations: locationResult.recordset,
                                        certificates: certificateResult.recordset,
                                        references: referenceResult.recordset,
                                    });
                                }
                            });
                        }
                    });
                }
            });
        }
    });
};

exports.renderCoachReviews = (req, res) => {
    pool.query(`SELECT Communication, Enthusiasm, Punctuality, Notes 
        FROM PersonalCoachReview
        WHERE Coach_ID = ${req.params.coach}
        UNION ALL 
        SELECT Communication, Enthusiasm, Punctuality, Notes 
        FROM ClassCoachReview
        WHERE Coach_ID = ${req.params.coach}`, 
    (err, reviewResult) => {
        if (err) {
            console.error(`Error executing query: ${err}`);
        } else {
            pool.query(`SELECT First_Name FROM Coach
                WHERE Coach_ID = ${req.params.coach}`, 
            (err, coachResult) => {
                if (err) {
                    console.error(`Error executing query: ${err}`);
                } else {
                    // Send query result as response
                    res.render("reviews", {
                        reviews: reviewResult.recordset, 
                        coach: coachResult.recordset[0],
                    });
                }
            });
        }
    });
};

exports.renderClassTable = (req, res) => {
   pool.query(`SELECT Communication, Enthusiasm, Punctuality, Notes 
        FROM PersonalCoachReview
        WHERE Coach_ID = ${req.params.coach}
        UNION ALL 
        SELECT Communication, Enthusiasm, Punctuality, Notes 
        FROM ClassCoachReview
        WHERE Coach_ID = ${req.params.coach}`, 
    (err, reviewResult) => {
        if (err) {
            console.error(`Error executing query: ${err}`);
        } else {
            pool.query(`SELECT First_Name FROM Coach
                WHERE Coach_ID = ${req.params.coach}`, 
            (err, coachResult) => {
                if (err) {
                    console.error(`Error executing query: ${err}`);
                } else {
                    // Send query result as response
                    res.render("reviews", {
                        reviews: reviewResult.recordset, 
                        coach: coachResult.recordset[0],
                    });
                }
            });
        }
    });
};