<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AuraMart - Add Product</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f4f6;
        }

        .header {
            background: #111827;
            color: white;
            padding: 20px 35px;
        }

        .header h1 {
            margin: 0;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            background: white;
            padding: 35px;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.10);
        }

        h2 {
            margin-top: 0;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 7px;
        }

        input,
        textarea,
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 15px;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        .row {
            display: flex;
            gap: 20px;
        }

        .row .form-group {
            flex: 1;
        }

        .actions {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }

        button,
        .back-btn {
            padding: 12px 22px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
        }

        button {
            background: #16a34a;
            color: white;
        }

        .back-btn {
            background: #6b7280;
            color: white;
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

<div class="header">
    <h1>AuraMart</h1>
</div>

<div class="container">

    <h2>➕ Add New Product</h2>
    <p>Add a new product to your AuraMart store.</p>

    <form action="admin-add-product" method="post">

        <div class="form-group">
            <label>Product Name</label>
            <input
                type="text"
                name="name"
                placeholder="Enter product name"
                required>
        </div>

        <div class="form-group">
            <label>Category</label>
            <select name="category" required>
                <option value="">Select Category</option>
                <option value="Mobiles">Mobiles</option>
                <option value="Laptops">Laptops</option>
                <option value="Headphones">Headphones</option>
                <option value="Smart Watches">Smart Watches</option>
                <option value="Cameras">Cameras</option>
                <option value="Gaming">Gaming</option>
                <option value="Accessories">Accessories</option>
                <option value="Home Appliances">Home Appliances</option>
                <option value="Fashion">Fashion</option>
                <option value="Beauty">Beauty</option>
            </select>
        </div>

        <div class="form-group">
            <label>Description</label>
            <textarea
                name="description"
                placeholder="Enter product description"></textarea>
        </div>

        <div class="row">

            <div class="form-group">
                <label>Price (₹)</label>
                <input
                    type="number"
                    name="price"
                    step="0.01"
                    min="0"
                    placeholder="Enter price"
                    required>
            </div>

            <div class="form-group">
                <label>Stock</label>
                <input
                    type="number"
                    name="stock"
                    min="0"
                    placeholder="Enter stock"
                    required>
            </div>

        </div>

        <div class="form-group">
            <label>Image Path / URL</label>
            <input
                type="text"
                name="image"
                placeholder="images/product.jpg">
        </div>

        <div class="form-group">
            <label>
                <input
                    type="checkbox"
                    name="active"
                    value="true"
                    checked
                    style="width:auto;">
                Active Product
            </label>
        </div>

        <div class="actions">
            <button type="submit">Add Product</button>

            <a href="admin-products" class="back-btn">
                Back to Products
            </a>
        </div>

    </form>

</div>

</body>
</html>




