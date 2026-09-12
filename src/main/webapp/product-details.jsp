<%@ page import="com.auramart.dao.ProductDAO" %>
<%@ page import="com.auramart.model.Product" %>

<%
    String idParam = request.getParameter("id");
    Product product = null;

    try {
        if (idParam != null && !idParam.trim().isEmpty()) {
            int productId = Integer.parseInt(idParam);
            ProductDAO dao = new ProductDAO();
            product = dao.getProductById(productId);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (product == null) {
        response.sendRedirect("products.jsp");
        return;
    }

    String productId = String.valueOf(product.getId());
    String productName = product.getName() == null ? "AuraMart Product" : product.getName();
    String category = product.getCategory() == null ? "Product" : product.getCategory();
    String description = product.getDescription() == null
            ? "Quality product from AuraMart."
            : product.getDescription();

    double price = product.getPrice();
    int stock = product.getStock();
    double rating = product.getRating();

    String originalImage = product.getImage();

    if (originalImage == null || originalImage.trim().isEmpty()) {
        originalImage =
            "https://dummyimage.com/800x800/f3f4f6/111827&text=AuraMart";
    } else if (!(originalImage.startsWith("http://")
            || originalImage.startsWith("https://")
            || originalImage.startsWith("/"))) {

        if (!originalImage.startsWith("images/")) {
            originalImage = "images/" + originalImage;
        }
    }

    String safeName = productName
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\r", "")
            .replace("\n", " ");
%>

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><%= productName %> | AuraMart</title>

    <style>

        *{
            box-sizing:border-box;
            margin:0;
            padding:0;
        }

        body{
            font-family:Inter,Arial,Helvetica,sans-serif;
            background:
                radial-gradient(circle at top left,#eef2ff,transparent 28%),
                radial-gradient(circle at bottom right,#fce7f3,transparent 25%),
                #f8fafc;
            color:#172033;
            min-height:100vh;
        }

        .topbar{
            position:sticky;
            top:0;
            z-index:1000;
            padding:15px 5%;
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:20px;
            background:linear-gradient(135deg,#111827,#312e81);
            color:white;
        }

        .brand{
            font-size:26px;
            font-weight:900;
            white-space:nowrap;
        }

        .brand span{
            color:#facc15;
        }

        .nav{
            display:flex;
            gap:10px;
            align-items:center;
        }

        .nav a{
            color:white;
            text-decoration:none;
            padding:9px 13px;
            border-radius:10px;
            font-size:14px;
            font-weight:800;
            transition:.2s;
        }

        .nav a:hover{
            background:rgba(255,255,255,.12);
        }

        .page{
            max-width:1250px;
            margin:35px auto 70px;
            padding:0 5%;
        }

        .breadcrumb{
            color:#64748b;
            font-size:13px;
            margin-bottom:18px;
        }

        .breadcrumb a{
            color:#4f46e5;
            text-decoration:none;
            font-weight:700;
        }

        .product-container{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:35px;
            background:rgba(255,255,255,.90);
            border:1px solid #e5e7eb;
            border-radius:25px;
            box-shadow:0 20px 60px rgba(15,23,42,.09);
            padding:28px;
            backdrop-filter:blur(8px);
        }

        .gallery{
            min-width:0;
        }

        .main-image-box{
            position:relative;
            min-height:550px;
            border-radius:22px;
            background:
                radial-gradient(circle at 30% 20%,#eef2ff,transparent 35%),
                linear-gradient(135deg,#f8fafc,#eef2ff);
            display:flex;
            align-items:center;
            justify-content:center;
            padding:28px;
            overflow:hidden;
        }

        .main-image-box img{
            width:100%;
            height:490px;
            object-fit:contain;
            transition:
                transform .35s ease,
                opacity .25s ease;
        }

        .main-image-box:hover img{
            transform:scale(1.035);
        }

        .zoom-label{
            position:absolute;
            left:16px;
            bottom:15px;
            background:rgba(17,24,39,.78);
            color:white;
            padding:7px 10px;
            border-radius:999px;
            font-size:11px;
            font-weight:800;
        }

        .thumbs{
            display:flex;
            flex-wrap:wrap;
            gap:10px;
            margin-top:15px;
        }

        .thumb{
            width:70px;
            height:70px;
            padding:5px;
            border:2px solid #e2e8f0;
            background:white;
            border-radius:13px;
            cursor:pointer;
            transition:.2s;
        }

        .thumb:hover{
            transform:translateY(-2px);
            border-color:#6366f1;
        }

        .thumb.active{
            border-color:#4f46e5;
            box-shadow:0 0 0 3px rgba(79,70,229,.13);
        }

        .thumb img{
            width:100%;
            height:100%;
            object-fit:contain;
            border-radius:9px;
        }

        .details{
            padding:8px 5px;
            display:flex;
            flex-direction:column;
            justify-content:center;
        }

        .category{
            display:inline-flex;
            width:max-content;
            background:#eef2ff;
            color:#4338ca;
            border-radius:999px;
            padding:7px 11px;
            font-size:11px;
            font-weight:900;
            text-transform:uppercase;
            letter-spacing:.6px;
            margin-bottom:14px;
        }

        .title{
            font-size:clamp(28px,4vw,43px);
            line-height:1.08;
            font-weight:950;
            color:#111827;
            margin-bottom:13px;
        }

        .rating-row{
            display:flex;
            align-items:center;
            gap:12px;
            flex-wrap:wrap;
            margin-bottom:18px;
        }

        .rating{
            background:#fef3c7;
            color:#92400e;
            padding:7px 10px;
            border-radius:9px;
            font-size:13px;
            font-weight:900;
        }

        .stock{
            padding:7px 10px;
            border-radius:9px;
            font-size:13px;
            font-weight:900;
        }

        .stock.ok{
            background:#dcfce7;
            color:#166534;
        }

        .stock.out{
            background:#fee2e2;
            color:#991b1b;
        }

        .description{
            color:#64748b;
            font-size:15px;
            line-height:1.7;
            margin-bottom:22px;
        }

        .price{
            font-size:38px;
            font-weight:950;
            color:#111827;
        }

        .price-note{
            color:#64748b;
            font-size:12px;
            margin-top:3px;
            margin-bottom:23px;
        }

        .section-title{
            font-size:15px;
            font-weight:900;
            margin-bottom:11px;
        }

        .color-section{
            margin-bottom:21px;
        }

        .color-options{
            display:flex;
            flex-wrap:wrap;
            gap:12px;
        }

        .color-option{
            display:flex;
            align-items:center;
            gap:8px;
            padding:7px 10px 7px 7px;
            border:2px solid #e2e8f0;
            border-radius:12px;
            background:#fff;
            cursor:pointer;
            transition:.2s;
            font-size:12px;
            font-weight:850;
        }

        .color-option:hover{
            transform:translateY(-1px);
            border-color:#94a3b8;
        }

        .color-option.active{
            border-color:#4f46e5;
            background:#eef2ff;
            color:#4338ca;
            box-shadow:0 5px 17px rgba(79,70,229,.13);
        }

        .swatch{
            width:25px;
            height:25px;
            border-radius:50%;
            display:inline-block;
            border:2px solid #cbd5e1;
            box-shadow:inset 0 0 0 1px rgba(0,0,0,.05);
        }

        .swatch.black{
            background:#111827;
        }

        .swatch.white{
            background:#fff;
        }

        .swatch.blue{
            background:#2563eb;
        }

        .swatch.red{
            background:#dc2626;
        }

        .swatch.green{
            background:#16a34a;
        }

        .swatch.silver{
            background:#cbd5e1;
        }

        .selected-color{
            margin-top:9px;
            color:#475569;
            font-size:12px;
        }

        .quantity-row{
            display:flex;
            align-items:center;
            gap:14px;
            margin-bottom:19px;
        }

        .qty{
            display:flex;
            align-items:center;
            border:1px solid #dbe3ee;
            border-radius:12px;
            overflow:hidden;
            background:white;
        }

        .qty button{
            width:38px;
            height:38px;
            border:none;
            background:#f8fafc;
            cursor:pointer;
            font-size:18px;
            font-weight:900;
        }

        .qty input{
            width:48px;
            height:38px;
            border:none;
            border-left:1px solid #e2e8f0;
            border-right:1px solid #e2e8f0;
            outline:none;
            text-align:center;
            font-weight:900;
        }

        .actions{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:11px;
        }

        .btn{
            border:none;
            border-radius:13px;
            padding:14px;
            cursor:pointer;
            font-size:14px;
            font-weight:900;
            transition:.2s;
        }

        .btn:hover{
            transform:translateY(-2px);
        }

        .btn-cart{
            background:#eef2ff;
            color:#4338ca;
        }

        .btn-buy{
            background:linear-gradient(135deg,#111827,#312e81);
            color:white;
            box-shadow:0 10px 25px rgba(49,46,129,.20);
        }

        .btn:disabled{
            cursor:not-allowed;
            opacity:.55;
            transform:none;
        }

        .features{
            display:grid;
            grid-template-columns:repeat(3,1fr);
            gap:10px;
            margin-top:20px;
        }

        .feature{
            background:#f8fafc;
            border:1px solid #e2e8f0;
            border-radius:13px;
            padding:12px;
            text-align:center;
            font-size:11px;
            font-weight:800;
            color:#475569;
        }

        .toast{
            position:fixed;
            left:50%;
            bottom:28px;
            transform:translate(-50%,120px);
            background:#111827;
            color:white;
            padding:13px 18px;
            border-radius:12px;
            box-shadow:0 15px 35px rgba(15,23,42,.23);
            font-size:13px;
            font-weight:800;
            z-index:9999;
            transition:.3s;
        }

        .toast.show{
            transform:translate(-50%,0);
        }

        @media(max-width:900px){

            .product-container{
                grid-template-columns:1fr;
            }

            .main-image-box{
                min-height:430px;
            }

            .main-image-box img{
                height:380px;
            }

        }

        @media(max-width:600px){

            .topbar{
                flex-direction:column;
                align-items:flex-start;
            }

            .nav{
                width:100%;
                overflow:auto;
            }

            .product-container{
                padding:17px;
            }

            .main-image-box{
                min-height:350px;
            }

            .main-image-box img{
                height:310px;
            }

            .actions{
                grid-template-columns:1fr;
            }

            .features{
                grid-template-columns:1fr;
            }

        }

    </style>

</head>

<body>

<header class="topbar">

    <div class="brand">
        Aura<span>Mart</span>
    </div>

    <nav class="nav">
        <a href="products.jsp">Products</a>
        <a href="cart.html">Cart</a>
        <a href="orders.html">Orders</a>
        <a href="login.html">Login</a>
    </nav>

</header>

<main class="page">

    <div class="breadcrumb">
        <a href="products.jsp">Products</a>
        &nbsp; / &nbsp;
        <%= category %>
        &nbsp; / &nbsp;
        <%= productName %>
    </div>

    <section class="product-container">

        <div class="gallery">

            <div class="main-image-box">

                <img
                    id="mainProductImage"
                    src="<%= originalImage %>"
                    alt="<%= productName %>"
                    onerror="imageFallback(this)"
                >

                <div class="zoom-label">
                    PRODUCT PREVIEW
                </div>

            </div>

            <div class="thumbs">

                <button
                    class="thumb active"
                    id="thumbOriginal"
                    onclick="selectImage('<%= originalImage.replace("'", "\\'") %>', this)"
                >
                    <img
                        src="<%= originalImage %>"
                        alt="Original"
                        onerror="imageFallback(this)"
                    >
                </button>

                <button
                    class="thumb"
                    onclick="tryColorImage('black', this)"
                >
                    <img
                        src="images/product-<%= productId %>-black.jpg"
                        alt="Black"
                        onerror="imageFallback(this)"
                    >
                </button>

                <button
                    class="thumb"
                    onclick="tryColorImage('white', this)"
                >
                    <img
                        src="images/product-<%= productId %>-white.jpg"
                        alt="White"
                        onerror="imageFallback(this)"
                    >
                </button>

                <button
                    class="thumb"
                    onclick="tryColorImage('blue', this)"
                >
                    <img
                        src="images/product-<%= productId %>-blue.jpg"
                        alt="Blue"
                        onerror="imageFallback(this)"
                    >
                </button>

            </div>

        </div>

        <div class="details">

            <div class="category">
                <%= category %>
            </div>

            <h1 class="title">
                <%= productName %>
            </h1>

            <div class="rating-row">

                <div class="rating">
                    ⭐ <%= rating > 0
                        ? String.format("%.1f", rating)
                        : "New" %>
                </div>

                <div class="stock <%= stock > 0 ? "ok" : "out" %>">
                    <%= stock > 0
                        ? stock + " in stock"
                        : "Out of stock" %>
                </div>

            </div>

            <div class="description">
                <%= description %>
            </div>

            <div class="price">
                ₹<%= String.format("%,.0f", price) %>
            </div>

            <div class="price-note">
                Inclusive of applicable charges
            </div>

            <div class="color-section">

                <div class="section-title">
                    Choose Colour
                </div>

                <div class="color-options">

                    <button
                        class="color-option active"
                        data-color="Black"
                        onclick="selectColor('Black', this)"
                    >
                        <span class="swatch black"></span>
                        Black
                    </button>

                    <button
                        class="color-option"
                        data-color="White"
                        onclick="selectColor('White', this)"
                    >
                        <span class="swatch white"></span>
                        White
                    </button>

                    <button
                        class="color-option"
                        data-color="Blue"
                        onclick="selectColor('Blue', this)"
                    >
                        <span class="swatch blue"></span>
                        Blue
                    </button>

                    <button
                        class="color-option"
                        data-color="Red"
                        onclick="selectColor('Red', this)"
                    >
                        <span class="swatch red"></span>
                        Red
                    </button>

                    <button
                        class="color-option"
                        data-color="Green"
                        onclick="selectColor('Green', this)"
                    >
                        <span class="swatch green"></span>
                        Green
                    </button>

                    <button
                        class="color-option"
                        data-color="Silver"
                        onclick="selectColor('Silver', this)"
                    >
                        <span class="swatch silver"></span>
                        Silver
                    </button>

                </div>

                <div class="selected-color">
                    Selected colour:
                    <strong id="selectedColor">Black</strong>
                </div>

            </div>

            <div class="quantity-row">

                <div class="section-title">
                    Quantity
                </div>

                <div class="qty">

                    <button onclick="changeQty(-1)">−</button>

                    <input
                        id="qty"
                        type="number"
                        value="1"
                        min="1"
                        max="<%= Math.max(stock,1) %>"
                        readonly
                    >

                    <button onclick="changeQty(1)">+</button>

                </div>

            </div>

            <div class="actions">

                <button
                    class="btn btn-cart"
                    onclick="addToCart()"
                    <%= stock <= 0 ? "disabled" : "" %>
                >
                    🛒 Add to Cart
                </button>

                <button
                    class="btn btn-buy"
                    onclick="buyNow()"
                    <%= stock <= 0 ? "disabled" : "" %>
                >
                    Buy Now
                </button>

            </div>

            <div class="features">

                <div class="feature">
                    🚚 Fast Delivery
                </div>

                <div class="feature">
                    🔒 Secure Checkout
                </div>

                <div class="feature">
                    ↩ Easy Returns
                </div>

            </div>

        </div>

    </section>

</main>

<div class="toast" id="toast">
    Added to cart
</div>

<script>

const PRODUCT = {

    id: "<%= productId %>",

    name: "<%= safeName %>",

    price: <%= price %>,

    image: "<%= originalImage.replace("\\","\\\\").replace("\"","\\\"").replace("\r","").replace("\n","") %>",

    category: "<%= category.replace("\\","\\\\").replace("\"","\\\"").replace("\r","").replace("\n","") %>",

    stock: <%= stock %>,

    colour: "Black"

};

const COLOUR_IMAGES = {

    Black:
        "images/product-" + PRODUCT.id + "-black.jpg",

    White:
        "images/product-" + PRODUCT.id + "-white.jpg",

    Blue:
        "images/product-" + PRODUCT.id + "-blue.jpg",

    Red:
        "images/product-" + PRODUCT.id + "-red.jpg",

    Green:
        "images/product-" + PRODUCT.id + "-green.jpg",

    Silver:
        "images/product-" + PRODUCT.id + "-silver.jpg"

};

function imageFallback(img){

    if(img.dataset.fallbackDone === "1"){
        return;
    }

    img.dataset.fallbackDone = "1";

    img.src =
        "https://dummyimage.com/800x800/f3f4f6/111827&text=AuraMart";

}

function selectImage(url, button){

    const image =
        document.getElementById("mainProductImage");

    image.style.opacity = "0.35";

    setTimeout(function(){

        image.src = url;

        image.onload = function(){

            image.style.opacity = "1";

        };

        image.onerror = function(){

            image.style.opacity = "1";

            imageFallback(image);

        };

    },120);

    document.querySelectorAll(".thumb")
        .forEach(function(item){

            item.classList.remove("active");

        });

    if(button){
        button.classList.add("active");
    }

}

function tryColorImage(color, button){

    const url = COLOUR_IMAGES[color];

    const testImage =
        new Image();

    testImage.onload = function(){

        selectImage(url,button);

    };

    testImage.onerror = function(){

        // Colour-specific image not available.
        // Keep original image and show selected colour.
        selectImage(PRODUCT.image,button);

        showToast(
            color +
            " colour selected. Add its colour image as " +
            "product-" + PRODUCT.id + "-" +
            color.toLowerCase() + ".jpg"
        );

    };

    testImage.src = url;

}

window.selectColor = function(color, button){

    PRODUCT.colour = color;

    document.getElementById("selectedColor")
        .textContent = color;

    document.querySelectorAll(".color-option")
        .forEach(function(item){

            item.classList.remove("active");

        });

    button.classList.add("active");

    tryColorImage(color,null);

};

function changeQty(change){

    const input =
        document.getElementById("qty");

    let value =
        Number(input.value || 1);

    value += change;

    if(value < 1){
        value = 1;
    }

    if(PRODUCT.stock > 0 && value > PRODUCT.stock){
        value = PRODUCT.stock;
    }

    input.value = value;

}

function getCart(){

    try{

        return JSON.parse(
            localStorage.getItem("auraMartCart") || "[]"
        );

    }catch(e){

        return [];

    }

}

function saveCart(cart){

    localStorage.setItem(
        "auraMartCart",
        JSON.stringify(cart)
    );

}

function addToCart(){

    if(PRODUCT.stock <= 0){
        showToast("Product is out of stock.");
        return;
    }

    const quantity =
        Number(document.getElementById("qty").value || 1);

    if(quantity < 1){
        showToast("Please select a valid quantity.");
        return;
    }

    const cart = getCart();

    const existing = cart.find(function(item){
        return String(item.id) === String(PRODUCT.id);
    });

    if(existing){

        existing.quantity =
            Number(existing.quantity || 0) + quantity;

    }else{

        cart.push({

            id: PRODUCT.id,
            name: PRODUCT.name,
            price: Number(PRODUCT.price) || 0,
            image: PRODUCT.image,
            category: PRODUCT.category,
            colour: PRODUCT.colour,
            quantity: quantity

        });

    }

    saveCart(cart);

    showToast("Product added to cart!");

    setTimeout(function(){

        window.location.href = "cart.html";

    }, 800);
}


function buyNow(){

    if(PRODUCT.stock <= 0){
        showToast("Product is out of stock.");
        return;
    }

    const quantity =
        Number(document.getElementById("qty").value || 1);

    if(quantity < 1){
        showToast("Please select a valid quantity.");
        return;
    }

    saveCart([{

        id: PRODUCT.id,
        name: PRODUCT.name,
        price: Number(PRODUCT.price) || 0,
        image: PRODUCT.image,
        category: PRODUCT.category,
        colour: PRODUCT.colour,
        quantity: quantity

    }]);

    window.location.href = "cart.html";
}


function showToast(message){

    const toast =
        document.getElementById("toast");

    toast.textContent = message;

    toast.classList.add("show");

    clearTimeout(window.auraToastTimer);

    window.auraToastTimer =
        setTimeout(function(){

            toast.classList.remove("show");

        },2600);

}

</script>

</body>
</html>

