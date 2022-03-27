/* eslint-disable camelcase */
"use strict";
module.exports = {
    "getProducts": getProducts,
    "getCustomer": getCustomer,
    "getCategories": getCategories,
    "getAllProducts": getAllProducts,
    "about": about,
    "getShelves": getShelves,
    "createProduct": createProduct,
    "getOneProduct": getOneProduct,
    "editProduct": editProduct,
    "deleteProduct": deleteProduct,
    "addProduct": addProduct,
    "Logs": Logs,
    "inventory": inventory,
    "Add2Inventory": Add2Inventory,
    "RemoveFromInv": RemoveFromInv,
    "getAllProductsCLI": getAllProductsCLI,
    "inventoryAll": inventoryAll,
    "getOrders": getOrders,
    "searchOrder": searchOrder,
    "createOrder": createOrder,
    "picklist": picklist,
    "createVarukorg": createVarukorg,
    "getVarukorg": getVarukorg,
    "orderDone": orderDone,
    "shipOrder": shipOrder
};
const mysql  = require("promise-mysql");
const config = require("../config/db/eshop.json");
let db;

(async function() {
    db = await mysql.createConnection(config);
    process.on("exit", () => {
        db.end();
    });
})();





////////////////////////////////////////////////////



/**
 *
 * get one product
 * @param {connection} db
 * @param {array} data
 * @returns {void}
 */
async function getOneProduct(data) {
    let sql = "CALL get_one_product(?)";
    let res = await db.query(sql, [data]);

    return JSON.parse(JSON.stringify(res[0]));
}

////////////////////////////////////////////////////
/**
 *
 * get one product
 * @param {connection} db
 * @param {array} searchstring
 * @returns {void}
 */
async function inventory(searchstring = "") {
    let sql1 = "CALL inventory(?)";

    searchstring = `%${searchstring}%`;
    let res1 = await db.query(sql1, [searchstring]);


    console.table(JSON.parse(JSON.stringify(res1[0])));
    return JSON.parse(JSON.stringify(res1[0]));
}
////////////////////////////////////////////////////
/**
 * Get full inventory
 *
 * @param {connection} db
 * @returns {void}
 */
async function inventoryAll() {
    let sql = `CALL inventory_all();`;
    let res = await db.query(sql);

    console.table(JSON.parse(JSON.stringify(res[0])));
}

////////////////////////////////////////////////////
/**
 * add to inventory
 *
 * @param {connection} db
 * @param {array} arrayinv
 * @returns {void}
 */

async function Add2Inventory(arrayinv) {
    let sql = "CALL add_2_inventory(?, ?, ?, ?)";

    try {
        console.info(arrayinv[0], arrayinv[1], arrayinv[2]);
        await db.query(sql, [arrayinv[0], arrayinv[1], arrayinv[2], "Egen Produkt"]);
        console.log("SUCCESS!");
    } catch (err) {
        console.error("SUCCESS!\n");
    }
}



////////////////////////////////////////////////////
/**
 * remove from inventory
 *
 * @param {connection} db
 * @param {array} arrayinv
 * @returns {void}
 */

async function RemoveFromInv(arrayinv1) {
    let sql = "CALL remove_from_inv(?, ?, ?)";

    try {
        await db.query(sql, [arrayinv1[0], arrayinv1[1], arrayinv1[2]]);
        console.log("SUCCESS!");
    } catch (err) {
        console.error("SUCCESS!\n");
    }
}




////////////////////////////////////////////////////

// Get all Products
function getProducts() {
    return getAllProducts();
}

/**
 * get all products
 * get one product
 * @param {connection} db
 * @param {array} searchstring
 * @returns {void}
 */
async function getAllProducts() {
    let sql = "CALL get_all_products()";
    let res = await db.query(sql);


    console.log(JSON.parse(JSON.stringify(res[0])));
    return JSON.parse(JSON.stringify(res[0]));
}

////////////////////////////////////////////////////
async function getAllProductsCLI() {
    let sql = "CALL get_all_products()";
    let res = await db.query(sql);


    console.table(JSON.parse(JSON.stringify(res[0])));
    //return JSON.parse(JSON.stringify(res[0]));
    //return res;
}

////////////////////////////////////////////////////
/**
 *
 * get all Categories
 * @param {connection} db
 * @param {array} searchstring
 * @returns {void}
 */


async function getCategories() {
    return getAllCategories();
}

// Returns all the categories
async function getAllCategories() {
    let sql = `CALL get_categories()`;
    let res;

    res = await db.query(sql);

    console.log(JSON.parse(JSON.stringify(res[0])));
    return JSON.parse(JSON.stringify(res[0]));
}




////////////////////////////////////////////////////
/**
 *
 * get all shelf info
 * @param {connection} db
 * @param {array} searchstring
 * @returns {void}
 */

async function getShelves() {
    let sql = `CALL get_shelves()`;

    let res = await db.query(sql);

    console.table(JSON.parse(JSON.stringify(res[0])));
}




////////////////////////////////////////////////////
/**
 *
 * get all log info
 * @param {connection} db
 * @param {array} searchstring
 * @returns {void}
 */
async function Logs(number) {
    let sql = `CALL logs(?)`;

    console.info(`Showing: ${number} row(s) of log content`);
    let like = `${number}`;


    let res = await db.query(sql, [like]);

    console.table(res[0]);
}

async function createProduct(data) {
    let sql1 = `CALL create_product(?,?,?,?);`;
    let sql2 = "CALL create_lager_column(?, ?, ?, ?)";
    let sql3 = "CALL create_product_category(?)";
    let kategori;
    let res1;
    let res2;
    let res3;

    res1 = await db.query(sql1, [data.namn, data.beskrivning,
        data.bild_url, data.pris]);

    console.log(data.hylla);
    let hylla = `H:${data.hylla}`;

    res2 = await db.query(sql2, [data.LagerID, data.namn, data.antal, hylla]);

    if (data.kategori2 == "inget" && data.kategori3 == "inget") {
        kategori = `${data.kategori1}`;
    } else if (data.kategori2 == "inget") {
        kategori = `${data.kategori1}, ${data.kategori3}`;
    } else if (data.kategori3 == "inget") {
        kategori = `${data.kategori1}, ${data.kategori2}`;
    } else {
        kategori = `${data.kategori1}, ${data.kategori2}, ${data.kategori3}`;
    }

    console.log(kategori);

    res3 = await db.query(sql3, [kategori]);

    console.log(res1);
    console.log(res2);
    console.log(res3);
}

////////////////////////////////////////////////////
async function about() {
    const authors = "Majd Shanan, Kasper Falk, Måns Svensson";

    console.info(`\nSkapare: ${authors}`);
}

////////////////////////////////////////////////////
/**
 *
 * deleting a product
 * @param {connection} db
 * @param {array} data
 * @returns {void}
 */
async function editProduct(data) {
    let sql = `CALL edit_product(?,?,?,?,?);`;
    let res;

    res = await db.query(sql, [data.produktID, data.namn, data.beskrivning,
        data.bild_url, data.pris]);
    console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}




////////////////////////////////////////////////////
/**
 *
 * deleting a product
 * @param {connection} db
 * @param {array} produktID
 * @returns {void}
 */
async function deleteProduct(/*id*/produktID) {
    let sql = "CALL delete_product(?)";

    await db.query(sql, [produktID]);
}

////////////////////////////////////////////////////
/**
 *
 * this function is for adding values by calling addProduct with 6 parameters
 * @param {connection} db
 * @param {array} searchstring
 * @returns {void}
 */

async function addProduct(data) {
    let sql = `CALL addProduct(?, ?, ?, ?, ?, ?)`;

    await db.query(sql, [data.namn, data.beskrivning,
        data.pris, data.pris, data.bild_url, data.produktID]);
}



/**
 *
 * this function is for adding values by calling addProduct with 6 parameters
 * @param {connection} db
 *
 * @returns {void}
 */
async function getCustomer() {
    let sql = `CALL get_customer()`;
    let res = await db.query(sql);

    return res[0];
}

async function createOrder(id) {
    let sql1 = `CALL get_one_customer(?)`;

    let sql2 = `CALL create_order(?, ?)`;

    console.log(id);
    let res = await db.query(sql1, [id]);

    let res1 = JSON.parse(JSON.stringify(res[0]));

    console.log(res1);

    for (const row of res1) {
        let namn = `${row.fornamn} ${row.efternamn}`;

        let res2 = await db.query(sql2, [id, namn]);

        console.log(res2);
    }
}

////////////////////////////////////////////////////
async function getOrders() {
    let sql = `CALL show_orders()`;
    let res = await db.query(sql);

    console.log((JSON.stringify(res[0])));

    return JSON.parse(JSON.stringify(res[0]));
}

////////////////////////////////////////////////////
async function searchOrder(search = "") {
    let sql = `CALL search_order(?);`;


    search = `%${search}%`;

    let res = await db.query(sql, [search]);

    console.table(JSON.parse(JSON.stringify(res[0])));
}

////////////////////////////////////////////////////
async function picklist(id) {
    let sql = `CALL pick_List(?);`;
    let res = await db.query(sql, [id]);

    console.table(JSON.parse(JSON.stringify(res[0])));
}

////////////////////////////////////////////////////
async function createVarukorg(data, orderID) {
    console.log(data);
    let sql1 = `CALL create_varukorg(?,?,?,?,?)`;
    let sql2 = `CALL update_order(?,?)`;
    let sql3 = `CALL update_lager_column(?,?)`;

    if (data.antal != "") {
        await db.query(sql1, [orderID, data.produktID, data.namn, data.antal, data.pris]);
        await db.query(sql2, [orderID, data.antal]);
        await db.query(sql3, [data.produktID, data.antal]);
    } else {
        return;
    }
}

////////////////////////////////////////////////////
async function getVarukorg(id) {
    let sql = `CALL get_varukorg(?)`;

    let res = await db.query(sql, [id]);

    return JSON.parse(JSON.stringify(res[0]));
}

////////////////////////////////////////////////////
async function orderDone(id) {
    let sql = `CALL ordered(?)`;

    await db.query(sql, [id]);
}

////////////////////////////////////////////////////
async function shipOrder(orderID) {
    let sql = `CALL ship(?);`;

    await db.query(sql, [orderID]);

    let sql1 = `CALL search_order(?);`;

    let res = await db.query(sql1, [parseInt(orderID)]);

    console.table(JSON.parse(JSON.stringify(res[0])));
}
