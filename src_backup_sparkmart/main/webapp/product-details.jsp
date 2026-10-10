<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.auramart.model.Product" %>

<%
    Product product =
        (Product) request.getAttribute("product");

    String image =
        product.getImage();

    if (image == null ||
        image.trim().isEmpty()) {

        image =
            "images/product-placeholder.png";
    }

    String category =
        product.getCategory();

    if (category == null ||
        category.trim().isEmpty()) {

        category = "Uncategorized";
    }

    String description =
        product.getDescription();

    if (description == null ||
        description.trim().isEmpty()) {

        description =
            "Quality product from AuraMart.";
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    <%= product.getName() %> - AuraMart
</title>

<style>

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
}

body {
    background: #f1f3f6;
    color: #172337;
}

.navbar {
    background: #2874f0;
    color: white;
    padding: 14px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.logo {
    font-size: 26px;
    font-weight: bold;
}

.logo span {
    color: #ffe500;
}

.navbar a {
    color: white;
    text-decoration: none;
    font-weight: bold;
}

.container {
    max-width: 1200px;
    margin: 30px auto;
    padding: 0 20px;
}

.product-details {
    background: white;
    border-radius: 10px;
    padding: 30px;
    display: grid;
    grid-template-columns: 45% 55%;
    gap: 35px;
    box-shadow: 0 4px 15px rgba(0,0,0,.08);
}

.image-panel {
    min-height: 480px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-right: 1px solid #e5e7eb;
}

.main-image {
    width: 90%;
    max-height: 440px;
    object-fit: contain;
}

.info-panel {
    padding: 15px;
}

.category {
    display: inline-block;
    background: #eef2ff;
    color: #4338ca;
    padding: 6px 12px;
    border-radius: 15px;
    font-size: 12px;
    font-weight: bold;
    margin-bottom: 12px;
}

h1 {
    font-size: 30px;
    margin-bottom: 12px;
}

.rating {
    display: inline-block;
    background: #388e3c;
    color: white;
    padding: 6px 9px;
    border-radius: 4px;
    font-weight: bold;
}

.stars {
    color: #f59e0b;
    margin-left: 8px;
    letter-spacing: 2px;
}

.price {
    font-size: 32px;
    font-weight: bold;
    margin: 20px 0 5px;
}

.special {
    color: #16a34a;
    font-weight: bold;
    margin-bottom: 15px;
}

.description {
    color: #64748b;
    line-height: 1.7;
    margin: 18px 0;
}

.info {
    margin: 10px 0;
    font-size: 15px;
}

.in-stock {
    color: #16a34a;
    font-weight: bold;
}

.out-stock {
    color: #dc2626;
    font-weight: bold;
}

.colours {
    margin-top: 22px;
}

.colours h3 {
    margin-bottom: 10px;
}

.swatches {
    display: flex;
    gap: 12px;
}

.swatch {
    width: 34px;
    height: 34px;
    border-radius: 50%;
    border: 2px solid white;
    outline: 1px solid #cbd5e1;
    cursor: pointer;
}

.swatch.active {
    outline: 3px solid #2874f0;
    outline-offset: 2px;
}

.black { background: #111827; }
.white { background: white; }
.blue { background: #2563eb; }
.red { background: #ef4444; }
.green { background: #16a34a; }

.selected-color {
    font-size: 13px;
    color: #475569;
    margin-bottom: 10px;
}

.buttons {
    display: flex;
    gap: 12px;
    margin-top: 28px;
}

.btn {
    flex: 1;
    border: none;
    padding: 15px;
    border-radius: 5px;
    cursor: pointer;
    color: white;
    font-weight: bold;
    font-size: 15px;
}

.cart {
    background: #ff9f00;
}

.buy {
    background: #fb641b;
}

.btn:hover {
    opacity: .9;
}

@media(max-width:800px) {

    .product-details {
        grid-template-columns: 1fr;
    }

    .image-panel {
        border-right: none;
        border-bottom: 1px solid #e5e7eb;
        min-height: 350px;
    }

    h1 {
        font-size: 23px;
    }

    .price {
        font-size: 26px;
    }

}

</style>

</head>

<body>

<header class="navbar">

    <div class="logo">
        Aura<span>Mart</span>
    </div>

    <a href="products">
        ??? Back to Products
    </a>

</header>


<main class="container">

<div class="product-details">


    <div class="image-panel">

        <img
            id="mainImage"
            class="main-image"
            src="<%= image %>"
            alt="<%= product.getName() %>">

    </div>


    <div class="info-panel">

        <span class="category">
            <%= category %>
        </span>

        <h1>
            <%= product.getName() %>
        </h1>


        <div>

            <span class="rating">
                ? 4.5
            </span>

            <span class="stars">
                ?~.?~.?~.?~.?~.
            </span>

            <span>
                (328 Ratings)
            </span>

        </div>


        <div class="price">
            ?,?<%= product.getPrice() %>
        </div>


        <div class="special">
            Special Price
        </div>


        <div class="info">

            <strong>
                Stock:
            </strong>

            <span class="<%= product.getStock() > 0
                ? "in-stock"
                : "out-stock" %>">

                <%= product.getStock() > 0
                    ? "?o" In Stock"
                    : "?o. Out of Stock" %>

            </span>

        </div>


        <div class="info">

            <strong>
                Category:
            </strong>

            <%= category %>

        </div>


        <div class="description">

            <strong>
                Product Details
            </strong>

            <br><br>

            <%= description %>

        </div>


        <div class="colours">

            <h3>
                Colour
            </h3>

            <div class="selected-color">
                Selected:
                <strong id="selectedColor">
                    Black
                </strong>
            </div>


            <div class="swatches">

                <button
                    type="button"
                    class="swatch black active"
                    data-color="Black">
                </button>

                <button
                    type="button"
                    class="swatch white"
                    data-color="White">
                </button>

                <button
                    type="button"
                    class="swatch blue"
                    data-color="Blue">
                </button>

                <button
                    type="button"
                    class="swatch red"
                    data-color="Red">
                </button>

                <button
                    type="button"
                    class="swatch green"
                    data-color="Green">
                </button>

            </div>

        </div>


        <div class="buttons">

            <button
                type="button"
                class="btn cart"
                onclick="addProductToCart()">

                ?Y>' Add to Cart

            </button>

            <button
                type="button"
                class="btn buy"
                onclick="buyProduct()">

                ?s? Buy Now

            </button>

        </div>

    </div>

</div>

</main>


<script>

const product = {

    id:
        <%= product.getId() %>,

    name:
        "<%= product.getName()
            .replace("\\","\\\\")
            .replace("\"","\\\"")
            .replace("'","\\'") %>",

    price:
        <%= product.getPrice() %>,

    image:
        "<%= image
            .replace("\\","\\\\")
            .replace("\"","\\\"")
            .replace("'","\\'") %>",

    stock:
        <%= product.getStock() %>

};


const CART_KEY =
    "auraMartCart";


let selectedColour =
    "Black";


document
    .querySelectorAll(".swatch")
    .forEach(function(button) {

        button.addEventListener(
            "click",
            function() {

                document
                    .querySelectorAll(".swatch")
                    .forEach(
                        function(item) {
                            item.classList.remove(
                                "active"
                            );
                        }
                    );

                button.classList.add(
                    "active"
                );

                selectedColour =
                    button.dataset.color;

                document
                    .getElementById(
                        "selectedColor"
                    )
                    .innerText =
                        selectedColour;


                const base =
                    product.image;

                const slash =
                    base.lastIndexOf("/");

                const path =
                    slash >= 0
                    ? base.substring(0, slash + 1)
                    : "";

                const file =
                    slash >= 0
                    ? base.substring(slash + 1)
                    : base;

                const dot =
                    file.lastIndexOf(".");

                if(dot > 0) {

                    const filename =
                        file.substring(0, dot);

                    const extension =
                        file.substring(dot);

                    const variant =
                        path +
                        filename +
                        "-" +
                        selectedColour.toLowerCase() +
                        extension;

                    const test =
                        new Image();

                    test.onload =
                        function() {

                            document
                                .getElementById(
                                    "mainImage"
                                )
                                .src =
                                    variant;

                        };

                    test.onerror =
                        function() {

                            document
                                .getElementById(
                                    "mainImage"
                                )
                                .src =
                                    product.image;

                        };

                    test.src =
                        variant;

                }

            }
        );

    });


function getCart() {

    try {

        return JSON.parse(
            localStorage.getItem(
                CART_KEY
            )
        ) || [];

    } catch(e) {

        return [];

    }

}


function saveCart(cart) {

    localStorage.setItem(
        CART_KEY,
        JSON.stringify(cart)
    );

}


function addProductToCart() {

    if(product.stock <= 0) {

        alert(
            "Product is out of stock."
        );

        return;

    }


    const cart =
        getCart();


    const existing =
        cart.find(
            function(item) {

                return Number(item.id) ===
                    product.id;

            }
        );


    if(existing) {

        existing.quantity =
            Number(existing.quantity || 1) + 1;

        existing.color =
            selectedColour;

    } else {

        cart.push({

            id: product.id,

            name: product.name,

            image: product.image,

            price: product.price,

            quantity: 1,

            color: selectedColour

        });

    }


    saveCart(cart);

    alert(
        "?o" Added to cart"
    );

}


function buyProduct() {

    if(product.stock <= 0) {

        alert(
            "Product is out of stock."
        );

        return;

    }


    const cart = [

        {

            id: product.id,

            name: product.name,

            image: product.image,

            price: product.price,

            quantity: 1,

            color: selectedColour

        }

    ];


    saveCart(cart);

    window.location.href =
        "cart.html";

}

</script>

</body>

</html>



