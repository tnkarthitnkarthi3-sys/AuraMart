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

```
<title>AuraMart - Product Management</title>

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

    /* HEADER */
    .header {
        background: #111827;
        color: white;
        height: 65px;
        padding: 0 28px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .brand {
        font-size: 22px;
        font-weight: 700;
    }

    .admin-title {
        font-size: 14px;
        color: #d1d5db;
    }

    /* MAIN */
    .container {
        max-width: 1250px;
        margin: 25px auto;
        padding: 0 20px;
    }

    .top {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 20px;
    }

    .top h2 {
        margin: 0;
        font-size: 25px;
    }

    .top p {
        margin: 5px 0 0;
        color: #6b7280;
        font-size: 14px;
    }

    .add-btn {
        background: #16a34a;
        color: white;
        padding: 11px 18px;
        border-radius: 8px;
        text-decoration: none;
        font-size: 14px;
        font-weight: bold;
    }

    .add-btn:hover {
        background: #15803d;
    }

    /* CARD */
    .table-card {
        background: white;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 3px 15px rgba(0,0,0,0.07);
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th {
        background: #1f2937;
        color: white;
        padding: 12px 14px;
        text-align: left;
        font-size: 13px;
    }

    td {
        padding: 11px 14px;
        border-bottom: 1px solid #eef0f3;
        font-size: 14px;
        vertical-align: middle;
    }

    tr:last-child td {
        border-bottom: none;
    }

    tr:hover td {
        background: #f9fafb;
    }

    /* IMAGE */
    .product-img {
        width: 55px;
        height: 55px;
        object-fit: contain;
        border-radius: 8px;
        border: 1px solid #e5e7eb;
        background: white;
    }

    .no-image {
        width: 55px;
        height: 55px;
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
        color: #111827;
    }

    .category {
        color: #6b7280;
    }

    .price {
        font-weight: 700;
    }

    /* STATUS */
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

    /* ACTION */
    .edit-btn {
        display: inline-block;
        background: #2563eb;
        color: white;
        padding: 7px 12px;
        border-radius: 6px;
        text-decoration: none;
        font-size: 12px;
        font-weight: bold;
    }

    .edit-btn:hover {
        background: #1d4ed8;
    }

    /* EMPTY */
    .empty {
        text-align: center;
        padding: 50px 20px;
        color: #6b7280;
    }

    .empty-icon {
        font-size: 40px;
        margin-bottom: 10px;
    }

    /* MOBILE */
    @media (max-width: 800px) {

        .header {
            padding: 0 15px;
        }

        .admin-title {
            display: none;
        }

        .container {
            padding: 0 10px;
            margin-top: 15px;
        }

        .top {
            align-items: flex-start;
            gap: 12px;
        }

        .top h2 {
            font-size: 21px;
        }

        .add-btn {
            padding: 9px 12px;
            white-space: nowrap;
        }

        .table-card {
            overflow-x: auto;
        }

        table {
            min-width: 850px;
        }
    }
</style>
```

</head>

<body>

<!-- HEADER -->

<div class="header">

```
<div class="brand">
    AuraMart
</div>

<div class="admin-title">
    Admin Product Management
</div>
```

</div>

<!-- MAIN -->

<div class="container">

```
<div class="top">

    <div>
        <h2>Products</h2>
        <p>Manage all AuraMart products</p>
    </div>

    <a href="admin-add-product.jsp" class="add-btn">
        + Add Product
    </a>

</div>


<div class="table-card">

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
                <th>Action</th>
            </tr>
        </thead>

        <tbody>

        <%
            if (products != null && !products.isEmpty()) {

                for (Product product : products) {

                    String image = product.getImage();
        %>

            <tr>

                <!-- ID -->
                <td>
                    <strong>#<%= product.getId() %></strong>
                </td>


                <!-- IMAGE -->
                <td>

                    <%
                        if (image != null && !image.trim().isEmpty()) {
                    %>

                        <img
                            src="<%= image %>"
                            class="product-img"
                            alt="<%= product.getName() %>"
                            onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">

                        <div class="no-image" style="display:none;">
                            No Image
                        </div>

                    <%
                        } else {
                    %>

                        <div class="no-image">
                            No Image
                        </div>

                    <%
                        }
                    %>

                </td>


                <!-- PRODUCT -->
                <td>
                    <div class="product-name">
                        <%= product.getName() %>
                    </div>
                </td>


                <!-- CATEGORY -->
                <td>
                    <span class="category">
                        <%= product.getCategory() %>
                    </span>
                </td>


                <!-- PRICE -->
                <td>
                    <span class="price">
                        ₹<%= product.getPrice() %>
                    </span>
                </td>


                <!-- STOCK -->
                <td>
                    <%= product.getStock() %>
                </td>


                <!-- STATUS -->
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


                <!-- ACTION -->
                <td>

                    <a
                        href="<%= request.getContextPath() %>/admin-edit-product?id=<%= product.getId() %>"
                        class="edit-btn">

                        Edit

                    </a>

                </td>

            </tr>

        <%
                }

            } else {
        %>

            <tr>

                <td colspan="8" class="empty">

                    <div class="empty-icon">
                        📦
                    </div>

                    <strong>No products found.</strong>

                    <br>

                    <span>
                        Add your first product using the button above.
                    </span>

                </td>

            </tr>

        <%
            }
        %>

        </tbody>

    </table>

</div>
```

</div>

</body>
</html>

