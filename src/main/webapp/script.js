console.log("AURAMART SCRIPT LOADED");

let cart = JSON.parse(localStorage.getItem("auraMartCart")) || [];

function addToCart(name, price) {

    const existingProduct = cart.find(function(item) {
        return item.name === name;
    });

    if (existingProduct) {
        existingProduct.quantity++;
    } else {
        cart.push({
            name: name,
            price: Number(price),
            quantity: 1
        });
    }

    localStorage.setItem("auraMartCart", JSON.stringify(cart));

    updateCartCount();

    alert(name + " added to cart!");
}

function updateCartCount() {

    let count = 0;

    cart.forEach(function(item) {
        count += item.quantity;
    });

    const cartCount = document.getElementById("cartCount");

    if (cartCount) {
        cartCount.innerText = count;
    }
}

document.addEventListener("DOMContentLoaded", function() {
    updateCartCount();
});