<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auramart.model.Product" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AuraMart - Product Management</title>

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background: #f1f5f9;
    color: #0f172a;
}

/* HEADER */
header {
    background: #111827;
    color: white;
    padding: 18px 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: sticky;
    top: 0;
    z-index: 100;
}

.logo {
    font-size: 27px;
    font-weight: bold;
}

nav {
    display: flex;
    gap: 18px;
    flex-wrap: wrap;
}

nav a {
    color: white;
    text-decoration: none;
    font-weight: bold;
}

nav a:hover {
    color: #38bdf8;
}

/* MAIN */
.container {
    max-width: 1400px;
    margin: auto;
    padding: 35px 25px;
}

.title {
    text-align: center;
    font-size: 36px;
    margin-bottom: 8px;
}

.subtitle {
    text-align: center;
    color: #64748b;
    margin-bottom: 30px;
}

/* TOP ACTIONS */
.top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 30px;
    flex-wrap: wrap;
}

.search {
    flex: 1;
    min-width: 250px;
}

.search input {
    width: 100%;
    padding: 14px 18px;
    border: 1px solid #cbd5e1;
    border-radius: 10px;
    font-size: 16px;
    outline: none;
}

.add-product {
    background: #4f46e5;
    color: white;
    text-decoration: none;
    padding: 14px 20px;
    border-radius: 10px;
    font-weight: bold;
}

.add-product:hover {
    background: #3730a3;
}

/* GRID */
.product-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
    gap: 28px;
}

/* FLIP CARD */
.flip-card {
    background: transparent;
    width: 100%;
    height: 430px;
    perspective: 1200px;
}

.flip-inner {
    position: relative;
    width: 100%;
    height: 100%;
    transition: transform 0.7s;
    transform-style: preserve-3d;
}

.flip-card:hover .flip-inner {
    transform: rotateY(180deg);
}

.card-front,
.card-back {
    position: absolute;
    width: 100%;
    height: 100%;
    border-radius: 20px;
    overflow: hidden;
    backface-visibility: hidden;
    box-shadow: 0 12px 30px rgba(0,0,0,0.12);
}

/* FRONT */
.card-front {
    background: white;
}

.product-image {
    width: 100%;
    height: 225px;
    object-fit: cover;
    background: #e2e8f0;
}

.front-content {
    padding: 20px;
}

.category {
    display: inline-block;
    background: #e0e7ff;
    color: #3730a3;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
    margin-bottom: 10px;
}

.product-name {
    font-size: 21px;
    font-weight: bold;
    margin-bottom: 8px;
}

.price {
    color: #e11d48;
    font-size: 23px;
    font-weight: bold;
    margin-bottom: 12px;
}

.flip-hint {
    color: #64748b;
    font-size: 13px;
}

/* BACK */
.card-back {
    background: linear-gradient(145deg, #111827, #312e81);
    color: white;
    transform: rotateY(180deg);
    padding: 25px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.back-title {
    font-size: 22px;
    font-weight: bold;
    margin-bottom: 12px;
}

.description {
    color: #cbd5e1;
    line-height: 1.6;
    font-size: 14px;
    min-height: 70px;
}

/* STOCK */
.stock-box {
    padding: 15px;
    border-radius: 12px;
    background: rgba(255,255,255,0.1);
}

.stock-number {
    font-size: 27px;
    font-weight: bold;
}

.stock-label {
    font-size: 13px;
    color: #cbd5e1;
}

.status {
    display: inline-block;
    margin-top: 10px;
    padding: 7px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
}

.in-stock {
    background: #dcfce7;
    color: #166534;
}

.out-stock {
    background: #fee2e2;
    color: #991b1b;
}

.refill {
    background: #fef3c7;
    color: #92400e;
}

/* BUTTONS */
.actions {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 9px;
}

.actions button,
.actions a {
    border: none;
    padding: 11px;
    border-radius: 8px;
    text-align: center;
    text-decoration: none;
    font-weight: bold;
    cursor: pointer;
    font-size: 13px;
}

.edit {
    background: #38bdf8;
    color: #082f49;
}

.refill-btn {
    background: #fbbf24;
    color: #451a03;
}

.delete {
    background: #ef4444;
    color: white;
}

.activate {
    background: #22c55e;
    color: white;
}

.no-products {
    text-align: center;
    padding: 70px;
    color: #64748b;
    font-size: 20px;
}

/* MOBILE */
@media(max-width:650px) {
    .title {
        font-size: 28px;
    }

    header {
        flex-direction: column;
        gap: 15px;
    }

    nav {
        justify-content: center;
    }

    .flip-card {
        height: 420px;
    }
}
</style>
</head>

<body>

<header>
    <div class="logo">AuraMart</div>

    <nav>
        <a href="../index.html">Home</a>
        <a href="../products">Products</a>
        <a href="admin.jsp">Dashboard</a>
        <a href="products.jsp">Manage Products</a>
        <a href="orders.jsp">Manage Orders</a>
    </nav>
</header>

<div class="container">

    <h1 class="title">AuraMart Product Management</h1>

    <p class="subtitle">
        Manage products, stock and availability
    </p>

    <div class="top-bar">

        <div class="search">
            <input
                type="text"
                id="searchInput"
                placeholder="Search products..."
                onkeyup="searchProducts()">
        </div>

        <a class="add-product" href="add-product.jsp">
            + Add Product
        </a>

    </div>

    <div class="product-grid" id="productGrid">

<%
    if (products != null && !products.isEmpty()) {

        for (Product p : products) {

            int stock = p.getStock();

            String statusClass;
            String statusText;

            if (stock <= 0) {
                statusClass = "out-stock";
                statusText = "OUT OF STOCK";
            }
            else if (stock <= 3) {
                statusClass = "refill";
                statusText = "NEED REFILL";
            }
            else {
                statusClass = "in-stock";
                statusText = "IN STOCK";
            }
%>

        <div class="flip-card product-item"
             data-name="<%= p.getName().toLowerCase() %>"
             data-category="<%= p.getCategory() == null ? "" : p.getCategory().toLowerCase() %>">

            <div class="flip-inner">

                <!-- FRONT -->
                <div class="card-front">

                    <img
                        class="product-image"
                        src="../<%= p.getImage() %>"
                        alt="<%= p.getName() %>"
                        onerror="this.src='../images/placeholder.jpg'">

                    <div class="front-content">

                        <span class="category">
                            <%= p.getCategory() == null ? "General" : p.getCategory() %>
                        </span>

                        <div class="product-name">
                            <%= p.getName() %>
                        </div>

                        <div class="price">
                            ?,?<%= p.getPrice() %>
                        </div>

                        <div class="flip-hint">
                            ??? Hover to view stock & management
                        </div>

                    </div>

                </div>

                <!-- BACK -->
                <div class="card-back">

                    <div>

                        <div class="back-title">
                            <%= p.getName() %>
                        </div>

                        <div class="description">
                            <%= p.getDescription() == null
                                ? "No description available."
                                : p.getDescription() %>
                        </div>

                    </div>

                    <div class="stock-box">

                        <div class="stock-label">
                            CURRENT STOCK
                        </div>

                        <div class="stock-number">
                            <%= stock %>
                        </div>

                        <span class="status <%= statusClass %>">
                            <%= statusText %>
                        </span>

                    </div>

                    <div class="actions">

                        <a class="edit"
                           href="edit-product.jsp?id=<%= p.getId() %>">
                            Edit
                        </a>

                        <a class="refill-btn"
                           href="refill-product.jsp?id=<%= p.getId() %>">
                            Refill
                        </a>

                        <a class="delete"
                           href="delete-product?id=<%= p.getId() %>"
                           onclick="return confirm('Deactivate this product?');">
                            Delete
                        </a>

                        <a class="activate"
                           href="activate-product?id=<%= p.getId() %>">
                            Activate
                        </a>

                    </div>

                </div>

            </div>

        </div>

<%
        }

    } else {
%>

        <div class="no-products">
            No products available.
        </div>

<%
    }
%>

    </div>

</div>

<script>

function searchProducts() {

    const search =
        document.getElementById("searchInput")
        .value
        .toLowerCase()
        .trim();

    const cards =
        document.querySelectorAll(".product-item");

    cards.forEach(function(card) {

        const name =
            card.dataset.name || "";

        const category =
            card.dataset.category || "";

        if (
            name.includes(search) ||
            category.includes(search)
        ) {
            card.style.display = "";
        } else {
            card.style.display = "none";
        }

    });
}

</script>

</body>
</html>




