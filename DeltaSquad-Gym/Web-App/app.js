// Strict mode as per course requirements
"use strict";

// Import express module into project
const express = require("express"),
    // Create instance of express application object
    app = express(),
    // Create instance of session application object
    session = require("express-session"),
    // Create instance to the main controller file
    controller = require("./controllers/mainController"),
    // Create instance of path application object
    path = require("path");
// Set the view engine to EJS
app.set("view engine", "ejs");
// Set the application port # to either the Express.js application 
// environment's variable if already configured or to 3000
app.set("port", process.env.PORT || 3000);
// Associates path to static files to absolute path of "project_root/public"
app.use("/", express.static(path.join(__dirname, "public")));

// Middleware to start a new session
// FYI: req.sessionID or req.session.id to access session
// Access session data example: req.session.username = value
app.use(session({
    // Seed used for session authentication
    // In practise this key would be generated
    secret: "supersecretkey:oooo",
    // Specifies not to save sessionID to server before permission given
    saveUninitialized: false,
    // Specifies not to overwrite session data on server if already exists
    resave: false 
}));

// any requests have form data?
app.use(
    express.urlencoded({ extended: true })
);

// Route handler for get requests to main page
app.get("/gym", controller.renderIndex);

// handle post requests to getuser
app.post("/gym/getuser", controller.getUser);
app.post("/gym/getuser", controller.renderIndex);

// Handle logout request
app.use("/gym/logout", controller.logout)
// Redirects to change url to /sessions
app.post("/gym/logout", (req, res) => {
    res.redirect(302, "/gym");
});

// Route handlers for URLs using the applicable method 
// inside the mainController.js file 
app.get("/gym/locations", controller.renderLocations);
app.get("/gym/locations/:location", controller.renderLocationInfo);
app.get("/gym/coaches", controller.renderCoachList);
app.get("/gym/coaches/:coach", controller.renderCoachInfo);
app.get("/gym/reviews/:coach", controller.renderCoachReviews);
app.get("/gym/classes", controller.renderClassTable);

// Starts listening for connections on the designated application port above
app.listen(app.get("port"), () => {
    // Print default ouput to console to indicate server is running successfully
    console.log("Server running...");
});