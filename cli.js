
"use strict";

const mysql = require("promise-mysql");
const config = require("./config/db/eshop.json");
const func = require("./src/eshop.js");
const readline = require('readline');
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

/**
  * Main function.
  *
  * @returns void
  */
(async function() {
    rl.on("close", exitProgram);
    rl.on("line", handleInput);

    console.log(
        "StorMax: How can we help you?\n"
    );

    rl.setPrompt("Your Choice: ");
    rl.prompt();
})();



/**
  * Handle input as a command
  *
  * @param {string} line The input from the user.
  *
  * @returns {void}
  */
async function handleInput(line) {
    const db = await mysql.createConnection(config);

    line = line.trim();
    let parts = line.split(" ");

    switch (parts[0]) {
        case "quit":
        case "exit":
            process.exit();
            break;

        case "help":
        case "menu":
            Menu();
            break;

        case "about":
            await func.about(db);
            break;

        case "log":
            if (parts.length === 2) {
                await func.Logs(parts[1]);
            } else {
                console.error("use this syntax:log <number> ");
            }
            break;

        case "product":
            await func.getAllProductsCLI();
            break;

        case "shelf":
            await func.getShelves();
            break;
        case "inv":
            if (parts.length === 2) {
                await func.inventory(parts[1]);
            } else {
                await func.inventoryAll();
            }
            break;

        case "invadd":
            if (parts.length === 4) {
                await func.Add2Inventory(parts.slice(1, 4));
            } else {
                console.error("use this syntax: invadd <productid> <shelf> <number>");
            }
            break;

        case "invdel":
            if (parts.length === 4) {
                await func.RemoveFromInv(parts.slice(1, 4));
            } else {
                console.error("use this syntax:  invdel <productid> <shelf> <number>");
            }
            break;
        case "order":
            if (parts.length === 2) {
                await func.searchOrder(parts[1]);
            } else {
                await func.searchOrder();
            }
            break;
        case "picklist":
            if (parts.length === 2) {
                await func.picklist(parseInt(parts[1]));
            } else {
                console.error("use this syntax: picklist <orderid>");
            }
            break;
        case "ship":
            if (parts.length === 2) {
                await func.shipOrder(parseInt(parts[1]));
            } else {
                console.error("use this syntax: ship <orderid>");
            }
            break;
        default:
            await Menu();
            break;
    }

    rl.prompt();
}

/**
  * Show  menu
  *
  * @returns {void}
  */
function Menu() {
    console.info(
        ` You can choose between these commands:\n` +
        `  exit, quit, ctrl-d                    - Exit\n` +
        `  help, menu                            - Show menu\n` +
        `  about                                 - Show the creators\n` +
        `  log <number>                          - Show latest <number> rows in logs\n` +
        `  product                               - Show all the products\n` +
        `  shelf                                 - Show storage shelves are in the warehouse\n` +
        `  inv                                   - Show products with storage space\n` +
        `  inv <str>                             - Show specefied products with storage\n` +
        `  invadd <productid> <shelf> <number>   - Adds number of products to storage shelf\n` +
        `  invdel <productid> <shelf> <number>   - Delete number of products from storage shelf\n` +
        `  order                                 - Show all orders\n` +
        `  order <search>                        - Show selected order\n` +
        `  picklist <orderid>                    - Show the picklist for selected id\n` +
        `  ship <orderid>                        - ship the order\n` +
        `  about                                 - Show the creators\n`
    );
}


/**
  * Close down program
  *
  * @param {number} code
  *
  * @returns {void}
  */
function exitProgram(code) {
    code = code || 0;

    console.info("Exiting with status code " + code);
    process.exit(code);
}

