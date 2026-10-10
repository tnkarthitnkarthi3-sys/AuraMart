
let auraAIRequestPending = false;

function toggleAuraAI() {
    const box = document.getElementById("auraAIBox");
    if (!box) return;

    const isOpen = box.style.display === "flex";
    box.style.display = isOpen ? "none" : "flex";

    if (!isOpen) {
        box.style.flexDirection = "column";
        setTimeout(() => {
            document.getElementById("auraAIInput")?.focus();
        }, 100);
    }
}

function auraQuick(message) {
    const input = document.getElementById("auraAIInput");
    if (!input || auraAIRequestPending) return;

    input.value = message;
    sendAuraAI();
}

function addAuraMessage(message, type) {
    const container = document.getElementById("auraAIMessages");
    if (!container) return null;

    const div = document.createElement("div");
    div.className = "aura-ai-message " + type;
    div.textContent = message;

    container.appendChild(div);
    container.scrollTop = container.scrollHeight;

    return div;
}

async function sendAuraAI() {
    const input = document.getElementById("auraAIInput");
    const sendButton = document.querySelector(".aura-ai-input button");

    if (!input || auraAIRequestPending) return;

    const message = input.value.trim();
    if (!message) return;

    auraAIRequestPending = true;
    if (sendButton) sendButton.disabled = true;
    input.disabled = true;

    addAuraMessage(message, "user");
    input.value = "";

    const loading = addAuraMessage(
        "AuraMart AI is thinking... 🤔",
        "bot"
    );

    try {
        const formData = new URLSearchParams();
        formData.append("message", message);

        const response = await fetch("ai-chat", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData.toString()
        });

        if (!response.ok) {
            throw new Error("HTTP " + response.status);
        }

        const data = await response.json();
        loading?.remove();

        addAuraMessage(
            data.success
                ? data.reply
                : (data.reply || "Sorry macha 😅, try again."),
            "bot"
        );
    } catch (error) {
        console.error("Aura AI error:", error);
        loading?.remove();

        addAuraMessage(
            "Macha 😅 server response varala. Please try again.",
            "bot"
        );
    } finally {
        auraAIRequestPending = false;
        input.disabled = false;
        if (sendButton) sendButton.disabled = false;
        input.focus();
    }
}
