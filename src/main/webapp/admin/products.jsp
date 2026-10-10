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
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>AuraMart - Admin Product Management</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f5f7fb;
    color: #111827;
}

.header {
    background: #111827;
    color: white;
    min-height: 65px;
    padding: 0 28px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.brand {
    font-size: 23px;
    font-weight: 700;
}

.admin-title {
    font-size: 14px;
    color: #d1d5db;
}

.container {
    max-width: 1450px;
    margin: 25px auto;
    padding: 0 20px;
}

.top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
    gap: 20px;
}

.top h2 {
    margin: 0;
    font-size: 26px;
}

.top p {
    margin: 6px 0 0;
    color: #6b7280;
}

.add-btn {
    background: #16a34a;
    color: white;
    padding: 11px 18px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
    white-space: nowrap;
}

.add-btn:hover {
    background: #15803d;
}

.table-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 3px 15px rgba(0,0,0,0.07);
}

.table-wrapper {
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 1150px;
    border-collapse: collapse;
}

th {
    background: #1f2937;
    color: white;
    padding: 13px;
    text-align: left;
    font-size: 13px;
}

td {
    padding: 12px 13px;
    border-bottom: 1px solid #eef0f3;
    font-size: 14px;
    vertical-align: middle;
}

tr:hover td {
    background: #f9fafb;
}

.product-img {
    width: 58px;
    height: 58px;
    object-fit: contain;
    border-radius: 8px;
    border: 1px solid #e5e7eb;
    background: white;
}

.no-image {
    width: 58px;
    height: 58px;
    border-radius: 8px;
    background: #f3f4f6;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #9ca3af;
    font-size: 11px;
}

.product-name {
    font-weight: 700;
}

.category {
    color: #6b7280;
}

.price {
    font-weight: 700;
    color: #111827;
}

.stock {
    font-weight: 700;
}

.status {
    display: inline-block;
    padding: 5px 9px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
}

.active {
    background: #dcfce7;
    color: #15803d;
}

.inactive {
    background: #fee2e2;
    color: #b91c1c;
}

.actions {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
}

.action-btn {
    border: none;
    padding: 7px 10px;
    border-radius: 6px;
    color: white;
    font-size: 12px;
    font-weight: bold;
    cursor: pointer;
    text-decoration: none;
    display: inline-block;
}

.edit {
    background: #2563eb;
}

.edit:hover {
    background: #1d4ed8;
}

.refill {
    background: #16a34a;
}

.refill:hover {
    background: #15803d;
}

.increase {
    background: #7c3aed;
}

.increase:hover {
    background: #6d28d9;
}

.decrease {
    background: #ea580c;
}

.decrease:hover {
    background: #c2410c;
}

.delete {
    background: #dc2626;
}

.delete:hover {
    background: #b91c1c;
}

.activate {
    background: #0891b2;
}

.activate:hover {
    background: #0e7490;
}

.inline-form {
    display: inline;
}

.empty {
    text-align: center;
    padding: 60px 20px;
    color: #6b7280;
}

.empty-icon {
    font-size: 42px;
    margin-bottom: 10px;
}

@media(max-width:800px) {

    .header {
        padding: 15px;
    }

    .admin-title {
        display: none;
    }

    .container {
        padding: 0 10px;
    }

    .top {
        align-items: flex-start;
    }

    .top h2 {
        font-size: 21px;
    }

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

<header class="header">

    <div class="brand">
        AuraMart Admin
    </div>

    <div class="admin-title">
        Product Management
    </div>

</header>

<div class="container">

    <div class="top">

        <div>
            <h2>Product Management</h2>
            <p>Manage all AuraMart products without deleting database records.</p>
        </div>

        <a
            href="<%= request.getContextPath() %>/admin-add-product.jsp"
            class="add-btn">
            + Add Product
        </a>

    </div>

    <div class="table-card">

        <div class="table-wrapper">

            <table>

                <thead>

                    <tr>
                        <th>ID</th>
                        <th>Image</th>
                        <th>Product</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>

                </thead>

                <tbody>

                <%
                if (products != null && !products.isEmpty()) {

                    for (Product product : products) {

                        String image = product.getImage();
                %>

                    <tr>

                        <td>
                            <strong>#<%= product.getId() %></strong>
                        </td>

                        <td>

                            <% if (image != null && !image.trim().isEmpty()) { %>

                                <img
                                    src="<%= image %>"
                                    class="product-img"
                                    alt="<%= product.getName() %>"
                                    onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">

                                <div
                                    class="no-image"
                                    style="display:none;">
                                    No Image
                                </div>

                            <% } else { %>

                                <div class="no-image">
                                    No Image
                                </div>

                            <% } %>

                        </td>

                        <td>
                            <div class="product-name">
                                <%= product.getName() %>
                            </div>
                        </td>

                        <td>
                            <span class="category">
                                <%= product.getCategory() %>
                            </span>
                        </td>

                        <td>
                            <span class="price">
                                ₹<%= product.getPrice() %>
                            </span>
                        </td>

                        <td>
                            <span class="stock">
                                <%= product.getStock() %>
                            </span>
                        </td>

                        <td>

                            <% if (product.isActive()) { %>

                                <span class="status active">
                                    Active
                                </span>

                            <% } else { %>

                                <span class="status inactive">
                                    Inactive
                                </span>

                            <% } %>

                        </td>

                        <td>

                            <div class="actions">

                                <a
                                    href="<%= request.getContextPath() %>/admin-edit-product?id=<%= product.getId() %>"
                                    class="action-btn edit">
                                    Edit
                                </a>

                                <% if (product.isActive()) { %>

                                    <form
                                        method="post"
                                        action="<%= request.getContextPath() %>/admin/products"
                                        class="inline-form"
                                        onsubmit="return refillProduct('<%= product.getName().replace("'", "\\'") %>');">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="refill">

                                        <input
                                            type="hidden"
                                            name="id"
                                            value="<%= product.getId() %>">

                                        <input
                                            type="hidden"
                                            name="quantity"
                                            id="refill-<%= product.getId() %>">

                                        <button
                                            type="submit"
                                            class="action-btn refill">
                                            Refill
                                        </button>

                                    </form>

                                    <form
                                        method="post"
                                        action="<%= request.getContextPath() %>/admin/products"
                                        class="inline-form"
                                        onsubmit="return changePrice(<%= product.getId() %>, 'increase');">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="increasePrice">

                                        <input
                                            type="hidden"
                                            name="id"
                                            value="<%= product.getId() %>">

                                        <input
                                            type="hidden"
                                            name="amount"
                                            id="increase-<%= product.getId() %>">

                                        <button
                                            type="submit"
                                            class="action-btn increase">
                                            + Price
                                        </button>

                                    </form>

                                    <form
                                        method="post"
                                        action="<%= request.getContextPath() %>/admin/products"
                                        class="inline-form"
                                        onsubmit="return changePrice(<%= product.getId() %>, 'decrease');">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="decreasePrice">

                                        <input
                                            type="hidden"
                                            name="id"
                                            value="<%= product.getId() %>">

                                        <input
                                            type="hidden"
                                            name="amount"
                                            id="decrease-<%= product.getId() %>">

                                        <button
                                            type="submit"
                                            class="action-btn decrease">
                                            - Price
                                        </button>

                                    </form>

                                    <form
                                        method="post"
                                        action="<%= request.getContextPath() %>/admin/products"
                                        class="inline-form"
                                        onsubmit="return confirm('Deactivate this product? The database record will NOT be deleted.');">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="delete">

                                        <input
                                            type="hidden"
                                            name="id"
                                            value="<%= product.getId() %>">

                                        <button
                                            type="submit"
                                            class="action-btn delete">
                                            Delete
                                        </button>

                                    </form>

                                <% } else { %>

                                    <form
                                        method="post"
                                        action="<%= request.getContextPath() %>/admin/products"
                                        class="inline-form">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="activate">

                                        <input
                                            type="hidden"
                                            name="id"
                                            value="<%= product.getId() %>">

                                        <button
                                            type="submit"
                                            class="action-btn activate">
                                            Activate
                                        </button>

                                    </form>

                                <% } %>

                            </div>

                        </td>

                    </tr>

                <%
                    }

                } else {
                %>

                    <tr>

                        <td
                            colspan="8"
                            class="empty">

                            <div class="empty-icon">
                                📦
                            </div>

                            <strong>No products found.</strong>

                        </td>

                    </tr>

                <%
                }
                %>

                </tbody>

            </table>

        </div>

    </div>

</div>

<script>

function refillProduct(productName) {

    const quantity = prompt(
        "Enter stock quantity to add for " + productName + ":"
    );

    if (quantity === null) {
        return false;
    }

    const number = parseInt(quantity);

    if (isNaN(number) || number <= 0) {
        alert("Please enter a valid positive quantity.");
        return false;
    }

    const inputs =
        document.querySelectorAll('input[name="quantity"]');

    for (let input of inputs) {

        if (input.value === "") {
            input.value = number;
            break;
        }

    }

    return true;
}


function changePrice(id, type) {

    const amount = prompt(
        type === "increase"
            ? "Enter amount to increase:"
            : "Enter amount to decrease:"
    );

    if (amount === null) {
        return false;
    }

    const number = parseFloat(amount);

    if (isNaN(number) || number <= 0) {
        alert("Please enter a valid positive amount.");
        return false;
    }

    const input =
        document.getElementById(type + "-" + id);

    if (!input) {
        return false;
    }

    input.value = number;

    return true;
}

</script>

</body>
</html>




