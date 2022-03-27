/**
 * Route for eshop.
 */
"use strict";

const express = require("express");
const router  = express.Router();
const eshop = require("../../src/eshop.js");
const bodyParser = require("body-parser");
const urlencodedParser = bodyParser.urlencoded({ extended: false });

router.get(["/", "/eshop/index"], async ( req, res) => {
    let data = {
        title: "Välkommen | Eshop",
        res: await eshop.getCategories(),
        path: req.path
    };

    res.render("index", data);
});

router.get("/eshop/product", async (req, res) => {
    let data = {
        title: "Produkter | Eshop",
        res: await eshop.getProducts(),
        path: req.path
    };

    //console.log(res);
    res.render("product", data);
});

router.get("/eshop/product/create", urlencodedParser, async (req, res) => {
    let data = {
        title: "Ska Ny Produkt | Eshop",
        path: req.path,
        res: await eshop.getCategories(),
    };

    res.render("create", data);
});

router.post("/eshop/product/create", async (req, res) => {
    console.log(req.body);
    await eshop.createProduct(req.body);
    res.redirect("/eshop/product");
});


router.get("/eshop/product/edit/:id", async (req, res) => {
    let id = parseInt(req.params.id);

    console.log(typeof id);
    let data = {
        title: `Edit account ${id}`,
        res: await eshop.getOneProduct(id),
    };

    res.render("edit", data);
});

router.post("/eshop/product/edit/:id", urlencodedParser, async (req, res) => {
    console.log(req.body);
    await eshop.editProduct(req.body);
    res.redirect(`/eshop/product`);
});

router.get("/eshop/product/delete/:id", async (req, res) => {
    let id = parseInt(req.params.id);
    let data = {
        title: "Delete product",
        res: await eshop.getOneProduct(id)
    };

    console.log(res);
    res.render("delete", data);
});

router.post("/eshop/product/delete/:id", async (req, res) => {
    let id = parseInt(req.params.id);

    await eshop.deleteProduct(id);

    res.redirect("/eshop/product");
});

router.get("/eshop/category", async (req, res) => {
    let data = {
        title: "Kategorier | Eshop",
        res: await eshop.getCategories(),
        path: req.path
    };

    res.render("category", data);
});

router.get("/eshop/about", async (req, res) => {
    let data = {
        title: "Om | Eshop",
        path: req.path
    };

    res.render("about", data);
});

router.get("/eshop/customer", async (req, res) => {
    let data = {
        title: "Kunder | Eshop",
        res: await eshop.getCustomer(),
        path: req.path
    };

    res.render("customer", data);
});

router.get("/eshop/customer/:id", async (req, res) => {
    let id = await parseInt(req.params.id);

    await eshop.createOrder(id);

    res.redirect("/eshop/order");
});

router.get("/eshop/order", async (req, res) => {
    let data = {
        title: "Order | Eshop",
        res: await eshop.getOrders(),
        path: req.path
    };

    console.log(data);

    res.render("orders", data);
});

router.get("/eshop/order/create/:id", async (req, res) => {
    let data = {
        title: "Beställ Produkter | Eshop",
        res: await eshop.getProducts(),
        path: req.path
    };

    //console.log(res);
    res.render("addproduct", data);
});

router.post("/eshop/order/create/:id", async (req, res) => {
    await eshop.createVarukorg(req.body, req.params.id);

    //console.log(res);
    res.redirect("/eshop/order/show/" + req.params.id.toString());
});

router.get("/eshop/order/show/:id", async (req, res) => {
    let data = {
        title: "Visa beställning | Eshop",
        res: await eshop.getVarukorg(req.params.id),
        id: req.params.id.toString(),
        path: req.path
    };

    console.log(req.body);
    res.render("show", data);
});

router.get("/eshop/order/send/:id", async (req, res) => {
    let data = {
        title: "Beställd | Eshop",
        path: req.path
    };

    await eshop.orderDone(req.params.id);

    res.render("done", data);
});
module.exports = router;


