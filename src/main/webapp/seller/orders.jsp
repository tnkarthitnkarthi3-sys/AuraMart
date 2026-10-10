<%@ page import="java.util.List" %>
<%@ page import="com.auramart.model.SellerOrder" %>

<%
    List<SellerOrder> sellerOrders =
            (List<SellerOrder>) request.getAttribute("sellerOrders");

    String error =
            (String) request.getAttribute("error");

    String contextPath =
            request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>Seller Orders - AuraMart</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            color: #222;
        }

        .header {
            background: #111827;
            color: white;
            padding: 18px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand {
            font-size: 24px;
            font-weight: bold;
        }

        .back {
            color: white;
            text-decoration: none;
            background: #2563eb;
            padding: 10px 18px;
            border-radius: 8px;
        }

        .container {
            max-width: 1250px;
            margin: 30px auto;
            padding: 0 20px;
        }

        h1 {
            margin-bottom: 8px;
        }

        .subtitle {
            color: #6b7280;
            margin-bottom: 25px;
        }

        .message {
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            background: #fee2e2;
            color: #991b1b;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .orders {
            display: grid;
            gap: 20px;
        }

        .order-card {
            background: white;
            border-radius: 14px;
            padding: 22px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e5e7eb;
        }

        .order-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 18px;
            flex-wrap: wrap;
        }

        .order-id {
            font-size: 20px;
            font-weight: bold;
        }

        .status {
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
            background: #dbeafe;
            color: #1d4ed8;
        }

        .details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            margin-bottom: 20px;
        }

        .detail {
            background: #f9fafb;
            padding: 13px;
            border-radius: 8px;
        }

        .label {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 5px;
        }

        .value {
            font-weight: 600;
            word-break: break-word;
        }

        .actions {
            border-top: 1px solid #e5e7eb;
            padding-top: 18px;
        }

        .actions form {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .next-label {
            font-weight: bold;
        }

        .next-button {
            border: none;
            background: #16a34a;
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        .next-button:hover {
            background: #15803d;
        }

        .completed {
            color: #16a34a;
            font-weight: bold;
        }

        .empty {
            background: white;
            padding: 50px;
            text-align: center;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }

        @media (max-width: 700px) {

            .details {
                grid-template-columns: 1fr;
            }

            .header {
                padding: 15px;
            }

            .container {
                padding: 0 12px;
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

<header class="header">

    <div class="brand">
        ðŸ›ï¸ AuraMart Seller
    </div>

    <a
        class="back"
        href="<%= contextPath %>/seller/dashboard.html"
    >
        Dashboard
    </a>

</header>


<main class="container">

    <h1>ðŸ“¦ Seller Orders</h1>

    <p class="subtitle">
        Manage your orders and update delivery status.
    </p>


    <% if ("true".equals(request.getParameter("updated"))) { %>

        <div class="message success">
            âœ… Order status updated successfully.
        </div>

    <% } %>


    <% if (error != null) { %>

        <div class="message">
            âŒ <%= error %>
        </div>

    <% } %>


    <% if (sellerOrders == null || sellerOrders.isEmpty()) { %>

        <div class="empty">

            <h2>ðŸ“­ No Orders Yet</h2>

            <p style="margin-top:10px;color:#6b7280;">
                Orders for your products will appear here.
            </p>

        </div>

    <% } else { %>

        <div class="orders">

        <% for (SellerOrder order : sellerOrders) { %>

            <div class="order-card">

                <div class="order-top">

                    <div class="order-id">
                        Order #<%= order.getOrderId() %>
                    </div>

                    <div class="status">
                        <%= order.getStatus() %>
                    </div>

                </div>


                <div class="details">

                    <div class="detail">

                        <div class="label">
                            BUYER
                        </div>

                        <div class="value">
                            <%= order.getBuyerName() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            BUYER EMAIL
                        </div>

                        <div class="value">
                            <%= order.getBuyerEmail() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            PRODUCT
                        </div>

                        <div class="value">
                            <%= order.getProductName() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            QUANTITY
                        </div>

                        <div class="value">
                            <%= order.getQuantity() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            PRODUCT PRICE
                        </div>

                        <div class="value">
                            â‚¹<%= order.getPrice() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            ORDER TOTAL
                        </div>

                        <div class="value">
                            â‚¹<%= order.getOrderTotal() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            DELIVERY ADDRESS
                        </div>

                        <div class="value">
                            <%= order.getDeliveryAddress() %>
                        </div>

                    </div>


                    <div class="detail">

                        <div class="label">
                            ORDER DATE
                        </div>

                        <div class="value">
                            <%= order.getCreatedAt() %>
                        </div>

                    </div>

                </div>


                <div class="actions">

                <%
                    String currentStatus =
                            order.getStatus() == null
                            ? ""
                            : order.getStatus().trim().toUpperCase();

                    String nextStatus = null;

                    if ("PLACED".equals(currentStatus)) {
                        nextStatus = "CONFIRMED";
                    }
                    else if ("CONFIRMED".equals(currentStatus)) {
                        nextStatus = "PROCESSING";
                    }
                    else if ("PROCESSING".equals(currentStatus)) {
                        nextStatus = "SHIPPED";
                    }
                    else if ("SHIPPED".equals(currentStatus)) {
                        nextStatus = "OUT FOR DELIVERY";
                    }
                    else if ("OUT FOR DELIVERY".equals(currentStatus)) {
                        nextStatus = "DELIVERED";
                    }
                %>


                <% if (nextStatus != null) { %>

                    <form
                        method="post"
                        action="<%= contextPath %>/seller/orders"
                    >

                        <input
                            type="hidden"
                            name="action"
                            value="update-status"
                        >

                        <input
                            type="hidden"
                            name="orderId"
                            value="<%= order.getOrderId() %>"
                        >

                        <input
                            type="hidden"
                            name="status"
                            value="<%= nextStatus %>"
                        >

                        <span class="next-label">
                            Next:
                        </span>

                        <button
                            type="submit"
                            class="next-button"
                            onclick="return confirm('Update Order #<%= order.getOrderId() %> to <%= nextStatus %>?');"
                        >
                            Update to <%= nextStatus %>
                        </button>

                    </form>

                <% } else if ("DELIVERED".equals(currentStatus)) { %>

                    <span class="completed">
                        âœ… Order Delivered
                    </span>

                <% } %>

                </div>

            </div>

        <% } %>

        </div>

    <% } %>

</main>

</body>

</html>

