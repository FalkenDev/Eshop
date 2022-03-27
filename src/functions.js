/**
 * @authors Majd,Kasper och Måns
 */
"use strict";

//const { getProducts } = require("./eshop");

module.exports = { about: about };

async function about() {
    const authors = "Majd Shanan, Kasper Falk, Måns Svensson";

    console.info(`\nSkapare: ${authors}`);
}


