/**
 * A sample Express server with static resources.
 */
"use strict";

const port    = process.env.DBWEBB_PORT || 1337;
const path    = require("path");
const express = require("express");
const app     = express();
const routeEshop = require("./route/eshop/eshop.js");
const middleware = require("./middleware/index.js");

app.set("view engine", "ejs");
app.use(express.urlencoded({extended: true}));

app.use(middleware.logIncomingToConsole);
var dir = path.join(__dirname, 'public');

app.use('/public', express.static(dir));
app.use(express.static('public')); // Funkar
app.use("/", routeEshop);
app.use("/product", routeEshop);
app.use("/product/edit/", routeEshop);
app.use("/category", routeEshop);
app.use("/eshop/product/create", routeEshop);
app.use("/eshop/customer", routeEshop);
app.use("/eshop/order", routeEshop);
app.use("/eshop/order/show", routeEshop);
app.use("/eshop/order/send/", routeEshop);


app.listen(port, logStartUpDetailsToConsole);



/**
  * Log app details to console when starting up.
  *
  * @return {void}
  */
function logStartUpDetailsToConsole() {
    let routes = [];

    // Find what routes are supported
    app._router.stack.forEach((middleware) => {
        if (middleware.route) {
            // Routes registered directly on the app
            routes.push(middleware.route);
        } else if (middleware.name === "router") {
            // Routes added as router middleware
            middleware.handle.stack.forEach((handler) => {
                let route;

                route = handler.route;
                route && routes.push(route);
            });
        }
    });

    console.info(`Server is listening on port ${port}.`);
    console.info("Available routes are:");
    console.info(routes);
}

