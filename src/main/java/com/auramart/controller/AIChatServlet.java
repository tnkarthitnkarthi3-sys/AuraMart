package com.auramart.controller;

import com.auramart.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.*;

@WebServlet("/ai-chat")
public class AIChatServlet extends HttpServlet {

    private static final String OPENAI_URL =
            "https://api.openai.com/v1/chat/completions";

    private static final String MODEL =
            "gpt-4o-mini";

    private String apiKey;

    @Override
    public void init() throws ServletException {
        apiKey = System.getenv("OPENAI_API_KEY");

        if (apiKey == null || apiKey.isBlank()) {
            System.out.println("WARNING: OPENAI_API_KEY is not configured.");
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String userMessage = request.getParameter("message");

        if (userMessage == null || userMessage.trim().isEmpty()) {
            sendJson(response, "{\"success\":false,\"reply\":\"Please enter a message.\"}");
            return;
        }

        userMessage = userMessage.trim();

        try {

            String productContext = getProductContext(userMessage);

            String reply;

            if (apiKey == null || apiKey.isBlank()) {
                reply = localAuraMartResponse(userMessage, productContext);
            } else {
                reply = askOpenAI(userMessage, productContext);
            }

            sendJson(
                    response,
                    "{\"success\":true,\"reply\":" +
                            jsonEscape(reply) +
                            "}"
            );

        } catch (Exception e) {

            e.printStackTrace();

            String fallback =
                    "Sorry macha 😅 AI service-la konjam problem. " +
                    "Please try again.";

            sendJson(
                    response,
                    "{\"success\":false,\"reply\":" +
                            jsonEscape(fallback) +
                            "}"
            );
        }
    }

    private String getProductContext(String message) {

        StringBuilder result = new StringBuilder();

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                    "SELECT id, name, category, price, stock, active " +
                    "FROM products " +
                    "WHERE active = 1 " +
                    "AND (LOWER(name) LIKE ? " +
                    "OR LOWER(category) LIKE ?) " +
                    "ORDER BY id DESC LIMIT 8";

            String search = "%" + message.toLowerCase() + "%";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, search);
                ps.setString(2, search);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        result.append(
                                "Product: "
                        ).append(rs.getString("name"));

                        result.append(
                                " | Category: "
                        ).append(rs.getString("category"));

                        result.append(
                                " | Price: ₹"
                        ).append(rs.getDouble("price"));

                        result.append(
                                " | Stock: "
                        ).append(rs.getInt("stock"));

                        result.append("\n");
                    }
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "Product context error: " +
                    e.getMessage()
            );
        }

        return result.toString();
    }

    private String askOpenAI(
            String userMessage,
            String productContext)
            throws Exception {

        String systemPrompt =
                "You are AuraMart AI Assistant, an AI shopping assistant " +
                "inside the AuraMart ecommerce website. " +

                "Answer naturally and helpfully. " +

                "You can help users with products, prices, stock, " +
                "shopping, cart, orders, login, payment and website navigation. " +

                "If the user speaks Tamil, reply in natural Tamil/Tanglish. " +
                "If the user speaks English, reply in English. " +

                "Never invent product prices or stock. " +

                "Use the provided product database information when relevant. " +

                "Keep normal answers concise and friendly. " +

                "Product database context:\\n" +
                productContext;

        String body =
                "{"
                + "\"model\":\"" + MODEL + "\","
                + "\"messages\":["
                + "{"
                + "\"role\":\"system\","
                + "\"content\":" + jsonEscape(systemPrompt)
                + "},"
                + "{"
                + "\"role\":\"user\","
                + "\"content\":" + jsonEscape(userMessage)
                + "}"
                + "],"
                + "\"temperature\":0.7"
                + "}";

        HttpClient client =
                HttpClient.newHttpClient();

        HttpRequest httpRequest =
                HttpRequest.newBuilder()
                        .uri(URI.create(OPENAI_URL))
                        .header(
                                "Content-Type",
                                "application/json"
                        )
                        .header(
                                "Authorization",
                                "Bearer " + apiKey
                        )
                        .POST(
                                HttpRequest.BodyPublishers.ofString(
                                        body,
                                        StandardCharsets.UTF_8
                                )
                        )
                        .build();

        HttpResponse<String> result =
                client.send(
                        httpRequest,
                        HttpResponse.BodyHandlers.ofString(
                                StandardCharsets.UTF_8
                        )
                );

        if (result.statusCode() < 200 ||
                result.statusCode() >= 300) {

            System.out.println(
                    "OpenAI HTTP " +
                    result.statusCode() +
                    ": " +
                    result.body()
            );

            return localAuraMartResponse(
                    userMessage,
                    productContext
            );
        }

        return extractAssistantMessage(
                result.body()
        );
    }

    private String extractAssistantMessage(
            String json) {

        String marker =
                "\"content\":\"";

        int start =
                json.indexOf(marker);

        if (start == -1) {
            return "Sorry macha, AI response properly varala 😅";
        }

        start += marker.length();

        StringBuilder value =
                new StringBuilder();

        boolean escaped = false;

        for (int i = start; i < json.length(); i++) {

            char c = json.charAt(i);

            if (escaped) {

                if (c == 'n') {
                    value.append('\n');
                } else if (c == 'r') {
                    value.append('\r');
                } else if (c == 't') {
                    value.append('\t');
                } else if (c == '"') {
                    value.append('"');
                } else if (c == '\\') {
                    value.append('\\');
                } else {
                    value.append(c);
                }

                escaped = false;
                continue;
            }

            if (c == '\\') {
                escaped = true;
                continue;
            }

            if (c == '"') {
                break;
            }

            value.append(c);
        }

        return value.toString();
    }

    private String localAuraMartResponse(
            String message,
            String products) {

        String m =
                message.toLowerCase();

        if (m.contains("hello") ||
                m.contains("hi") ||
                m.contains("hai") ||
                m.contains("vanakkam")) {

            return "Hi macha 👋 Welcome to AuraMart! " +
                    "Products, price, stock, cart or orders pathi " +
                    "enna venumnaalum kekkalaam.";
        }

        if (m.contains("cart")) {

            return "Macha 🛒 cart open panna top navigation-la " +
                    "Cart click pannunga. Product-ku Add to Cart " +
                    "button use pannalaam.";
        }

        if (m.contains("order")) {

            return "Macha 📦 order details பார்க்க " +
                    "Orders section open pannunga. " +
                    "Recent orders and status anga available.";
        }

        if (!products.isBlank()) {

            return "Macha 🔎 database-la related products " +
                    "kidaichirukku:\n\n" +
                    products;
        }

        return "Macha 😄 naan AuraMart shopping assistant. " +
                "Product name, price, stock, cart அல்லது order pathi " +
                "kekka try pannunga.";
    }

    private String jsonEscape(String value) {

        if (value == null) {
            return "\"\"";
        }

        return "\"" +
                value
                        .replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                        .replace("\r", "\\r")
                        .replace("\n", "\\n")
                        .replace("\t", "\\t")
                + "\"";
    }

    private void sendJson(
            HttpServletResponse response,
            String json)
            throws IOException {

        response.getWriter().write(json);
    }
}
