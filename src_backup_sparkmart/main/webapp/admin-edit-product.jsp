<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.auramart.Product" %>

<%
    Product product = (Product) request.getAttribute("product");

    if (product == null) {
        response.sendRedirect("admin-products");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AuraMart - Edit Product</title>

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
            background: #2563eb;
            color: white;
        }

        .back-btn {
            background: #6b7280;
            color: white;
        }
    </style>
</head>

<body>

<div class="header">
    <h1>AuraMart</h1>
</div>

<div class="container">

    <h2>âœï¸ Edit Product</h2>
    <p>Update the selected AuraMart product.</p>

    <form action="admin-edit-product" method="post" enctype="multipart/form-data">

        <input
            type="hidden"
            name="id"
            value="<%= product.getId() %>">

        <div class="form-group">
            <label>Product Name</label>
            <input
                type="text"
                name="name"
                value="<%= product.getName() %>"
                required>
        </div>

        <div class="form-group">
            <label>Category</label>

            <select name="category" required>

                <option value="Mobiles"
                    <%= "Mobiles".equals(product.getCategory()) ? "selected" : "" %>>
                    Mobiles
                </option>

                <option value="Laptops"
                    <%= "Laptops".equals(product.getCategory()) ? "selected" : "" %>>
                    Laptops
                </option>

                <option value="Headphones"
                    <%= "Headphones".equals(product.getCategory()) ? "selected" : "" %>>
                    Headphones
                </option>

                <option value="Smart Watches"
                    <%= "Smart Watches".equals(product.getCategory()) ? "selected" : "" %>>
                    Smart Watches
                </option>

                <option value="Cameras"
                    <%= "Cameras".equals(product.getCategory()) ? "selected" : "" %>>
                    Cameras
                </option>

                <option value="Gaming"
                    <%= "Gaming".equals(product.getCategory()) ? "selected" : "" %>>
                    Gaming
                </option>

                <option value="Accessories"
                    <%= "Accessories".equals(product.getCategory()) ? "selected" : "" %>>
                    Accessories
                </option>

                <option value="Home Appliances"
                    <%= "Home Appliances".equals(product.getCategory()) ? "selected" : "" %>>
                    Home Appliances
                </option>

                <option value="Fashion"
                    <%= "Fashion".equals(product.getCategory()) ? "selected" : "" %>>
                    Fashion
                </option>

                <option value="Beauty"
                    <%= "Beauty".equals(product.getCategory()) ? "selected" : "" %>>
                    Beauty
                </option>

            </select>
        </div>

        <div class="form-group">
            <label>Description</label>

            <textarea name="description"><%= product.getDescription() == null ? "" : product.getDescription() %></textarea>
        </div>

        <div class="row">

            <div class="form-group">
                <label>Price (â‚¹)</label>

                <input
                    type="number"
                    name="price"
                    step="0.01"
                    min="0"
                    value="<%= product.getPrice() %>"
                    required>
            </div>

            <div class="form-group">
                <label>Stock</label>

                <input
                    type="number"
                    name="stock"
                    min="0"
                    value="<%= product.getStock() %>"
                    required>
            </div>

        </div>

        <div class="form-group">
            <label>Current Image</label>

            <input
                type="hidden"
                name="currentImage"
                value="<%= product.getImage() == null ? "" : product.getImage() %>">

            <% if (product.getImage() != null && !product.getImage().trim().isEmpty()) { %>
                <img
                    src="<%= request.getContextPath() + "/" + product.getImage() %>"
                    id="imagePreview"
                    style="width:180px;height:180px;object-fit:contain;border:1px solid #ddd;border-radius:10px;margin-bottom:10px;">
            <% } else { %>
                <img
                    id="imagePreview"
                    style="display:none;width:180px;height:180px;object-fit:contain;border:1px solid #ddd;border-radius:10px;margin-bottom:10px;">
            <% } %>

            <label>Change Product Image</label>

            <input
                type="file"
                name="imageFile"
                id="imageFile"
                accept=".jpg,.jpeg,.png,.webp">

            <small>
                JPG, JPEG, PNG or WEBP — Maximum 5 MB
            </small>
        </div>

        <div class="form-group">

            <label>
                <input
                    type="checkbox"
                    name="active"
                    value="true"
                    <%= product.isActive() ? "checked" : "" %>
                    style="width:auto;">
                Active Product
            </label>

        </div>

        <div class="actions">

            <button type="submit">
                Update Product
            </button>

            <a href="admin-products" class="back-btn">
                Cancel
            </a>

        </div>

    </form>

</div>

<script>
document.getElementById("imageFile").addEventListener("change", function () {

    const file = this.files[0];

    if (!file) {
        return;
    }

    const preview = document.getElementById("imagePreview");

    preview.src = URL.createObjectURL(file);
    preview.style.display = "block";
});
</script>
</body>
</html>



