<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auramart.model.Product" %>

<%
    List<Product> products =
        (List<Product>) request.getAttribute("products");
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>AuraMart - Products</title>

<style>

/* ================================
   GLOBAL
================================ */

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background: #f1f3f6;
    color: #172337;
}

button,
input,
select {
    font-family: inherit;
}


/* ================================
   NAVBAR
================================ */

.navbar {
    position: sticky;
    top: 0;
    z-index: 1000;

    background: #2874f0;
    color: white;

    padding: 12px 5%;

    display: flex;
    align-items: center;
    gap: 22px;

    box-shadow:
        0 2px 8px rgba(0,0,0,.18);
}

.logo {
    font-size: 28px;
    font-weight: 800;
    white-space: nowrap;
}

.logo span {
    color: #ffe500;
}

.search-wrap {
    flex: 1;
    max-width: 720px;

    display: flex;
    align-items: center;

    position: relative;
}

.search-input {
    width: 100%;

    padding: 13px 105px 13px 18px;

    border: none;
    outline: none;

    border-radius: 4px;

    font-size: 15px;
}

.search-button {
    position: absolute;
    right: 4px;

    border: none;

    background: #fff;

    color: #2874f0;

    font-size: 18px;

    width: 42px;
    height: 38px;

    border-radius: 4px;

    cursor: pointer;
}

.ai-button {
    position: absolute;
    right: 48px;

    border: none;

    background: #eef4ff;

    color: #1d4ed8;

    padding: 7px 10px;

    border-radius: 4px;

    cursor: pointer;

    font-weight: bold;
}

.nav-actions {
    display: flex;
    gap: 12px;
    align-items: center;
}

.nav-btn {
    border: none;
    background: transparent;

    color: white;

    cursor: pointer;

    font-weight: bold;

    padding: 8px;
}


/* ================================
   CATEGORY BAR
================================ */

.category-bar {
    background: white;

    padding: 13px 5%;

    display: flex;
    gap: 25px;

    overflow-x: auto;

    box-shadow: 0 1px 4px rgba(0,0,0,.08);
}

.category-item {
    border: none;
    background: none;

    cursor: pointer;

    font-weight: bold;

    color: #374151;

    white-space: nowrap;
}

.category-item:hover,
.category-item.active {
    color: #2874f0;
}


/* ================================
   PAGE
================================ */

.container {
    max-width: 1400px;

    margin: 24px auto;

    padding: 0 20px;
}

.page-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;

    margin-bottom: 20px;
}

.page-heading h1 {
    font-size: 28px;
}

.product-count {
    color: #64748b;
    font-size: 14px;
}


/* ================================
   FILTER BAR
================================ */

.filters {
    background: white;

    padding: 16px;

    border-radius: 6px;

    display: flex;
    flex-wrap: wrap;

    gap: 12px;

    margin-bottom: 20px;

    box-shadow:
        0 2px 8px rgba(0,0,0,.06);
}

.filter-group {
    display: flex;

    align-items: center;

    gap: 7px;
}

.filter-group label {
    font-size: 13px;

    font-weight: bold;

    color: #475569;
}

.filter-group select {
    border: 1px solid #d1d5db;

    padding: 9px 12px;

    border-radius: 5px;

    background: white;

    outline: none;
}


/* ================================
   PRODUCT GRID
================================ */

.product-grid {
    display: grid;

    grid-template-columns:
        repeat(auto-fill, minmax(245px, 1fr));

    gap: 20px;
}


/* ================================
   FLIP CARD
================================ */

.product-card {
    height: 430px;

    perspective: 1200px;

    cursor: pointer;
}

.product-card-inner {
    width: 100%;
    height: 100%;

    position: relative;

    transition:
        transform .7s cubic-bezier(.4,.2,.2,1);

    transform-style: preserve-3d;
}

.product-card.is-flipped
.product-card-inner {
    transform: rotateY(180deg);
}

.product-front,
.product-back {
    position: absolute;

    width: 100%;
    height: 100%;

    backface-visibility: hidden;

    background: white;

    border-radius: 8px;

    box-shadow:
        0 3px 12px rgba(0,0,0,.10);

    overflow: hidden;
}

.product-back {
    transform: rotateY(180deg);

    padding: 24px;

    display: flex;
    flex-direction: column;
}


/* ================================
   FRONT
================================ */

.product-image-box {
    height: 225px;

    position: relative;

    display: flex;

    align-items: center;
    justify-content: center;

    background: #fff;
}

.product-image {
    max-width: 88%;
    max-height: 205px;

    object-fit: contain;

    transition: transform .25s ease;
}

.product-card:hover
.product-image {
    transform: scale(1.05);
}

.wishlist {
    position: absolute;

    top: 12px;
    right: 12px;

    width: 36px;
    height: 36px;

    border-radius: 50%;

    background: white;

    border: 1px solid #e5e7eb;

    font-size: 20px;

    cursor: pointer;

    z-index: 5;
}

.wishlist.active {
    color: #e11d48;
}

.offer-badge {
    position: absolute;

    top: 14px;
    left: 12px;

    background: #16a34a;
    color: white;

    padding: 5px 9px;

    border-radius: 3px;

    font-size: 11px;

    font-weight: bold;
}

.front-content {
    padding: 16px;
}

.category {
    display: inline-block;

    background: #eef2ff;

    color: #4338ca;

    padding: 4px 9px;

    border-radius: 12px;

    font-size: 11px;

    font-weight: bold;

    margin-bottom: 8px;
}

.product-name {
    font-weight: bold;

    font-size: 16px;

    color: #172337;

    margin-bottom: 8px;

    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;

    overflow: hidden;
}

.rating-row {
    display: flex;

    align-items: center;

    gap: 8px;

    margin-bottom: 10px;
}

.rating {
    background: #388e3c;

    color: white;

    padding: 4px 7px;

    border-radius: 4px;

    font-weight: bold;

    font-size: 12px;
}

.stars {
    color: #f59e0b;

    letter-spacing: 1px;

    font-size: 13px;
}

.review-count {
    color: #64748b;

    font-size: 12px;
}

.price {
    font-size: 22px;

    font-weight: 800;

    color: #172337;

    margin-bottom: 7px;
}

.special-price {
    color: #16a34a;

    font-size: 12px;

    font-weight: bold;
}

.stock {
    font-size: 12px;

    font-weight: bold;

    margin-top: 6px;
}

.in-stock {
    color: #16a34a;
}

.out-stock {
    color: #dc2626;
}


/* ================================
   BACK
================================ */

.back-title {
    font-size: 20px;

    font-weight: bold;

    margin-bottom: 15px;
}

.back-description {
    font-size: 13px;

    line-height: 1.6;

    color: #64748b;

    flex: 1;

    overflow: auto;
}

.info-line {
    margin: 9px 0;

    font-size: 13px;
}

.info-line strong {
    color: #172337;
}

.action-row {
    display: flex;

    gap: 8px;

    margin-top: 15px;
}

.cart-btn,
.buy-btn {
    flex: 1;

    padding: 11px 8px;

    border-radius: 5px;

    cursor: pointer;

    font-weight: bold;

    border: none;
}

.cart-btn {
    background: #ff9f00;
    color: white;
}

.buy-btn {
    background: #fb641b;
    color: white;
}

.cart-btn:hover {
    background: #e88d00;
}

.buy-btn:hover {
    background: #e4550f;
}

.flip-hint {
    text-align: center;

    font-size: 11px;

    color: #94a3b8;

    margin-top: 10px;
}


/* ================================
   NO RESULT
================================ */

.no-products {
    grid-column: 1 / -1;

    background: white;

    padding: 60px;

    text-align: center;

    border-radius: 8px;

    color: #64748b;
}


/* ================================
   AI CHAT
================================ */

.ai-chat {
    position: fixed;

    right: 24px;
    bottom: 24px;

    width: 380px;

    max-width: calc(100vw - 30px);

    background: white;

    border-radius: 14px;

    box-shadow:
        0 15px 45px rgba(0,0,0,.25);

    overflow: hidden;

    z-index: 2000;

    display: none;
}

.ai-chat.open {
    display: block;
}

.ai-header {
    background: #2874f0;

    color: white;

    padding: 15px 18px;

    display: flex;

    justify-content: space-between;

    align-items: center;
}

.ai-header-title {
    font-weight: bold;
}

.ai-close {
    background: none;

    border: none;

    color: white;

    cursor: pointer;

    font-size: 18px;
}

.ai-messages {
    height: 300px;

    overflow-y: auto;

    padding: 15px;

    background: #f8fafc;
}

.message {
    max-width: 85%;

    padding: 10px 12px;

    border-radius: 12px;

    margin-bottom: 10px;

    font-size: 13px;

    line-height: 1.5;
}

.message.ai {
    background: white;

    border: 1px solid #e2e8f0;
}

.message.user {
    background: #dbeafe;

    margin-left: auto;
}

.ai-input-row {
    display: flex;

    gap: 8px;

    padding: 10px;

    border-top: 1px solid #e5e7eb;
}

.ai-input {
    flex: 1;

    border: 1px solid #d1d5db;

    border-radius: 7px;

    padding: 10px;

    outline: none;
}

.ai-send {
    border: none;

    background: #2874f0;

    color: white;

    border-radius: 7px;

    padding: 0 14px;

    cursor: pointer;

    font-weight: bold;
}


/* ================================
   TOAST
================================ */

.toast {
    position: fixed;

    left: 50%;
    bottom: 28px;

    transform: translateX(-50%)
               translateY(80px);

    background: #111827;

    color: white;

    padding: 12px 20px;

    border-radius: 7px;

    opacity: 0;

    transition: .25s;

    z-index: 3000;

    font-size: 13px;
}

.toast.show {
    transform:
        translateX(-50%)
        translateY(0);

    opacity: 1;
}


/* ================================
   RESPONSIVE
================================ */

@media(max-width:900px) {

    .navbar {
        flex-wrap: wrap;
    }

    .search-wrap {
        order: 3;

        flex-basis: 100%;
    }

    .product-grid {
        grid-template-columns:
            repeat(2, minmax(0,1fr));
    }
}

@media(max-width:600px) {

    .navbar {
        padding: 10px 12px;
    }

    .logo {
        font-size: 22px;
    }

    .nav-actions {
        margin-left: auto;
    }

    .container {
        padding: 0 10px;
    }

    .page-heading {
        flex-direction: column;

        align-items: flex-start;

        gap: 5px;
    }

    .product-grid {
        grid-template-columns:
            repeat(2, minmax(0,1fr));

        gap: 10px;
    }

    .product-card {
        height: 390px;
    }

    .product-image-box {
        height: 185px;
    }

    .product-image {
        max-height: 170px;
    }

    .price {
        font-size: 18px;
    }

    .ai-chat {
        right: 8px;
        bottom: 8px;

        width: calc(100vw - 16px);
    }
}

</style>

<style>

.color-section {
    margin-top: 10px;
}

.color-title {
    font-size: 12px;
    font-weight: bold;
    color: #475569;
    margin-bottom: 6px;
}

.selected-color {
    color: #172337;
}

.color-options {
    display: flex;
    gap: 7px;
}

.color-swatch {
    width: 22px;
    height: 22px;
    border-radius: 50%;
    border: 2px solid white;
    outline: 1px solid #cbd5e1;
    cursor: pointer;
    transition: .2s;
}

.color-swatch:hover {
    transform: scale(1.15);
}

.color-swatch.active {
    outline: 2px solid #2874f0;
    outline-offset: 2px;
}

.color-swatch.black {
    background: #111827;
}

.color-swatch.white {
    background: #ffffff;
}

.color-swatch.blue {
    background: #2563eb;
}

.color-swatch.red {
    background: #ef4444;
}

.color-swatch.green {
    background: #16a34a;
}

.ai-result-product {
    padding: 8px;
    margin-bottom: 6px;
    border-radius: 7px;
    background: #f8fafc;
    cursor: pointer;
}

.ai-result-product:hover {
    background: #eef4ff;
}

</style></head>


<body>


<header class="navbar">

    <div class="logo">
        Aura<span>Mart</span>
    </div>


    <div class="search-wrap">

        <input
            id="searchInput"
            class="search-input"
            type="text"
            placeholder="Search products, brands and more..."
            autocomplete="off">

        <button
            type="button"
            class="ai-button"
            onclick="openAIChat()">

            &#129302; AI

        </button>

        <button
            type="button"
            class="search-button"
            onclick="runSearch()">

            [Search]?

        </button>

    </div>


    <div class="nav-actions">

        <button
            class="nav-btn"
            type="button"
            onclick="openAIChat()">

            &#128172; AI

        </button>

        <button
            class="nav-btn"
            type="button"
            onclick="showWishlist()">

            &#9829; <span id="wishlistCount">0</span>

        </button>

        <button
            class="nav-btn"
            type="button"
            onclick="goCart()">

            &#128722; Cart
            <span id="cartCount">0</span>

        </button>

    </div>

</header>


<div
    id="categoryBar"
    class="category-bar">

    <button
        class="category-item active"
        onclick="setCategory('ALL')">

        All

    </button>

</div>


<main class="container">


    <div class="page-heading">

        <div>

            <h1>
                Explore Products
            </h1>

            <div
                id="productCount"
                class="product-count">

                Products

            </div>

        </div>

    </div>


    <div class="filters">


        <div class="filter-group">

            <label>
                Category
            </label>

            <select id="categoryFilter">

                <option value="ALL">
                    All Categories
                </option>

            </select>

        </div>


        <div class="filter-group">

            <label>
                Price
            </label>

            <select id="priceFilter">

                <option value="ALL">
                    Any Price
                </option>

                <option value="0-1000">
                    Under &#8377;1,000
                </option>

                <option value="1000-5000">
                    &#8377;1,000 - &#8377;5,000
                </option>

                <option value="5000-20000">
                    &#8377;5,000 - &#8377;20,000
                </option>

                <option value="20000-999999999">
                    &#8377;20,000+
                </option>

            </select>

        </div>


        <div class="filter-group">

            <label>
                Rating
            </label>

            <select id="ratingFilter">

                <option value="0">
                    All Ratings
                </option>

                <option value="4">
                    &#11088;? 4&#9733; & above
                </option>

                <option value="4.5">
                    &#11088;? 4.5&#9733; & above
                </option>

            </select>

        </div>


        <div class="filter-group">

            <label>
                Sort
            </label>

            <select id="sortFilter">

                <option value="default">
                    Featured
                </option>

                <option value="price-low">
                    Price: Low to High
                </option>

                <option value="price-high">
                    Price: High to Low
                </option>

                <option value="rating">
                    Customer Rating
                </option>

                <option value="name">
                    Name
                </option>

            </select>

        </div>

    </div>


    <div
        id="productGrid"
        class="product-grid">

<%
    if (products != null && !products.isEmpty()) {

        for (Product product : products) {

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

            String image =
                product.getImage();

            if (image == null ||
                image.trim().isEmpty()) {

                image = "images/product-placeholder.png";
            }
%>

        <article
            class="product-card"
            data-id="<%= product.getId() %>"
            data-name="<%= product.getName() %>"
            data-category="<%= category %>"
            data-price="<%= product.getPrice() %>"
            data-stock="<%= product.getStock() %>"
            data-image="<%= image %>"
            data-description="<%= description.replace("\"","&quot;") %>">

            <div class="product-card-inner">


                <!-- FRONT -->

                <div class="product-front">

                    <div class="product-image-box">

                        <span class="offer-badge">
                            SPECIAL PRICE
                        </span>

                        <button
                            class="wishlist"
                            type="button"
                            onclick="toggleWishlist(event,<%= product.getId() %>)"
                            aria-label="Wishlist">

                            &#9825;

                        </button>


                        <img
                            class="product-image"
                            src="<%= image %>"
                            alt="<%= product.getName() %>"
                            onerror="this.src='<%= request.getContextPath() %>/images/product-placeholder.png'">

                    </div>


                    <div class="front-content">


                        <span class="category">
                            <%= category %>
                        </span>


                        <div class="product-name">
                            <%= product.getName() %>
                        </div>


                        <div class="rating-row">

                            <span
                                class="rating"
                                data-rating="<%= product.getId() %>">

                                &#11088;? 4.0

                            </span>

                            <span
                                class="stars"
                                data-stars="<%= product.getId() %>">

                                &#9733;&#9733;&#9733;&#9733;&#9734;

                            </span>

                            <span
                                class="review-count"
                                data-reviews="<%= product.getId() %>">

                                (0)

                            </span>

                        </div>


                        <div class="price">
                            &#8377;<%= product.getPrice() %>
                        </div>


                        <div class="special-price">
                            Special Price available
                        </div>


                        <div
                            class="stock <%= product.getStock() > 0 ? "in-stock" : "out-stock" %>">

                            <%= product.getStock() > 0
                                ? "[OK] In Stock"
                                : "&#10005; Out of Stock" %>

                        </div>


                        <div class="color-section">

    <div class="color-title">
        Colour:
        <span class="selected-color">Black</span>
    </div>

    <div class="color-options">

        <button
            type="button"
            class="color-swatch black active"
            data-color="Black"
            title="Black">
        </button>

        <button
            type="button"
            class="color-swatch white"
            data-color="White"
            title="White">
        </button>

        <button
            type="button"
            class="color-swatch blue"
            data-color="Blue"
            title="Blue">
        </button>

        <button
            type="button"
            class="color-swatch red"
            data-color="Red"
            title="Red">
        </button>

        <button
            type="button"
            class="color-swatch green"
            data-color="Green"
            title="Green">
        </button>

    </div>

</div>
<div class="flip-hint">
                            Click card for details &#8594;
                        </div>

                    </div>

                </div>


                <!-- BACK -->

                <div class="product-back">


                    <div class="back-title">
                        <%= product.getName() %>
                    </div>


                    <div class="info-line">

                        <strong>
                            Category:
                        </strong>

                        <%= category %>

                    </div>


                    <div
                        class="info-line">

                        <strong>
                            Price:
                        </strong>

                        &#8377;<%= product.getPrice() %>

                    </div>


                    <div
                        class="info-line">

                        <strong>
                            Stock:
                        </strong>

                        <%= product.getStock() %>

                    </div>


                    <div
                        class="back-description">

                        <%= description %>

                    </div>


                    <div class="action-row">


                        <button
                            type="button"
                            class="cart-btn"
                            onclick="addToCart(
                                event,
                                <%= product.getId() %>,
                                '<%= product.getName()
                                    .replace("'","\\\\'") %>',
                                '<%= image
                                    .replace("'","\\\\'") %>',
                                <%= product.getPrice() %>,
                                <%= product.getStock() %>
                            )">

                            &#128722; Add to Cart

                        </button>


                        <button
                            type="button"
                            class="buy-btn"
                            onclick="buyNow(
                                event,
                                <%= product.getId() %>,
                                '<%= product.getName()
                                    .replace("'","\\\\'") %>',
                                '<%= image
                                    .replace("'","\\\\'") %>',
                                <%= product.getPrice() %>,
                                <%= product.getStock() %>
                            )">

                            &#9889; Buy Now

                        </button>

                    </div>


                    <div class="color-section">

    <div class="color-title">
        Colour:
        <span class="selected-color">Black</span>
    </div>

    <div class="color-options">

        <button
            type="button"
            class="color-swatch black active"
            data-color="Black"
            title="Black">
        </button>

        <button
            type="button"
            class="color-swatch white"
            data-color="White"
            title="White">
        </button>

        <button
            type="button"
            class="color-swatch blue"
            data-color="Blue"
            title="Blue">
        </button>

        <button
            type="button"
            class="color-swatch red"
            data-color="Red"
            title="Red">
        </button>

        <button
            type="button"
            class="color-swatch green"
            data-color="Green"
            title="Green">
        </button>

    </div>

</div>
<div class="flip-hint">
                        Click card to flip back
                    </div>

                </div>

            </div>

        </article>

<%
        }

    } else {
%>

        <div class="no-products">

            <h2>
                No products found
            </h2>

            <p>
                Please check again later.
            </p>

        </div>

<%
    }
%>

    </div>

</main>


<!-- ================================
     AI CHAT
================================ -->

<div
    id="aiChat"
    class="ai-chat">


    <div class="ai-header">

        <div class="ai-header-title">
            &#129302; AuraMart AI Shopping Assistant
        </div>

        <button
            type="button"
            class="ai-close"
            onclick="closeAIChat()">

            &#10005;

        </button>

    </div>


    <div
        id="aiMessages"
        class="ai-messages">

        <div class="message ai">

            Hi! &#128075; I'm AuraMart AI.
            <br><br>

            Try asking:
            <br>
            &bull; "Best laptop under 50000"
            <br>
            &bull; "Show beauty products"
            <br>
            &bull; "Phone under 20000"
            <br>
            &bull; "Best rated products"

        </div>

    </div>


    <div class="ai-input-row">

        <input
            id="aiInput"
            class="ai-input"
            type="text"
            placeholder="Ask AuraMart AI...">

        <button
            type="button"
            class="ai-send"
            onclick="sendAIMessage()">

            Send

        </button>

    </div>

</div>


<div
    id="toast"
    class="toast">

    Added to cart

</div>


<script>

document.addEventListener("DOMContentLoaded", function () {

    /* ==========================================
       PRODUCT DATA
    ========================================== */

    const cards =
        Array.from(
            document.querySelectorAll(".product-card")
        );

    const products =
        cards.map(function (card) {

            const id =
                Number(card.dataset.id);

            return {
                id: id,
                name: card.dataset.name || "",
                category: card.dataset.category || "",
                price: Number(card.dataset.price) || 0,
                stock: Number(card.dataset.stock) || 0,
                image: card.dataset.image || "",
                description: card.dataset.description || "",
                rating: getRating(id),
                reviews: getReviews(id)
            };

        });


    /* ==========================================
       RATING
    ========================================== */

    function getRating(id) {

        const saved =
            localStorage.getItem(
                "auraMartRating_" + id
            );

        if (saved !== null) {
            return Number(saved);
        }

        return 4 +
            ((id * 17) % 10) / 10;
    }


    function getReviews(id) {

        const saved =
            localStorage.getItem(
                "auraMartReviews_" + id
            );

        if (saved !== null) {
            return Number(saved);
        }

        return 25 +
            ((id * 37) % 900);
    }


    function starText(rating) {

        const full =
            Math.min(5, Math.round(rating));

        return "&#9733;".repeat(full) +
               "&#9734;".repeat(5 - full);
    }


    cards.forEach(function (card) {

        const id =
            Number(card.dataset.id);

        const rating =
            getRating(id);

        const reviews =
            getReviews(id);

        const ratingElement =
            card.querySelector(
                '[data-rating="' + id + '"]'
            );

        const starsElement =
            card.querySelector(
                '[data-stars="' + id + '"]'
            );

        const reviewsElement =
            card.querySelector(
                '[data-reviews="' + id + '"]'
            );

        if (ratingElement) {
            ratingElement.innerText =
                "&#11088;? " + rating.toFixed(1);
        }

        if (starsElement) {
            starsElement.innerText =
                starText(rating);
        }

        if (reviewsElement) {
            reviewsElement.innerText =
                "(" +
                reviews.toLocaleString("en-IN") +
                ")";
        }

    });


    /* ==========================================
       PRODUCT CLICK
       Single click opens product details
    ========================================== */

    cards.forEach(function (card) {

        card.addEventListener(
            "click",
            function (event) {

                if (
                    event.target.closest("button") ||
                    event.target.closest("a")
                ) {
                    return;
                }

                const id =
                    card.dataset.id;

                if (!id) {
                    return;
                }

                window.location.href =
                    "product-details?id=" + id;

            }
        );

    });


    /* ==========================================
       COLOUR SWITCH
    ========================================== */

    cards.forEach(function (card) {

        const image =
            card.querySelector(
                ".product-image"
            );

        const swatches =
            card.querySelectorAll(
                ".color-swatch"
            );

        const colourLabel =
            card.querySelector(
                ".selected-color"
            );

        if (!swatches.length) {
            return;
        }


        const originalImage =
            image ? image.src : "";


        swatches.forEach(function (swatch) {

            swatch.addEventListener(
                "click",
                function (event) {

                    event.stopPropagation();

                    swatches.forEach(
                        function (item) {

                            item.classList.remove(
                                "active"
                            );

                        }
                    );

                    swatch.classList.add(
                        "active"
                    );


                    const colour =
                        swatch.dataset.color ||
                        "Black";


                    if (colourLabel) {

                        colourLabel.innerText =
                            colour;

                    }


                    if (!image ||
                        !originalImage) {

                        return;

                    }


                    const slash =
                        originalImage.lastIndexOf(
                            "/"
                        );


                    const path =
                        slash >= 0
                        ? originalImage.substring(
                            0,
                            slash + 1
                        )
                        : "";


                    const file =
                        slash >= 0
                        ? originalImage.substring(
                            slash + 1
                        )
                        : originalImage;


                    const dot =
                        file.lastIndexOf(
                            "."
                        );


                    if (dot <= 0) {
                        return;
                    }


                    const name =
                        file.substring(
                            0,
                            dot
                        );


                    const extension =
                        file.substring(dot);


                    const variant =
                        path +
                        name +
                        "-" +
                        colour.toLowerCase() +
                        extension;


                    const tester =
                        new Image();


                    tester.onload =
                        function () {

                            image.src =
                                variant;

                        };


                    tester.onerror =
                        function () {

                            image.src =
                                originalImage;

                        };


                    tester.src =
                        variant;

                }
            );

        });

    });


    /* ==========================================
       FILTERS
    ========================================== */

    const searchInput =
        document.getElementById(
            "searchInput"
        );

    const categoryFilter =
        document.getElementById(
            "categoryFilter"
        );

    const priceFilter =
        document.getElementById(
            "priceFilter"
        );

    const ratingFilter =
        document.getElementById(
            "ratingFilter"
        );

    const sortFilter =
        document.getElementById(
            "sortFilter"
        );


    const categories =
        [
            ...new Set(
                products
                    .map(function (p) {
                        return p.category;
                    })
                    .filter(Boolean)
            )
        ]
        .sort();


    const categoryBar =
        document.getElementById(
            "categoryBar"
        );


    categories.forEach(function (category) {

        if (categoryFilter) {

            const option =
                document.createElement(
                    "option"
                );

            option.value =
                category;

            option.innerText =
                category;

            categoryFilter.appendChild(
                option
            );

        }


        if (categoryBar) {

            const button =
                document.createElement(
                    "button"
                );

            button.type =
                "button";

            button.className =
                "category-item";

            button.innerText =
                category;

            button.addEventListener(
                "click",
                function () {

                    categoryFilter.value =
                        category;

                    applyFilters();

                }
            );

            categoryBar.appendChild(
                button
            );

        }

    });


    function applyFilters() {

        const search =
            searchInput
            ? searchInput.value
                .toLowerCase()
                .trim()
            : "";


        const category =
            categoryFilter
            ? categoryFilter.value
            : "ALL";


        const price =
            priceFilter
            ? priceFilter.value
            : "ALL";


        const rating =
            ratingFilter
            ? Number(
                ratingFilter.value
            )
            : 0;


        const sort =
            sortFilter
            ? sortFilter.value
            : "default";


        let result =
            products.filter(
                function (product) {


                    const text =
                        (
                            product.name +
                            " " +
                            product.category +
                            " " +
                            product.description
                        )
                        .toLowerCase();


                    const searchMatch =
                        !search ||
                        text.includes(search);


                    const categoryMatch =
                        category === "ALL" ||
                        product.category === category;


                    let priceMatch = true;


                    if (price !== "ALL") {

                        const parts =
                            price.split("-");

                        const min =
                            Number(parts[0]);

                        const max =
                            Number(parts[1]);


                        priceMatch =
                            product.price >= min &&
                            product.price <= max;

                    }


                    const ratingMatch =
                        product.rating >= rating;


                    return (
                        searchMatch &&
                        categoryMatch &&
                        priceMatch &&
                        ratingMatch
                    );

                }
            );


        if (sort === "price-low") {

            result.sort(
                (a, b) =>
                    a.price - b.price
            );

        }

        else if (sort === "price-high") {

            result.sort(
                (a, b) =>
                    b.price - a.price
            );

        }

        else if (sort === "rating") {

            result.sort(
                (a, b) =>
                    b.rating - a.rating
            );

        }

        else if (sort === "name") {

            result.sort(
                (a, b) =>
                    a.name.localeCompare(
                        b.name
                    )
            );

        }


        cards.forEach(function (card) {

            const id =
                Number(card.dataset.id);

            const visible =
                result.some(
                    function (product) {
                        return product.id === id;
                    }
                );

            card.style.display =
                visible
                ? ""
                : "none";

        });


        const count =
            document.getElementById(
                "productCount"
            );


        if (count) {

            count.innerText =
                result.length +
                " product(s) found";

        }

    }


    if (categoryFilter) {
        categoryFilter.addEventListener(
            "change",
            applyFilters
        );
    }

    if (priceFilter) {
        priceFilter.addEventListener(
            "change",
            applyFilters
        );
    }

    if (ratingFilter) {
        ratingFilter.addEventListener(
            "change",
            applyFilters
        );
    }

    if (sortFilter) {
        sortFilter.addEventListener(
            "change",
            applyFilters
        );
    }


    /* ==========================================
       SEARCH
    ========================================== */

    if (searchInput) {

        searchInput.addEventListener(
            "input",
            applyFilters
        );

    }


    /* ==========================================
       CART
    ========================================== */

    const CART_KEY =
        "auraMartCart";


    function getCart() {

        try {

            return JSON.parse(
                localStorage.getItem(
                    CART_KEY
                )
            ) || [];

        }
        catch (e) {

            return [];

        }

    }


    function saveCart(cart) {

        localStorage.setItem(
            CART_KEY,
            JSON.stringify(cart)
        );

        updateCartCount();

    }


    window.addToCart =
        function (
            event,
            id,
            name,
            image,
            price,
            stock
        ) {

            if (event) {
                event.stopPropagation();
            }


            if (stock <= 0) {

                showToast(
                    "Product is out of stock"
                );

                return;

            }


            const cart =
                getCart();


            const existing =
                cart.find(
                    function (item) {

                        return Number(
                            item.id
                        ) === id;

                    }
                );


            if (existing) {

                existing.quantity =
                    Number(
                        existing.quantity || 1
                    ) + 1;

            }
            else {

                cart.push({

                    id: id,

                    name: name,

                    image: image,

                    price: price,

                    quantity: 1

                });

            }


            saveCart(cart);

            showToast(
                "[OK] Added to cart"
            );

        };


    window.buyNow =
        function (
            event,
            id,
            name,
            image,
            price,
            stock
        ) {

            if (event) {
                event.stopPropagation();
            }


            if (stock <= 0) {

                showToast(
                    "Product is out of stock"
                );

                return;

            }


            saveCart([{

                id: id,

                name: name,

                image: image,

                price: price,

                quantity: 1

            }]);


            window.location.href =
                "cart.html";

        };


    function updateCartCount() {

        const countElement =
            document.getElementById(
                "cartCount"
            );

        if (!countElement) {
            return;
        }


        const count =
            getCart().reduce(
                function (total, item) {

                    return total +
                        (
                            Number(
                                item.quantity
                            ) || 0
                        );

                },
                0
            );


        countElement.innerText =
            count;

    }


    window.goCart =
        function () {

            window.location.href =
                "cart.html";

        };


    /* ==========================================
       WISHLIST
    ========================================== */

    const WISHLIST_KEY =
        "auraMartWishlist";


    function getWishlist() {

        try {

            return JSON.parse(
                localStorage.getItem(
                    WISHLIST_KEY
                )
            ) || [];

        }
        catch (e) {

            return [];

        }

    }


    function saveWishlist(items) {

        localStorage.setItem(
            WISHLIST_KEY,
            JSON.stringify(items)
        );

        updateWishlistCount();

        updateWishlistButtons();

    }


    window.toggleWishlist =
        function (
            event,
            id
        ) {

            if (event) {
                event.stopPropagation();
            }


            const wishlist =
                getWishlist();


            const index =
                wishlist.indexOf(id);


            if (index >= 0) {

                wishlist.splice(
                    index,
                    1
                );

                showToast(
                    "Removed from wishlist"
                );

            }
            else {

                wishlist.push(id);

                showToast(
                    "[Wishlist] Added to wishlist"
                );

            }


            saveWishlist(wishlist);

        };


    function updateWishlistCount() {

        const element =
            document.getElementById(
                "wishlistCount"
            );

        if (element) {

            element.innerText =
                getWishlist().length;

        }

    }


    function updateWishlistButtons() {

        const wishlist =
            getWishlist();


        cards.forEach(
            function (card) {

                const id =
                    Number(
                        card.dataset.id
                    );

                const button =
                    card.querySelector(
                        ".wishlist"
                    );

                if (!button) {
                    return;
                }


                if (
                    wishlist.includes(id)
                ) {

                    button.classList.add(
                        "active"
                    );

                    button.innerText =
                        "&#9829;";

                }
                else {

                    button.classList.remove(
                        "active"
                    );

                    button.innerText =
                        "&#9825;";

                }

            }
        );

    }


    window.showWishlist =
        function () {

            const wishlist =
                getWishlist();


            if (!wishlist.length) {

                showToast(
                    "Your wishlist is empty"
                );

                return;

            }


            cards.forEach(
                function (card) {

                    const id =
                        Number(
                            card.dataset.id
                        );

                    card.style.display =
                        wishlist.includes(id)
                        ? ""
                        : "none";

                }
            );


            const count =
                document.getElementById(
                    "productCount"
                );

            if (count) {

                count.innerText =
                    wishlist.length +
                    " wishlist product(s)";

            }

        };


    /* ==========================================
       AI CHAT
    ========================================== */

    const aiChat =
        document.getElementById(
            "aiChat"
        );

    const aiInput =
        document.getElementById(
            "aiInput"
        );

    const aiMessages =
        document.getElementById(
            "aiMessages"
        );


    window.openAIChat =
        function () {

            if (!aiChat) {
                return;
            }

            aiChat.classList.add(
                "open"
            );

            if (aiInput) {
                aiInput.focus();
            }

        };


    window.closeAIChat =
        function () {

            if (aiChat) {

                aiChat.classList.remove(
                    "open"
                );

            }

        };


    function addAIMessage(
        text,
        type
    ) {

        if (!aiMessages) {
            return;
        }


        const message =
            document.createElement(
                "div"
            );


        message.className =
            "message " + type;


        message.innerHTML =
            text;


        aiMessages.appendChild(
            message
        );


        aiMessages.scrollTop =
            aiMessages.scrollHeight;

    }


    window.sendAIMessage =
        function () {

            if (!aiInput) {
                return;
            }


            const query =
                aiInput.value.trim();


            if (!query) {
                return;
            }


            addAIMessage(
                escapeHTML(query),
                "user"
            );


            aiInput.value =
                "";


            const result =
                aiSearch(query);


            addAIMessage(
                result,
                "ai"
            );

        };


    function aiSearch(query) {

    const original =
        String(query || "")
            .toLowerCase()
            .trim();

    if(!original){
        return "Please tell me what you are looking for.";
    }


    /* =====================================
       CUSTOMER LANGUAGE
    ===================================== */

    let q = original
        .replace(/,/g,"")
        .replace(/?,?/g," rs ");


    const replacements = {
        "enakku":"need",
        "enaku":"need",
        "enakke":"need",
        "venum":"want",
        "venunga":"want",
        "vennu":"want",
        "kulla":"under",
        "kullla":"under",
        "kaatu":"show",
        "katu":"show",
        "kudu":"give",
        "kudunga":"give",
        "thaa":"give",
        "nalla":"good",
        "super":"best",
        "sirandha":"best",
        "maliva":"cheap",
        "malivaana":"cheap",
        "irukka":"available",
        "irukkaa":"available",
        "venumaa":"want"
    };


    Object.keys(replacements).forEach(
        function(word){

            q = q.replace(
                new RegExp(
                    "\\b" + word + "\\b",
                    "g"
                ),
                " " +
                replacements[word] +
                " "
            );

        }
    );


    /* =====================================
       50K / 20K / 1L BUDGET
    ===================================== */

    let maxPrice = null;


    let match =
        q.match(
            /(?:under|below|within|upto|up to|less than|budget)\s*(?:rs\s*)?(\d+(?:\.\d+)?)\s*k/
        );


    if(match){

        maxPrice =
            Number(match[1]) * 1000;

    }


    if(maxPrice === null){

        match =
            q.match(
                /(?:under|below|within|upto|up to|less than|budget)\s*(?:rs\s*)?(\d+(?:\.\d+)?)\s*l(?:akh)?/
            );

        if(match){

            maxPrice =
                Number(match[1]) * 100000;

        }

    }


    if(maxPrice === null){

        match =
            q.match(
                /(?:under|below|within|upto|up to|less than|budget)\s*(?:rs\s*)?(\d+)/
            );

        if(match){

            maxPrice =
                Number(match[1]);

        }

    }


    /* =====================================
       PRODUCT INTENT
    ===================================== */

    const groups = {

        laptop: [
            "laptop",
            "notebook",
            "computer",
            "pc"
        ],

        phone: [
            "phone",
            "mobile",
            "smartphone",
            "iphone",
            "android"
        ],

        headphone: [
            "headphone",
            "headphones",
            "earphone",
            "earphones",
            "earbuds",
            "airpods"
        ],

        watch: [
            "watch",
            "smartwatch"
        ],

        keyboard: [
            "keyboard"
        ],

        mouse: [
            "mouse"
        ],

        monitor: [
            "monitor",
            "display",
            "screen"
        ],

        beauty: [
            "beauty",
            "skincare",
            "skin",
            "makeup",
            "cosmetic",
            "shampoo",
            "conditioner",
            "moisturizer",
            "perfume"
        ],

        fashion: [
            "fashion",
            "dress",
            "shirt",
            "clothes",
            "shoe",
            "shoes"
        ],

        electronics: [
            "electronics",
            "electronic",
            "gadget",
            "device"
        ],

        home: [
            "home",
            "kitchen",
            "appliance",
            "house"
        ]

    };


    let intent = null;


    Object.keys(groups).some(
        function(key){

            const found =
                groups[key].some(
                    function(word){

                        return q.includes(word);

                    }
                );


            if(found){

                intent = key;

            }


            return found;

        }
    );


    /* =====================================
       PRODUCTS
    ===================================== */

    let result =
        products.slice();


    /* Intent filter */

    if(intent){

        const filtered =
            result.filter(
                function(product){

                    const text =
                        (
                            product.name +
                            " " +
                            product.category +
                            " " +
                            product.description
                        )
                        .toLowerCase();


                    return groups[intent]
                        .some(
                            function(word){

                                return text.includes(
                                    word
                                );

                            }
                        );

                }
            );


        if(filtered.length){

            result =
                filtered;

        }

    }


    /* Price filter */

    if(
        maxPrice !== null &&
        !Number.isNaN(maxPrice)
    ){

        result =
            result.filter(
                function(product){

                    return (
                        product.price <=
                        maxPrice
                    );

                }
            );

    }


    /* Stock */

    if(
        q.includes("available") ||
        q.includes("in stock")
    ){

        result =
            result.filter(
                function(product){

                    return product.stock > 0;

                }
            );

    }


    /* =====================================
       RATING INTENT
    ===================================== */

    if(
        q.includes("best") ||
        q.includes("top") ||
        q.includes("good") ||
        q.includes("rated") ||
        q.includes("rating") ||
        q.includes("recommended")
    ){

        result.sort(
            function(a,b){

                return (
                    b.rating -
                    a.rating
                );

            }
        );

    }


    /* =====================================
       CHEAPEST
    ===================================== */

    if(
        q.includes("cheap") ||
        q.includes("cheapest") ||
        q.includes("affordable") ||
        q.includes("low price")
    ){

        result.sort(
            function(a,b){

                return (
                    a.price -
                    b.price
                );

            }
        );

    }


    /* =====================================
       PREMIUM
    ===================================== */

    if(
        q.includes("premium") ||
        q.includes("luxury") ||
        q.includes("expensive")
    ){

        result.sort(
            function(a,b){

                return (
                    b.price -
                    a.price
                );

            }
        );

    }


    /* =====================================
       GENERIC KEYWORDS
    ===================================== */

    const ignored = [

        "need",
        "want",
        "show",
        "give",
        "find",
        "please",
        "me",
        "product",
        "products",
        "under",
        "below",
        "within",
        "upto",
        "up",
        "to",
        "less",
        "than",
        "budget",
        "best",
        "good",
        "top",
        "rated",
        "rating",
        "cheap",
        "cheapest",
        "affordable",
        "premium",
        "luxury",
        "expensive",
        "available",
        "stock"

    ];


    const words =
        q
            .replace(
                /[^a-z0-9 ]/g,
                " "
            )
            .split(/\s+/)
            .filter(
                function(word){

                    return (
                        word.length >= 3 &&
                        !ignored.includes(word) &&
                        !/^\d+$/.test(word)
                    );

                }
            );


    if(words.length){

        const keywordMatches =
            result.filter(
                function(product){

                    const text =
                        (
                            product.name +
                            " " +
                            product.category +
                            " " +
                            product.description
                        )
                        .toLowerCase();


                    return words.some(
                        function(word){

                            return text.includes(
                                word
                            );

                        }
                    );

                }
            );


        if(keywordMatches.length){

            result =
                keywordMatches;

        }

    }


    /* =====================================
       LIMIT
    ===================================== */

    result =
        result.slice(0,6);


    /* =====================================
       RESPONSE
    ===================================== */

    if(!result.length){

        return (
            "Sorry, matching product ?.??Y?^?.??.??????^." +
            "<br><br>" +
            "Try:" +
            "<br>" +
            "<b>enakku 50000 kulla laptop venum</b>" +
            "<br>" +
            "<b>20k budget la phone kudu</b>" +
            "<br>" +
            "<b>cheap beauty products kaatu</b>"
        );

    }


    let html =
        "?Y?- Purinjukitten! Here are matching products:" +
        "<br><br>";


    if(maxPrice !== null){

        html +=
            "Budget: ?,?" +
            maxPrice.toLocaleString(
                "en-IN"
            ) +
            "<br><br>";

    }


    if(intent){

        html +=
            "Category: " +
            intent +
            "<br><br>";

    }


    result.forEach(
        function(product,index){

            html +=
                "<div " +
                "class='ai-result-product' " +
                "onclick='focusProduct(" +
                product.id +
                ")'>" +

                "<b>" +
                (index + 1) +
                ". " +
                escapeHTML(
                    product.name
                ) +
                "</b>" +

                "<br>" +

                "Rating: " +
                product.rating.toFixed(1) +

                " ? ?,?" +
                product.price.toLocaleString(
                    "en-IN"
                ) +

                " ? " +
                escapeHTML(
                    product.category
                ) +

                "</div>";

        }
    );


    return html;

}
window.focusProduct =
        function (id) {

            if (!id) {
                return;
            }


            window.location.href =
                "product-details?id=" +
                id;

        };


    if (aiInput) {

        aiInput.addEventListener(
            "keydown",
            function (event) {

                if (
                    event.key === "Enter"
                ) {

                    event.preventDefault();

                    sendAIMessage();

                }

            }
        );

    }


    function escapeHTML(value) {

        return String(value)
            .replaceAll(
                "&",
                "&amp;"
            )
            .replaceAll(
                "<",
                "&lt;"
            )
            .replaceAll(
                ">",
                "&gt;"
            )
            .replaceAll(
                '"',
                "&quot;"
            )
            .replaceAll(
                "'",
                "&#039;"
            );

    }


    /* ==========================================
       AI BUTTON
    ========================================== */

    document
        .querySelectorAll(".ai-button")
        .forEach(
            function (button) {

                button.onclick =
                    function () {

                        openAIChat();

                    };

            }
        );


    /* ==========================================
       INITIALIZE
    ========================================== */

    updateCartCount();

    updateWishlistCount();

    updateWishlistButtons();

    applyFilters();

});

</script></body>

</html>




