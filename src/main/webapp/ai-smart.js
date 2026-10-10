/* AuraMart Smart AI Shopping Assistant */
(function () {
    "use strict";

    const NORMALIZE = {
        "lap": "laptop",
        "laptops": "laptop",
        "notebook": "laptop",
        "mobiles": "mobile",
        "phone": "mobile",
        "phones": "mobile",
        "cell": "mobile",
        "tv": "television",
        "tvs": "television",
        "headset": "headphones",
        "earbuds": "earphones",
        "shoes": "footwear",
        "sneaker": "footwear",
        "sneakers": "footwear",
        "shirt": "shirts",
        "tshirt": "t-shirt",
        "beauty": "beauty",
        "skincare": "beauty",
        "cosmetics": "beauty"
    };

    const CATEGORY_WORDS = {
        laptop: ["laptop", "notebook", "macbook"],
        mobile: ["mobile", "phone", "smartphone", "iphone", "android"],
        television: ["tv", "television", "smart tv"],
        headphones: ["headphone", "headphones", "headset"],
        earphones: ["earphone", "earphones", "earbud", "earbuds", "airpods"],
        beauty: ["beauty", "makeup", "cosmetic", "skincare", "skin care"],
        shirts: ["shirt", "shirts", "tshirt", "t-shirt"],
        footwear: ["shoe", "shoes", "footwear", "sneaker", "sneakers"],
        electronics: ["electronics", "electronic", "gadget", "gadgets"]
    };

    function clean(text) {
        return String(text || "")
            .toLowerCase()
            .replace(/[₹,]/g, "")
            .replace(/\s+/g, " ")
            .trim();
    }

    function normalizeText(text) {
        let s = clean(text);

        Object.keys(NORMALIZE).forEach(function (key) {
            const value = NORMALIZE[key];
            s = s.replace(new RegExp("\\b" + key + "\\b", "g"), value);
        });

        return s;
    }

    function extractBudget(text) {
        const s = normalizeText(text);

        let m = s.match(/(?:under|below|less than|within|upto|up to|max|maximum|below|kulla|kull|varaikkum)\s*(?:rs\.?|inr|₹)?\s*(\d+(?:\.\d+)?)\s*(k|thousand|000)?/i);

        if (!m) {
            m = s.match(/(\d+(?:\.\d+)?)\s*(k|thousand|000)\s*(?:budget|range)?/i);
        }

        if (!m) return null;

        let n = parseFloat(m[1]);

        if (m[2] && /k|thousand/i.test(m[2])) {
            n *= 1000;
        }

        if (m[2] === "000") {
            n *= 1000;
        }

        return Math.round(n);
    }

    function wantsCheap(text) {
        const s = normalizeText(text);
        return /(cheap|cheapest|affordable|low price|budget|cheap ah|kammiya|kuraiva|low cost)/i.test(s);
    }

    function wantsPremium(text) {
        const s = normalizeText(text);
        return /(premium|luxury|high end|flagship|best of best|top end)/i.test(s);
    }

    function wantsBest(text) {
        const s = normalizeText(text);
        return /(best|top|recommended|nalla|super|good|worth|best rated|highest rated)/i.test(s);
    }

    function wantsGaming(text) {
        const s = normalizeText(text);
        return /(gaming|gamer|game|rtx|fps)/i.test(s);
    }

    function wantsStock(text) {
        const s = normalizeText(text);
        return /(in stock|available|available ah|stock irukka|stock ulladha|stock la)/i.test(s);
    }

    function getCategory(text) {
        const s = normalizeText(text);

        for (const category in CATEGORY_WORDS) {
            for (const word of CATEGORY_WORDS[category]) {
                if (s.includes(word)) {
                    return category;
                }
            }
        }

        return null;
    }

    function getProductCards() {
        const selectors = [
            ".product-card",
            ".product-item",
            "[data-product-id]",
            ".product",
            ".card"
        ];

        const found = [];

        selectors.forEach(function (selector) {
            document.querySelectorAll(selector).forEach(function (el) {
                if (!found.includes(el)) found.push(el);
            });
        });

        return found;
    }

    function getCardData(card) {
        const text = clean(card.innerText || card.textContent || "");

        const priceMatch =
            text.match(/₹\s*([\d,]+)/i) ||
            text.match(/\b([\d,]{3,})\b/);

        let price = 0;

        if (priceMatch) {
            price = parseFloat(String(priceMatch[1]).replace(/,/g, ""));
        }

        const ratingMatch = text.match(/(\d(?:\.\d)?)\s*(?:\/\s*5|⭐|stars?)/i);
        const rating = ratingMatch ? parseFloat(ratingMatch[1]) : 0;

        return {
            element: card,
            text: text,
            price: price,
            rating: rating
        };
    }

    function scoreProduct(item, query) {
        const q = normalizeText(query);
        let score = 0;

        const category = getCategory(q);

        if (category) {
            if (item.text.includes(category)) score += 30;
            if (
                category === "laptop" &&
                /laptop|notebook|macbook/i.test(item.text)
            ) score += 25;

            if (
                category === "mobile" &&
                /mobile|phone|smartphone|iphone|android/i.test(item.text)
            ) score += 25;

            if (
                category === "beauty" &&
                /beauty|makeup|cosmetic|skincare/i.test(item.text)
            ) score += 25;
        }

        const words = q
            .split(/[^a-z0-9₹.]+/)
            .filter(function (w) {
                return w.length >= 3 &&
                    !["need", "venum", "kudu", "give", "best", "under", "budget"].includes(w);
            });

        words.forEach(function (word) {
            if (item.text.includes(word)) score += 6;
        });

        const budget = extractBudget(q);

        if (budget) {
            if (item.price > 0 && item.price <= budget) {
                score += 40;
            } else if (item.price > budget) {
                score -= 30;
            }
        }

        if (wantsGaming(q) && /gaming|rtx|gtx|gpu/i.test(item.text)) {
            score += 35;
        }

        if (wantsBest(q)) {
            score += item.rating * 10;
        }

        if (wantsCheap(q) && item.price > 0) {
            score += Math.max(0, 25 - item.price / 5000);
        }

        if (wantsPremium(q) && item.price > 0) {
            score += Math.min(25, item.price / 5000);
        }

        if (wantsStock(q) && /in stock|available|stock/i.test(item.text)) {
            score += 25;
        }

        return score;
    }

    function explain(query, results) {
        const budget = extractBudget(query);
        const category = getCategory(query);

        let message = "I understood your request";

        if (category) {
            message += " for " + category;
        }

        if (budget) {
            message += " within ₹" + budget.toLocaleString("en-IN");
        }

        if (wantsGaming(query)) {
            message += " with gaming performance";
        }

        if (wantsBest(query)) {
            message += " and prioritised highly rated products";
        }

        message += ".";

        if (!results.length) {
            message += " I couldn't find an exact match.";
        } else {
            message += " Here are the best matches.";
        }

        return message;
    }

    function renderAIResults(query, results) {
        let box = document.getElementById("auraSmartAIResult");

        if (!box) {
            box = document.createElement("div");
            box.id = "auraSmartAIResult";

            box.style.cssText =
                "position:fixed;" +
                "right:25px;" +
                "bottom:90px;" +
                "width:380px;" +
                "max-height:70vh;" +
                "overflow:auto;" +
                "background:#fff;" +
                "border-radius:18px;" +
                "box-shadow:0 15px 45px rgba(0,0,0,.22);" +
                "padding:18px;" +
                "z-index:99999;" +
                "font-family:Arial,sans-serif;";

            document.body.appendChild(box);
        }

        let html =
            "<div style='font-size:19px;font-weight:700;margin-bottom:10px'>AuraMart AI</div>" +
            "<div style='font-size:14px;color:#555;margin-bottom:15px'>" +
            explain(query, results) +
            "</div>";

        results.slice(0, 6).forEach(function (item, index) {
            const title =
                item.element.querySelector("h2,h3,h4,.product-title,.title")?.innerText ||
                "Recommended Product";

            html +=
                "<div class='aura-ai-result-item' data-index='" + index + "' " +
                "style='padding:12px;border:1px solid #eee;border-radius:14px;margin:8px 0;cursor:pointer'>" +
                "<div style='font-weight:700'>" + title + "</div>" +
                "<div style='font-size:13px;color:#666;margin-top:4px'>" +
                (item.price ? "₹" + item.price.toLocaleString("en-IN") : "") +
                (item.rating ? " • ⭐ " + item.rating : "") +
                "</div>" +
                "</div>";
        });

        if (!results.length) {
            html +=
                "<div style='padding:15px;background:#f7f7f7;border-radius:12px'>" +
                "Try: <b>50k kulla best laptop</b>, " +
                "<b>20k kulla mobile</b>, or <b>cheap beauty products</b>" +
                "</div>";
        }

        box.innerHTML = html;

        box.querySelectorAll(".aura-ai-result-item").forEach(function (row) {
            row.addEventListener("click", function () {
                const index = Number(row.dataset.index);
                const item = results[index];

                if (item && item.element) {
                    item.element.scrollIntoView({
                        behavior: "smooth",
                        block: "center"
                    });

                    item.element.style.outline = "3px solid #ff4d6d";

                    setTimeout(function () {
                        item.element.style.outline = "";
                    }, 2200);
                }
            });
        });
    }

    window.auraMartSmartAI = function (query) {
        query = String(query || "").trim();

        if (!query) return;

        const cards = getProductCards();

        const items = cards.map(getCardData);

        let results = items
            .map(function (item) {
                return {
                    ...item,
                    score: scoreProduct(item, query)
                };
            })
            .filter(function (item) {
                return item.score > 0;
            })
            .sort(function (a, b) {
                return b.score - a.score;
            });

        renderAIResults(query, results);

        results.slice(0, 6).forEach(function (item) {
            item.element.style.order = Math.round(-item.score);
        });
    };

    window.sendAIMessage = function () {
        const input =
            document.getElementById("aiInput") ||
            document.querySelector(".ai-input");

        if (!input) return;

        const query = input.value.trim();

        if (!query) return;

        window.auraMartSmartAI(query);

        input.value = "";
    };

    window.openAIChat = function () {
        const chat =
            document.getElementById("aiChat");

        if (chat) {
            chat.style.display =
                chat.style.display === "none" ? "block" : "block";
        }

        const input =
            document.getElementById("aiInput") ||
            document.querySelector(".ai-input");

        if (input) {
            setTimeout(function () {
                input.focus();
            }, 100);
        }
    };

    document.addEventListener("DOMContentLoaded", function () {

        const input =
            document.getElementById("aiInput") ||
            document.querySelector(".ai-input");

        if (input) {
            input.addEventListener("keydown", function (event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    window.sendAIMessage();
                }
            });
        }

        document.querySelectorAll(".ai-send").forEach(function (btn) {
            btn.addEventListener("click", function () {
                window.sendAIMessage();
            });
        });
    });

})();


