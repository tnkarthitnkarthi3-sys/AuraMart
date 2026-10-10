<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.auramart.model.Product" %>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>AuraMart Seller Products</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #111827;
        }

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            width: 250px;
            background: #111827;
            padding: 25px 18px;
        }

        .brand {
            color: white;
            font-size: 25px;
            font-weight: bold;
            margin-bottom: 35px;
            padding-left: 12px;
        }

        .brand span {
            color: #38bdf8;
        }

        .nav a {
            display: block;
            text-decoration: none;
            color: #d1d5db;
            padding: 14px 15px;
            border-radius: 10px;
            margin-bottom: 8px;
        }

        .nav a:hover,
        .nav a.active {
            background: #1e40af;
            color: white;
        }

        .main {
            margin-left: 250px;
            padding: 35px;
        }

        h1 {
            margin-top: 0;
        }

        .layout {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 25px;
        }

        .box {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow:
                0 8px 25px rgba(0,0,0,.07);
        }

        .box h2 {
            margin-top: 0;
        }

        label {
            display: block;
            margin-top: 14px;
            margin-bottom: 6px;
            font-weight: bold;
            font-size: 14px;
        }

        input,
        textarea {
            width: 100%;
            padding: 11px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        .btn {
            width: 100%;
            border: none;
            padding: 12px;
            border-radius: 9px;
            margin-top: 18px;
            background: #2563eb;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .btn.delete {
            background: #dc2626;
        }

        .products {
            display: grid;
            grid-template-columns:
                repeat(auto-fill, minmax(250px, 1fr));
            gap: 18px;
        }

        .product {
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            padding: 18px;
        }

        .product img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            border-radius: 10px;
            background: #f3f4f6;
        }

        .product h3 {
            margin-bottom: 5px;
        }

        .price {
            font-size: 20px;
            font-weight: bold;
            color: #2563eb;
        }

        .stock {
            color: #6b7280;
            margin: 7px 0;
        }

        .edit {
            background: #f9fafb;
            padding: 15px;
            border-radius: 10px;
            margin-top: 15px;
        }

        .empty {
            color: #6b7280;
            padding: 30px;
        }

        @media(max-width: 1000px) {

            .layout {
                grid-template-columns: 1fr;
            }

            .sidebar {
                width: 200px;
            }

            .main {
                margin-left: 200px;
            }
        }

    </style>

<style>

/* =========================================================
   AURAMART PREMIUM ADMIN + SELLER UI
   CSS ONLY - BACKEND / JSP / JS PRESERVED
   ========================================================= */

*{
    box-sizing:border-box;
}

html{
    scroll-behavior:smooth;
}

body{
    background:
        radial-gradient(circle at 10% 10%,rgba(124,58,237,.22),transparent 28%),
        radial-gradient(circle at 90% 15%,rgba(37,99,235,.20),transparent 28%),
        radial-gradient(circle at 50% 100%,rgba(168,85,247,.15),transparent 35%),
        linear-gradient(135deg,#020617,#0b1024 48%,#111827)!important;
    color:#f8fafc!important;
    min-height:100vh;
}

/* subtle fabric/glass texture */

body::before{
    content:"";
    position:fixed;
    inset:-120px;
    pointer-events:none;
    z-index:-1;
    opacity:.45;
    background:
        repeating-linear-gradient(
            110deg,
            rgba(255,255,255,.035) 0,
            rgba(255,255,255,.035) 1px,
            transparent 1px,
            transparent 8px
        ),
        repeating-linear-gradient(
            20deg,
            rgba(255,255,255,.025) 0,
            rgba(255,255,255,.025) 1px,
            transparent 1px,
            transparent 10px
        );
    transform:rotate(-3deg) scale(1.2);
}

/* =========================================================
   ADMIN HEADER
   ========================================================= */

.header{
    background:rgba(2,6,23,.70)!important;
    border-bottom:1px solid rgba(255,255,255,.10)!important;
    backdrop-filter:blur(24px)!important;
    -webkit-backdrop-filter:blur(24px)!important;
    box-shadow:0 10px 40px rgba(0,0,0,.25)!important;
}

.header .brand{
    color:#fff!important;
    font-weight:900!important;
    letter-spacing:-.8px;
    text-shadow:0 0 25px rgba(139,92,246,.4);
}

.admin{
    color:#cbd5e1!important;
}

/* =========================================================
   SELLER SIDEBAR
   ========================================================= */

.sidebar{
    background:
        linear-gradient(
            180deg,
            rgba(2,6,23,.92),
            rgba(15,23,42,.88)
        )!important;
    border-right:1px solid rgba(255,255,255,.09)!important;
    box-shadow:15px 0 50px rgba(0,0,0,.25)!important;
    backdrop-filter:blur(25px)!important;
    -webkit-backdrop-filter:blur(25px)!important;
}

.sidebar .brand{
    color:#fff!important;
    font-weight:900!important;
    letter-spacing:-.8px;
    text-shadow:0 0 25px rgba(56,189,248,.25);
}

.brand span{
    color:#a78bfa!important;
}

.nav a{
    color:#94a3b8!important;
    border:1px solid transparent!important;
    transition:.28s ease!important;
}

.nav a:hover,
.nav a.active{
    background:
        linear-gradient(
            135deg,
            rgba(124,58,237,.28),
            rgba(37,99,235,.18)
        )!important;
    color:#fff!important;
    border-color:rgba(167,139,250,.22)!important;
    box-shadow:
        0 10px 30px rgba(124,58,237,.15),
        inset 0 1px 0 rgba(255,255,255,.06)!important;
    transform:translateX(4px);
}

/* =========================================================
   MAIN AREA
   ========================================================= */

.main,
.container{
    position:relative;
}

h1{
    color:transparent!important;
    background:linear-gradient(
        90deg,
        #fff,
        #c4b5fd,
        #93c5fd
    );
    -webkit-background-clip:text;
    background-clip:text;
    font-weight:900!important;
    letter-spacing:-1.5px;
}

h2,h3,h4{
    color:#f8fafc!important;
}

/* =========================================================
   SELLER TOPBAR
   ========================================================= */

.topbar{
    color:#fff!important;
}

.topbar p,
.topbar span,
.subtitle{
    color:#94a3b8!important;
}

/* =========================================================
   PREMIUM CARDS
   ========================================================= */

.card,
.stat-card,
.stats .card,
.product-card,
.order-card,
.panel,
.box,
.section,
.profile-card{
    background:
        linear-gradient(
            145deg,
            rgba(255,255,255,.105),
            rgba(255,255,255,.035)
        )!important;
    border:1px solid rgba(255,255,255,.10)!important;
    box-shadow:
        0 25px 70px rgba(0,0,0,.32),
        inset 0 1px 0 rgba(255,255,255,.07)!important;
    backdrop-filter:blur(25px)!important;
    -webkit-backdrop-filter:blur(25px)!important;
    border-radius:22px!important;
    transition:.30s ease!important;
}

.card:hover,
.stat-card:hover,
.stats .card:hover,
.product-card:hover,
.order-card:hover{
    transform:translateY(-5px);
    border-color:rgba(139,92,246,.30)!important;
    box-shadow:
        0 30px 80px rgba(0,0,0,.38),
        0 0 35px rgba(124,58,237,.08)!important;
}

/* =========================================================
   ADMIN STAT CARDS
   ========================================================= */

.stats{
    gap:24px!important;
}

.stats .card{
    padding:30px!important;
    overflow:hidden;
    position:relative;
}

.stats .card::before{
    content:"";
    position:absolute;
    width:120px;
    height:120px;
    right:-45px;
    top:-45px;
    border-radius:50%;
    background:rgba(139,92,246,.12);
    filter:blur(5px);
}

.icon{
    filter:drop-shadow(0 8px 15px rgba(124,58,237,.25));
}

.title{
    color:#94a3b8!important;
}

.number{
    color:#fff!important;
    font-weight:900!important;
    text-shadow:0 0 25px rgba(167,139,250,.18);
}

/* =========================================================
   TABLES
   ========================================================= */

table{
    width:100%;
    border-collapse:separate!important;
    border-spacing:0 8px!important;
    color:#e2e8f0!important;
}

thead th{
    color:#94a3b8!important;
    background:rgba(255,255,255,.035)!important;
    border-bottom:1px solid rgba(255,255,255,.08)!important;
    padding:15px!important;
}

tbody tr{
    background:rgba(255,255,255,.035)!important;
    transition:.25s ease!important;
}

tbody tr:hover{
    background:rgba(124,58,237,.09)!important;
    transform:scale(1.005);
}

tbody td{
    color:#cbd5e1!important;
    border-bottom:1px solid rgba(255,255,255,.05)!important;
    padding:15px!important;
}

/* =========================================================
   BUTTONS
   ========================================================= */

button,
.btn,
.button,
a.btn,
.add-btn,
.edit-btn,
.delete-btn,
.action-btn{
    border-radius:12px!important;
    transition:.25s ease!important;
}

button:hover,
.btn:hover,
.button:hover,
a.btn:hover,
.add-btn:hover,
.edit-btn:hover,
.delete-btn:hover,
.action-btn:hover{
    transform:translateY(-2px);
}

.add-btn,
.primary,
.btn-primary,
button[type="submit"]{
    background:linear-gradient(
        135deg,
        #7c3aed,
        #2563eb
    )!important;
    color:#fff!important;
    border:0!important;
    box-shadow:0 12px 30px rgba(99,102,241,.22)!important;
}

/* =========================================================
   FORMS
   ========================================================= */

input,
select,
textarea{
    background:rgba(2,6,23,.65)!important;
    color:#fff!important;
    border:1px solid rgba(255,255,255,.11)!important;
    border-radius:12px!important;
    outline:none!important;
}

input::placeholder,
textarea::placeholder{
    color:#64748b!important;
}

input:focus,
select:focus,
textarea:focus{
    border-color:#8b5cf6!important;
    box-shadow:0 0 0 3px rgba(139,92,246,.12)!important;
}

label{
    color:#cbd5e1!important;
    font-weight:700!important;
}

/* =========================================================
   SELLER PRODUCTS
   ========================================================= */

.product-image,
.product-card img{
    border-radius:16px!important;
    border:1px solid rgba(255,255,255,.10)!important;
    box-shadow:0 12px 30px rgba(0,0,0,.25)!important;
}

.product-card h3,
.product-card h4{
    color:#fff!important;
}

.product-card p{
    color:#94a3b8!important;
}

.price{
    color:#c4b5fd!important;
    font-weight:900!important;
}

/* =========================================================
   SELLER ORDERS
   ========================================================= */

.order-card,
.order-box{
    background:
        linear-gradient(
            145deg,
            rgba(255,255,255,.09),
            rgba(255,255,255,.03)
        )!important;
    border:1px solid rgba(255,255,255,.09)!important;
    border-radius:20px!important;
    box-shadow:0 20px 55px rgba(0,0,0,.28)!important;
}

.order-card strong,
.order-box strong{
    color:#fff!important;
}

.order-card span,
.order-box span{
    color:#94a3b8!important;
}

/* status badges */

.status,
.badge{
    border-radius:999px!important;
    border:1px solid rgba(255,255,255,.10)!important;
    padding:6px 12px!important;
    font-weight:800!important;
    backdrop-filter:blur(10px);
}

/* =========================================================
   LINKS
   ========================================================= */

a{
    transition:.22s ease;
}

.main a{
    color:#a78bfa;
}

.main a:hover{
    color:#c4b5fd;
}

/* =========================================================
   ERROR / SUCCESS
   ========================================================= */

.error{
    background:rgba(239,68,68,.08)!important;
    color:#fca5a5!important;
    border:1px solid rgba(239,68,68,.18)!important;
    border-radius:14px!important;
}

.success{
    background:rgba(34,197,94,.08)!important;
    color:#86efac!important;
    border:1px solid rgba(34,197,94,.18)!important;
    border-radius:14px!important;
}

/* =========================================================
   SCROLLBAR
   ========================================================= */

::-webkit-scrollbar{
    width:9px;
}

::-webkit-scrollbar-track{
    background:#020617;
}

::-webkit-scrollbar-thumb{
    background:linear-gradient(#7c3aed,#2563eb);
    border-radius:20px;
}

/* =========================================================
   MOBILE
   ========================================================= */

@media(max-width:800px){

    .sidebar{
        position:relative!important;
        width:100%!important;
        height:auto!important;
        min-height:auto!important;
        padding:18px!important;
    }

    .sidebar .brand{
        margin-bottom:15px!important;
    }

    .nav{
        display:flex;
        flex-wrap:wrap;
        gap:7px;
    }

    .nav a{
        margin-bottom:0!important;
        padding:10px 12px!important;
    }

    .main{
        margin-left:0!important;
        padding:20px!important;
    }

    .stats{
        grid-template-columns:1fr!important;
    }

    .header{
        padding:16px 20px!important;
        gap:12px;
    }

    table{
        min-width:700px;
    }

    .card{
        border-radius:18px!important;
    }
}

</style>
</head>

<body>

<aside class="sidebar">

    <div class="brand">
        Aura<span>Mart</span>
    </div>

    <nav class="nav">

        <a href="dashboard.html">
            📊 Dashboard
        </a>

        <a href="orders">
            🛒 Orders
        </a>

        <a
            class="active"
            href="products"
        >
            📦 My Products
        </a>

        <a href="profile">
            👤 Profile
        </a>

        <a href="../logout">
            🚪 Logout
        </a>

    </nav>

</aside>


<main class="main">

    <h1>
        My Products
    </h1>

    <p>
        Add and manage your AuraMart products.
    </p>


    <div class="layout">

        <!-- ADD PRODUCT -->

        <div class="box">

            <h2>
                ➕ Add Product
            </h2>

            <form
                method="post"
                action="<%= request.getContextPath() %>/seller/products"
            >

                <input
                    type="hidden"
                    name="action"
                    value="add"
                >

                <label>
                    Product Name
                </label>

                <input
                    type="text"
                    name="name"
                    required
                >


                <label>
                    Category
                </label>

                <input
                    type="text"
                    name="category"
                    required
                >


                <label>
                    Description
                </label>

                <textarea
                    name="description"
                ></textarea>


                <label>
                    Price
                </label>

                <input
                    type="number"
                    name="price"
                    min="0"
                    step="0.01"
                    required
                >


                <label>
                    Stock
                </label>

                <input
                    type="number"
                    name="stock"
                    min="0"
                    required
                >


                <label>
                    Image Path
                </label>

                <input
                    type="text"
                    name="image"
                    placeholder="images/product.jpg"
                >


                <button
                    class="btn"
                    type="submit"
                >
                    Add Product
                </button>

            </form>

        </div>


        <!-- PRODUCT LIST -->

        <div class="box">

            <h2>
                📦 My Products
            </h2>

            <div class="products">

            <%
                List<Product> products =
                        (List<Product>)
                        request.getAttribute("products");

                if (products == null ||
                    products.isEmpty()) {
            %>

                <div class="empty">
                    No products found.
                </div>

            <%
                } else {

                    for (Product p : products) {
            %>

                <div class="product">

                    <%
                        String image =
                                p.getImage();

                        if (image != null &&
                            !image.trim().isEmpty()) {
                    %>

                        <img
                            src="<%= request.getContextPath() %>/<%= image %>"
                            alt="<%= p.getName() %>"
                        >

                    <%
                        }
                    %>


                    <h3>
                        <%= p.getName() %>
                    </h3>

                    <div>
                        <%= p.getCategory() %>
                    </div>

                    <p>
                        <%= p.getDescription() %>
                    </p>

                    <div class="price">
                        ₹<%= p.getPrice() %>
                    </div>

                    <div class="stock">
                        Stock:
                        <%= p.getStock() %>
                    </div>


                    <!-- EDIT -->

                    <details class="edit">

                        <summary>
                            ✏️ Edit Product
                        </summary>

                        <form
                            method="post"
                            action="<%= request.getContextPath() %>/seller/products"
                        >

                            <input
                                type="hidden"
                                name="action"
                                value="update"
                            >

                            <input
                                type="hidden"
                                name="id"
                                value="<%= p.getId() %>"
                            >


                            <label>
                                Name
                            </label>

                            <input
                                type="text"
                                name="name"
                                value="<%= p.getName() %>"
                                required
                            >


                            <label>
                                Category
                            </label>

                            <input
                                type="text"
                                name="category"
                                value="<%= p.getCategory() %>"
                            >


                            <label>
                                Description
                            </label>

                            <textarea
                                name="description"
                            ><%= p.getDescription() == null ? "" : p.getDescription() %></textarea>


                            <label>
                                Price
                            </label>

                            <input
                                type="number"
                                name="price"
                                min="0"
                                step="0.01"
                                value="<%= p.getPrice() %>"
                                required
                            >


                            <label>
                                Stock
                            </label>

                            <input
                                type="number"
                                name="stock"
                                min="0"
                                value="<%= p.getStock() %>"
                                required
                            >


                            <label>
                                Image
                            </label>

                            <input
                                type="text"
                                name="image"
                                value="<%= p.getImage() == null ? "" : p.getImage() %>"
                            >


                            <button
                                class="btn"
                                type="submit"
                            >
                                Save Changes
                            </button>

                        </form>

                    </details>


                    <!-- DELETE -->

                    <form
                        method="post"
                        action="<%= request.getContextPath() %>/seller/products"
                        onsubmit="return confirm('Delete this product?');"
                    >

                        <input
                            type="hidden"
                            name="action"
                            value="delete"
                        >

                        <input
                            type="hidden"
                            name="id"
                            value="<%= p.getId() %>"
                        >

                        <button
                            class="btn delete"
                            type="submit"
                        >
                            🗑 Delete Product
                        </button>

                    </form>

                </div>

            <%
                    }
                }
            %>

            </div>

        </div>

    </div>

</main>

</body>

</html>

