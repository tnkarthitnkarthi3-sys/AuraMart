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
