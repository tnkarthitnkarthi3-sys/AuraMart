<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.auramart.model.User" %>

<%
    User sellerUser =
            (User) request.getAttribute("sellerUser");
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>AuraMart Seller Profile</title>

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

        .card {
            max-width: 650px;
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow:
                0 8px 25px rgba(0,0,0,.07);
        }

        label {
            display: block;
            margin-top: 18px;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
        }

        textarea {
            min-height: 110px;
        }

        .readonly {
            background: #f3f4f6;
        }

        button {
            margin-top: 22px;
            border: none;
            padding: 13px 22px;
            border-radius: 9px;
            background: #2563eb;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

        .success {
            background: #dcfce7;
            color: #166534;
            padding: 13px;
            border-radius: 9px;
            margin-bottom: 20px;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 13px;
            border-radius: 9px;
            margin-bottom: 20px;
        }

        .role {
            display: inline-block;
            background: #dbeafe;
            color: #1e40af;
            padding: 7px 12px;
            border-radius: 20px;
            font-weight: bold;
        }

    </style>

<style>

/* ===== AURAMART PREMIUM MANAGEMENT UI ===== */

body{
    background:
        radial-gradient(circle at 10% 10%,rgba(124,58,237,.23),transparent 28%),
        radial-gradient(circle at 90% 15%,rgba(37,99,235,.20),transparent 28%),
        radial-gradient(circle at 50% 100%,rgba(168,85,247,.15),transparent 35%),
        linear-gradient(135deg,#020617,#0b1024 48%,#111827)!important;
    color:#f8fafc!important;
}

body:before{
    content:"";
    position:fixed;
    inset:-100px;
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
}

.header,
.navbar,
.sidebar{
    background:rgba(2,6,23,.78)!important;
    border-color:rgba(255,255,255,.10)!important;
    box-shadow:0 15px 50px rgba(0,0,0,.28)!important;
    backdrop-filter:blur(24px)!important;
    -webkit-backdrop-filter:blur(24px)!important;
}

.brand,
.logo{
    color:#fff!important;
    font-weight:900!important;
    letter-spacing:-.8px;
    text-shadow:0 0 25px rgba(139,92,246,.35);
}

.container,
.main,
.content,
.page{
    position:relative;
}

h1,h2,h3{
    color:transparent!important;
    background:linear-gradient(90deg,#fff,#c4b5fd,#93c5fd);
    -webkit-background-clip:text;
    background-clip:text;
    font-weight:900!important;
}

.card,
.form-card,
.product-card,
.order-card,
.panel,
.box,
.container-box,
.content-box{
    background:
        linear-gradient(
            145deg,
            rgba(255,255,255,.105),
            rgba(255,255,255,.035)
        )!important;
    border:1px solid rgba(255,255,255,.10)!important;
    border-radius:22px!important;
    box-shadow:
        0 25px 70px rgba(0,0,0,.35),
        inset 0 1px 0 rgba(255,255,255,.07)!important;
    backdrop-filter:blur(25px)!important;
    -webkit-backdrop-filter:blur(25px)!important;
}

label{
    color:#cbd5e1!important;
    font-weight:700!important;
}

input,
select,
textarea{
    background:rgba(2,6,23,.68)!important;
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
    box-shadow:0 0 0 3px rgba(139,92,246,.13)!important;
}

button,
.btn,
.button,
a.btn,
input[type="submit"]{
    border:0!important;
    border-radius:13px!important;
    background:linear-gradient(135deg,#7c3aed,#2563eb)!important;
    color:#fff!important;
    font-weight:800!important;
    box-shadow:0 12px 30px rgba(99,102,241,.22)!important;
    transition:.28s ease!important;
}

button:hover,
.btn:hover,
.button:hover,
a.btn:hover,
input[type="submit"]:hover{
    transform:translateY(-3px)!important;
    box-shadow:0 18px 40px rgba(124,58,237,.32)!important;
}

table{
    color:#e2e8f0!important;
    border-collapse:separate!important;
    border-spacing:0 7px!important;
}

thead th{
    color:#94a3b8!important;
    background:rgba(255,255,255,.035)!important;
    padding:14px!important;
}

tbody tr{
    background:rgba(255,255,255,.035)!important;
    transition:.25s ease!important;
}

tbody tr:hover{
    background:rgba(124,58,237,.10)!important;
}

tbody td{
    color:#cbd5e1!important;
    padding:14px!important;
    border-bottom:1px solid rgba(255,255,255,.05)!important;
}

.price,
.amount,
.total{
    color:#c4b5fd!important;
    font-weight:900!important;
}

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

a{
    color:#a78bfa;
}

a:hover{
    color:#c4b5fd;
}

img{
    border-radius:16px;
}

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

@media(max-width:800px){

    .main{
        margin-left:0!important;
        padding:20px!important;
    }

    .container{
        width:94%!important;
        padding:15px!important;
    }

    .card,
    .form-card,
    .product-card,
    .order-card{
        border-radius:18px!important;
    }

    table{
        min-width:700px;
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

        <a href="products">
            📦 My Products
        </a>

        <a
            class="active"
            href="profile"
        >
            👤 Profile
        </a>

        <a href="../logout">
            🚪 Logout
        </a>

    </nav>

</aside>


<main class="main">

    <h1>
        Seller Profile
    </h1>

    <p>
        Manage your seller account information.
    </p>


    <%
        if ("true".equals(
                request.getParameter("success"))) {
    %>

        <div class="success">
            Profile updated successfully.
        </div>

    <%
        }

        if ("true".equals(
                request.getParameter("error"))) {
    %>

        <div class="error">
            Unable to update profile.
        </div>

    <%
        }
    %>


    <div class="card">

        <form
            method="post"
            action="<%= request.getContextPath() %>/seller/profile"
        >

            <label>
                Name
            </label>

            <input
                type="text"
                name="name"
                value="<%= sellerUser.getName() == null ? "" : sellerUser.getName() %>"
                required
            >


            <label>
                Email
            </label>

            <input
                class="readonly"
                type="email"
                value="<%= sellerUser.getEmail() %>"
                readonly
            >


            <label>
                Role
            </label>

            <div class="role">
                <%= sellerUser.getRole() %>
            </div>


            <label>
                Phone
            </label>

            <input
                type="text"
                name="phone"
                value="<%= sellerUser.getPhone() == null ? "" : sellerUser.getPhone() %>"
            >


            <label>
                Address
            </label>

            <textarea
                name="address"
            ><%= sellerUser.getAddress() == null ? "" : sellerUser.getAddress() %></textarea>


            <button type="submit">
                Save Profile
            </button>

        </form>

    </div>

</main>

</body>

</html>

