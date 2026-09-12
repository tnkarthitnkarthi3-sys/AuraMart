<%@ page import="java.util.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="com.auramart.dao.ProductDAO" %>

<%!
    private Object call(Object obj, String... methodNames) {
        if (obj == null) return null;

        for (String name : methodNames) {
            try {
                Method m = obj.getClass().getMethod(name);
                return m.invoke(obj);
            } catch (Exception ignored) {
            }
        }

        return null;
    }

    private String str(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private String esc(String value) {
        if (value == null) return "";

        return value
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }

    private String js(String value) {
        if (value == null) return "";

        return value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\r", "")
            .replace("\n", " ");
    }

    private double num(Object value) {
        if (value == null) return 0;

        try {
            return Double.parseDouble(String.valueOf(value).replace(",", ""));
        } catch (Exception e) {
            return 0;
        }
    }

    private String imageUrl(Object product, String id) {
        Object image = call(
            product,
            "getImage",
            "getImageUrl",
            "getImageName",
            "getPhoto",
            "getPhotoUrl",
            "getImagePath"
        );

        String value = str(image).trim();

        if (value.isEmpty()) {
            return "https://dummyimage.com/700x700/f3f4f6/111827&text=Product+" + id;
        }

        if (value.startsWith("http://") || value.startsWith("https://") || value.startsWith("/")) {
            return value;
        }

        if (value.startsWith("images/")) {
            return value;
        }

        return "images/" + value;
    }

    private List<?> loadProducts() {
        try {
            ProductDAO dao = new ProductDAO();

            String[] methods = {
                "getAllProducts",
                "getProducts",
                "findAll",
                "listAll"
            };

            for (String name : methods) {
                try {
                    Method m = dao.getClass().getMethod(name);
                    Object result = m.invoke(dao);

                    if (result instanceof List) {
                        return (List<?>) result;
                    }
                } catch (Exception ignored) {
                }
            }
        } catch (Exception ignored) {
        }

        return Collections.emptyList();
    }

    private String category(Object product) {
        return str(call(product, "getCategory", "getCategoryName", "getType"));
    }

    private String productName(Object product) {
        return str(call(product, "getName", "getProductName", "getTitle"));
    }

    private String productId(Object product) {
        return str(call(product, "getId", "getProductId"));
    }

    private double productPrice(Object product) {
        return num(call(product, "getPrice", "getProductPrice"));
    }

    private double productRating(Object product) {
        return num(call(product, "getRating", "getAverageRating", "getAvgRating"));
    }

    private int productStock(Object product) {
        return (int) num(call(product, "getStock", "getQuantity", "getAvailableStock"));
    }

    private String productDescription(Object product) {
        String value = str(
            call(
                product,
                "getDescription",
                "getProductDescription",
                "getDetails"
            )
        );

        if (value.isEmpty()) {
            value = "Quality product from AuraMart.";
        }

        return value;
    }
%>

<%
    List<?> products = loadProducts();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>AuraMart | Smart Shopping</title>

    <style>
        *{
            box-sizing:border-box;
            margin:0;
            padding:0;
        }

        body{
            font-family:Inter,Arial,Helvetica,sans-serif;
            background:#f6f8fc;
            color:#172033;
        }

        .topbar{
            background:linear-gradient(135deg,#111827,#312e81);
            color:#fff;
            padding:15px 5%;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:20px;
            position:sticky;
            top:0;
            z-index:1000;
        }

        .brand{
            font-size:25px;
            font-weight:900;
            white-space:nowrap;
            letter-spacing:.3px;
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
            color:#fff;
            text-decoration:none;
            padding:9px 14px;
            border-radius:10px;
            transition:.2s;
            font-size:14px;
            font-weight:700;
        }

        .nav a:hover{
            background:rgba(255,255,255,.13);
        }

        .hero{
            padding:42px 5% 28px;
            background:
                radial-gradient(circle at 10% 20%,rgba(99,102,241,.20),transparent 28%),
                radial-gradient(circle at 90% 10%,rgba(236,72,153,.16),transparent 25%),
                #ffffff;
        }

        .hero-inner{
            max-width:1250px;
            margin:auto;
        }

        .hero h1{
            font-size:clamp(28px,4vw,46px);
            line-height:1.08;
            margin-bottom:11px;
        }

        .hero h1 span{
            color:#4f46e5;
        }

        .hero p{
            color:#64748b;
            max-width:850px;
            line-height:1.65;
            margin-bottom:22px;
        }

        .smart-search{
            position:relative;
            max-width:920px;
        }

        .smart-search input{
            width:100%;
            padding:19px 58px 19px 22px;
            border:2px solid #e2e8f0;
            border-radius:18px;
            outline:none;
            font-size:16px;
            background:#fff;
            box-shadow:0 12px 32px rgba(15,23,42,.08);
            transition:.2s;
        }

        .smart-search input:focus{
            border-color:#6366f1;
            box-shadow:0 12px 36px rgba(99,102,241,.16);
        }

        .search-icon{
            position:absolute;
            right:19px;
            top:50%;
            transform:translateY(-50%);
            font-size:23px;
            pointer-events:none;
        }

        .ai-hint{
            margin-top:11px;
            color:#64748b;
            font-size:13px;
        }

        .ai-hint b{
            color:#4f46e5;
        }

        .toolbar{
            max-width:1250px;
            margin:24px auto 0;
            padding:0 5%;
            display:flex;
            flex-wrap:wrap;
            gap:10px;
            align-items:center;
            justify-content:space-between;
        }

        .result-info{
            font-weight:800;
            color:#334155;
        }

        .sort{
            border:1px solid #dbe1ea;
            background:#fff;
            border-radius:11px;
            padding:10px 14px;
            outline:none;
        }

        .chips{
            display:flex;
            flex-wrap:wrap;
            gap:8px;
            margin-top:14px;
        }

        .chip{
            border:1px solid #dbe1ea;
            background:#fff;
            padding:8px 12px;
            border-radius:999px;
            cursor:pointer;
            color:#334155;
            font-size:12px;
            font-weight:700;
            transition:.2s;
        }

        .chip:hover{
            border-color:#6366f1;
            color:#4f46e5;
        }

        .products-wrap{
            max-width:1250px;
            margin:28px auto 70px;
            padding:0 5%;
        }

        .product-grid{
            display:grid;
            grid-template-columns:repeat(4,minmax(0,1fr));
            gap:20px;
        }

        .product-card{
            background:#fff;
            border:1px solid #e9edf5;
            border-radius:19px;
            overflow:hidden;
            box-shadow:0 9px 28px rgba(15,23,42,.06);
            transition:.25s;
            display:flex;
            flex-direction:column;
            min-width:0;
        }

        .product-card:hover{
            transform:translateY(-5px);
            box-shadow:0 18px 38px rgba(15,23,42,.12);
        }

        .product-card.ai-match{
            outline:3px solid rgba(99,102,241,.28);
        }

        .image-wrap{
            height:255px;
            padding:18px;
            position:relative;
            background:linear-gradient(135deg,#f8fafc,#eef2ff);
            cursor:pointer;
        }

        .image-wrap img{
            width:100%;
            height:100%;
            object-fit:contain;
            border-radius:12px;
            display:block;
        }

        .category-badge{
            position:absolute;
            top:13px;
            left:13px;
            background:#111827;
            color:#fff;
            border-radius:999px;
            padding:6px 10px;
            font-size:11px;
            font-weight:800;
            z-index:2;
        }

        .stock-badge{
            position:absolute;
            top:13px;
            right:13px;
            background:#dcfce7;
            color:#166534;
            border-radius:999px;
            padding:6px 10px;
            font-size:11px;
            font-weight:800;
        }

        .out{
            background:#fee2e2;
            color:#991b1b;
        }

        .product-body{
            padding:17px;
            display:flex;
            flex-direction:column;
            height:100%;
        }

        .product-name{
            font-size:17px;
            font-weight:850;
            line-height:1.35;
            min-height:46px;
            cursor:pointer;
        }

        .product-desc{
            color:#64748b;
            font-size:12px;
            line-height:1.5;
            margin-top:7px;
            min-height:36px;
        }

        .rating{
            margin-top:10px;
            font-size:13px;
            font-weight:800;
            color:#b45309;
        }

        .price-row{
            margin-top:11px;
            display:flex;
            justify-content:space-between;
            align-items:end;
            gap:10px;
        }

        .price{
            font-size:23px;
            font-weight:900;
            color:#111827;
        }

        .stock-text{
            font-size:11px;
            color:#64748b;
        }

        .actions{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:8px;
            margin-top:15px;
        }

        .btn{
            border:none;
            border-radius:11px;
            padding:11px 10px;
            cursor:pointer;
            font-weight:800;
            font-size:12px;
            transition:.2s;
        }

        .btn-cart{
            background:#eef2ff;
            color:#4338ca;
        }

        .btn-buy{
            background:#111827;
            color:#fff;
        }

        .btn:hover{
            transform:translateY(-1px);
        }

        .empty{
            background:#fff;
            border:1px dashed #cbd5e1;
            border-radius:18px;
            padding:60px 25px;
            text-align:center;
            color:#64748b;
        }

        .empty h3{
            color:#1e293b;
            margin-bottom:8px;
        }

        .smart-note{
            margin:0 auto 20px;
            max-width:1250px;
            padding:0 5%;
        }

        .smart-note-inner{
            background:linear-gradient(135deg,#eef2ff,#fdf2f8);
            border:1px solid #e0e7ff;
            border-radius:15px;
            padding:13px 16px;
            font-size:13px;
            color:#475569;
        }

        .smart-note strong{
            color:#4338ca;
        }

        @media(max-width:1100px){
            .product-grid{
                grid-template-columns:repeat(3,minmax(0,1fr));
            }
        }

        @media(max-width:800px){
            .topbar{
                flex-direction:column;
                align-items:flex-start;
            }

            .nav{
                width:100%;
                overflow:auto;
            }

            .product-grid{
                grid-template-columns:repeat(2,minmax(0,1fr));
            }
        }

        @media(max-width:520px){
            .product-grid{
                grid-template-columns:1fr;
            }

            .image-wrap{
                height:280px;
            }
        }
    </style>
</head>

<body>

<header class="topbar">
    <div class="brand">Aura<span>Mart</span></div>

    <nav class="nav">
        <a href="products.jsp">Products</a>
        <a href="cart.html">Cart</a>
        <a href="orders.html">Orders</a>
        <a href="login.html">Login</a>
    </nav>
</header>

<section class="hero">
    <div class="hero-inner">

        <h1>
            Shop smarter with
            <span>AuraMart AI</span>
        </h1>

        <p>
            Tell AuraMart what you need in normal English, Tamil or Tanglish.
            You don't need exact keywords. Just type what you are looking for.
        </p>

        <div class="smart-search">
            <input
                id="smartSearch"
                type="text"
                autocomplete="off"
                placeholder="Try: enakku 50k kulla best laptop venum"
            >
            <div class="search-icon">🔎</div>
        </div>

        <div class="ai-hint">
            Try:
            <b>50k kulla best laptop venum</b> ·
            <b>20k kulla mobile kudu</b> ·
            <b>cheap beauty products</b> ·
            <b>gaming laptop under 60000</b>
        </div>

        <div class="chips">
            <button class="chip" onclick="smartSearchExample('50k kulla best laptop venum')">Best Laptop under 50k</button>
            <button class="chip" onclick="smartSearchExample('20k kulla mobile venum')">Mobile under 20k</button>
            <button class="chip" onclick="smartSearchExample('cheap beauty products')">Cheap Beauty</button>
            <button class="chip" onclick="smartSearchExample('best rated electronics')">Best Rated Electronics</button>
            <button class="chip" onclick="smartSearchExample('gaming laptop under 60000')">Gaming Laptop</button>
        </div>

    </div>
</section>

<div class="toolbar">

    <div class="result-info" id="resultInfo">
        Showing <%= products.size() %> products
    </div>

    <select id="sortSelect" class="sort">
        <option value="relevance">Best Match</option>
        <option value="priceLow">Price: Low to High</option>
        <option value="priceHigh">Price: High to Low</option>
        <option value="rating">Top Rated</option>
        <option value="name">Name A-Z</option>
    </select>

</div>

<div class="smart-note">
    <div class="smart-note-inner" id="smartNote">
        <strong>AI:</strong>
        Tell me what you want to buy and your budget. I will find the closest matches.
    </div>
</div>

<main class="products-wrap">

    <div class="product-grid" id="productGrid">

        <% for (Object product : products) {

            String id = productId(product);
            String name = productName(product);
            String cat = category(product);
            double price = productPrice(product);
            double rating = productRating(product);
            int stock = productStock(product);
            String description = productDescription(product);
            String image = imageUrl(product, id);

        %>

        <article
            class="product-card"
            data-id="<%= esc(id) %>"
            data-name="<%= esc(name) %>"
            data-category="<%= esc(cat) %>"
            data-price="<%= price %>"
            data-rating="<%= rating %>"
            data-stock="<%= stock %>"
            data-search="<%= esc((name + " " + cat + " " + description).toLowerCase()) %>"
        >

            <div
                class="image-wrap"
                onclick="openProduct('<%= js(id) %>')"
            >

                <div class="category-badge">
                    <%= esc(cat.isEmpty() ? "Product" : cat) %>
                </div>

                <div class="stock-badge <%= stock <= 0 ? "out" : "" %>">
                    <%= stock <= 0 ? "Out of Stock" : "In Stock" %>
                </div>

                <img
                    src="<%= esc(image) %>"
                    alt="<%= esc(name) %>"
                    onerror="this.onerror=null;this.src='https://dummyimage.com/700x700/f3f4f6/111827&text=AuraMart';"
                >

            </div>

            <div class="product-body">

                <div
                    class="product-name"
                    onclick="openProduct('<%= js(id) %>')"
                >
                    <%= esc(name.isEmpty() ? "AuraMart Product" : name) %>
                </div>

                <div class="product-desc">
                    <%= esc(description.length() > 90
                        ? description.substring(0, 90) + "..."
                        : description) %>
                </div>

                <div class="rating">
                    ⭐ <%= rating > 0 ? String.format("%.1f", rating) : "New" %>
                </div>

                <div class="price-row">

                    <div class="price">
                        ₹<%= String.format("%,.0f", price) %>
                    </div>

                    <div class="stock-text">
                        <%= stock > 0 ? stock + " available" : "Currently unavailable" %>
                    </div>

                </div>

                <div class="actions">

                    <button
                        class="btn btn-cart"
                        onclick="addToCart(this)"
                        <%= stock <= 0 ? "disabled" : "" %>
                    >
                        🛒 Add
                    </button>

                    <button
                        class="btn btn-buy"
                        onclick="buyNow(this)"
                        <%= stock <= 0 ? "disabled" : "" %>
                    >
                        Buy Now
                    </button>

                </div>

            </div>

        </article>

        <% } %>

    </div>

    <div class="empty" id="emptyState" style="display:none">

        <h3>No matching products</h3>

        <p>
            Try something like:
            “50k kulla best laptop”
            or
            “20k kulla mobile”.
        </p>

    </div>

</main>

<script>

(function(){

    "use strict";

    const searchInput = document.getElementById("smartSearch");
    const resultInfo = document.getElementById("resultInfo");
    const smartNote = document.getElementById("smartNote");
    const sortSelect = document.getElementById("sortSelect");
    const productGrid = document.getElementById("productGrid");
    const emptyState = document.getElementById("emptyState");

    const cards = Array.from(
        document.querySelectorAll(".product-card")
    );

    function normalize(text){

        let s = String(text || "").toLowerCase();

        const replacements = {

            "laptops":"laptop",
            "notebook":"laptop",
            "notebooks":"laptop",

            "mobiles":"mobile",
            "phones":"phone",
            "smartphones":"mobile",
            "cellphone":"mobile",

            "tvs":"tv",
            "televisions":"tv",

            "headsets":"headphones",
            "headphone":"headphones",

            "earbuds":"earphones",
            "earbud":"earphones",

            "shoes":"footwear",
            "sneakers":"footwear",
            "sneaker":"footwear",

            "skincare":"beauty",
            "cosmetics":"beauty",
            "makeup":"beauty",

            "tshirts":"shirts",
            "tshirt":"shirts",

            "kulla":"under",
            "kull":"under",
            "varaikum":"under",
            "varaikkum":"under",
            "venum":"need",
            "venum da":"need",
            "kudu":"give",
            "kaatu":"show",
            "kattu":"show",
            "nalla":"best",
            "cheap ah":"cheap",
            "kammiya":"cheap",
            "kuraiva":"cheap"
        };

        Object.keys(replacements).forEach(function(key){

            s = s.replace(
                new RegExp("\\b" + key + "\\b","g"),
                replacements[key]
            );

        });

        return s.replace(/\s+/g," ").trim();
    }

    function budgetFrom(text){

        const s = normalize(text);

        let match = s.match(
            /(?:under|below|less than|upto|up to|maximum|max)\s*(?:₹|rs|inr)?\s*([\d.]+)\s*(k|thousand)?/i
        );

        if(!match){

            match = s.match(
                /([\d.]+)\s*(k|thousand)\s*(?:budget|range)?/i
            );

        }

        if(!match) return 0;

        let amount = parseFloat(match[1]);

        const unit = String(match[2] || "").toLowerCase();

        if(unit === "k" || unit === "thousand"){
            amount *= 1000;
        }

        return Math.round(amount);
    }

    function getCategory(text){

        const s = normalize(text);

        const map = {

            laptop:[
                "laptop",
                "macbook",
                "notebook"
            ],

            mobile:[
                "mobile",
                "phone",
                "iphone",
                "android",
                "smartphone"
            ],

            tv:[
                "tv",
                "television",
                "smart tv"
            ],

            headphones:[
                "headphones",
                "headset"
            ],

            earphones:[
                "earphones",
                "airpods"
            ],

            beauty:[
                "beauty",
                "makeup",
                "cosmetic",
                "skincare"
            ],

            shirts:[
                "shirt",
                "shirts",
                "t-shirt"
            ],

            footwear:[
                "footwear",
                "shoe"
            ],

            electronics:[
                "electronics",
                "electronic",
                "gadget",
                "gadgets"
            ]
        };

        for(const category in map){

            for(const word of map[category]){

                if(s.includes(word)){
                    return category;
                }

            }

        }

        return "";
    }

    function isBest(text){

        return /best|top|recommended|highest rated|best rated|nalla|super/i
            .test(normalize(text));

    }

    function isCheap(text){

        return /cheap|cheapest|affordable|budget|low price|kammiya|kuraiva/i
            .test(normalize(text));

    }

    function isGaming(text){

        return /gaming|gamer|game|rtx|gtx|fps/i
            .test(normalize(text));

    }

    function tokenList(text){

        return normalize(text)
            .split(/[^a-z0-9]+/)
            .filter(function(word){

                return word.length >= 3 &&
                    ![
                        "need",
                        "give",
                        "show",
                        "best",
                        "under",
                        "within",
                        "budget"
                    ].includes(word);

            });

    }

    function scoreCard(card, query){

        const text = card.dataset.search || "";
        const name = (card.dataset.name || "").toLowerCase();
        const category = (card.dataset.category || "").toLowerCase();

        const price = Number(card.dataset.price || 0);
        const rating = Number(card.dataset.rating || 0);
        const stock = Number(card.dataset.stock || 0);

        const q = normalize(query);

        const desiredCategory = getCategory(q);
        const budget = budgetFrom(q);

        let score = 0;

        if(desiredCategory){

            if(category.includes(desiredCategory)){
                score += 45;
            }

            if(text.includes(desiredCategory)){
                score += 20;
            }

        }

        tokenList(q).forEach(function(token){

            if(name.includes(token)){
                score += 12;
            }else if(text.includes(token)){
                score += 5;
            }

        });

        if(budget){

            if(price > 0 && price <= budget){

                score += 50;

                score += Math.max(
                    0,
                    25 - ((budget - price) / Math.max(budget,1)) * 25
                );

            }else{

                score -= 35;

            }

        }

        if(isBest(q)){
            score += rating * 12;
        }

        if(isCheap(q) && price > 0){

            score += Math.max(
                0,
                30 - (price / 5000)
            );

        }

        if(isGaming(q)){

            if(
                /gaming|rtx|gtx|gpu|ryzen|intel|core i5|core i7|core i9/i
                    .test(text)
            ){
                score += 45;
            }

        }

        if(stock <= 0){
            score -= 30;
        }

        return score;
    }

    function explain(query, count){

        const q = normalize(query);

        const category = getCategory(q);
        const budget = budgetFrom(q);

        let text = "AI understood: ";

        if(category){
            text += category;
        }else{
            text += "general shopping";
        }

        if(budget){
            text += " under ₹" +
                budget.toLocaleString("en-IN");
        }

        if(isGaming(q)){
            text += " with gaming performance";
        }

        if(isBest(q)){
            text += " and prioritised top-rated items";
        }

        if(count){
            text += ". Found " + count + " matching product" +
                (count > 1 ? "s." : ".");
        }else{
            text += ". No close match found.";
        }

        return text;
    }

    function render(query){

        query = String(query || "").trim();

        if(!query){

            cards.forEach(function(card){

                card.style.display = "";
                card.classList.remove("ai-match");

            });

            sortCards("relevance");

            resultInfo.textContent =
                "Showing " + cards.length + " products";

            smartNote.innerHTML =
                "<strong>AI:</strong> Tell me what you want to buy and your budget.";

            emptyState.style.display = "none";

            return;
        }

        const ranked = cards
            .map(function(card){

                return {
                    card:card,
                    score:scoreCard(card,query)
                };

            })
            .sort(function(a,b){

                return b.score - a.score;

            });

        let visible = 0;

        ranked.forEach(function(item,index){

            const shouldShow =
                item.score > 0 &&
                (item.score >= 8 || index < 6);

            if(shouldShow){

                item.card.style.display = "";
                item.card.classList.add("ai-match");
                visible++;

            }else{

                item.card.style.display = "none";
                item.card.classList.remove("ai-match");

            }

        });

        // Put strongest matches first.
        ranked.forEach(function(item){

            productGrid.appendChild(item.card);

        });

        resultInfo.textContent =
            "AI found " + visible + " matching products";

        smartNote.innerHTML =
            "<strong>AuraMart AI:</strong> " +
            explain(query,visible);

        emptyState.style.display =
            visible === 0 ? "block" : "none";

    }

    function sortCards(mode){

        const sorted = cards.slice();

        sorted.sort(function(a,b){

            const priceA = Number(a.dataset.price || 0);
            const priceB = Number(b.dataset.price || 0);

            const ratingA = Number(a.dataset.rating || 0);
            const ratingB = Number(b.dataset.rating || 0);

            const nameA = (a.dataset.name || "").toLowerCase();
            const nameB = (b.dataset.name || "").toLowerCase();

            if(mode === "priceLow"){
                return priceA - priceB;
            }

            if(mode === "priceHigh"){
                return priceB - priceA;
            }

            if(mode === "rating"){
                return ratingB - ratingA;
            }

            if(mode === "name"){
                return nameA.localeCompare(nameB);
            }

            return 0;

        });

        sorted.forEach(function(card){

            productGrid.appendChild(card);

        });

    }

    window.smartSearchExample = function(text){

        searchInput.value = text;
        render(text);
        searchInput.focus();

    };

    searchInput.addEventListener("input",function(){

        render(this.value);

    });

    searchInput.addEventListener("keydown",function(event){

        if(event.key === "Enter"){

            event.preventDefault();
            render(this.value);

        }

    });

    sortSelect.addEventListener("change",function(){

        sortCards(this.value);

    });

    window.openProduct = function(id){

        if(!id) return;

        window.location.href =
            "product-details?id=" +
            encodeURIComponent(id);

    };

    function readCart(){

        try{

            return JSON.parse(
                localStorage.getItem("auraMartCart") || "[]"
            );

        }catch(error){

            return [];

        }

    }

    function saveCart(cart){

        localStorage.setItem(
            "auraMartCart",
            JSON.stringify(cart)
        );

    }

    function productFromButton(button){

        const card = button.closest(".product-card");

        if(!card) return null;

        return {

            id:card.dataset.id,
            name:card.dataset.name || "AuraMart Product",
            price:Number(card.dataset.price || 0),
            image:card.querySelector("img")?.src || "",
            category:card.dataset.category || "",
            quantity:1

        };

    }

    window.addToCart = function(button){

        const product = productFromButton(button);

        if(!product) return;

        if(Number(button.closest(".product-card").dataset.stock || 0) <= 0){

            alert("This product is currently out of stock.");
            return;

        }

        const cart = readCart();

        const existing = cart.find(function(item){

            return String(item.id) === String(product.id);

        });

        if(existing){

            existing.quantity =
                Number(existing.quantity || 0) + 1;

        }else{

            cart.push(product);

        }

        saveCart(cart);

        const original = button.innerHTML;

        button.innerHTML = "✓ Added";

        setTimeout(function(){

            button.innerHTML = original;

        },1200);

    };

    window.buyNow = function(button){

        const product = productFromButton(button);

        if(!product) return;

        if(Number(button.closest(".product-card").dataset.stock || 0) <= 0){

            alert("This product is currently out of stock.");
            return;

        }

        const cart = [product];

        saveCart(cart);

        window.location.href = "cart.html";

    };

    // Initial state.
    render("");

})();

</script>

</body>
</html>
