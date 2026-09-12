package com.auramart.servlet;

import com.auramart.model.User;
import com.auramart.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/orders-data")
public class OrdersDataServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"loggedIn\":false}");
            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"loggedIn\":false}");
            return;
        }

        String sql =
                "SELECT o.id AS order_id, " +
                "o.subtotal, o.delivery_charge, " +
                "o.service_charge, o.total_amount, " +
                "o.delivery_address, o.status, o.created_at, " +
                "u.name AS user_name, u.email AS user_email, " +
                "u.phone AS user_phone, " +
                "oi.product_id, oi.quantity, oi.price, " +
                "p.name AS product_name " +
                "FROM orders o " +
                "JOIN users u ON u.id = o.user_id " +
                "LEFT JOIN order_items oi ON oi.order_id = o.id " +
                "LEFT JOIN products p ON p.id = oi.product_id " +
                "WHERE o.user_id = ? " +
                "ORDER BY o.created_at DESC, o.id DESC";

        StringBuilder json = new StringBuilder();

        json.append("{\"loggedIn\":true,\"user\":{")
            .append("\"id\":").append(user.getId()).append(",")
            .append("\"name\":\"").append(escape(user.getName())).append("\",")
            .append("\"email\":\"").append(escape(user.getEmail())).append("\"")
            .append("},\"orders\":[");

        int currentOrderId = -1;
        boolean firstOrder = true;
        boolean firstItem = true;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, user.getId());

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    int orderId =
                            rs.getInt("order_id");

                    if (orderId != currentOrderId) {

                        if (!firstOrder) {
                            json.append("]}");
                        }

                        if (!firstOrder) {
                            json.append(",");
                        }

                        currentOrderId = orderId;
                        firstOrder = false;
                        firstItem = true;

                        json.append("{")
                            .append("\"orderId\":").append(orderId).append(",")
                            .append("\"subtotal\":").append(rs.getBigDecimal("subtotal")).append(",")
                            .append("\"deliveryCharge\":").append(rs.getBigDecimal("delivery_charge")).append(",")
                            .append("\"serviceCharge\":").append(rs.getBigDecimal("service_charge")).append(",")
                            .append("\"total\":").append(rs.getBigDecimal("total_amount")).append(",")
                            .append("\"address\":\"").append(escape(rs.getString("delivery_address"))).append("\",")
                            .append("\"status\":\"").append(escape(rs.getString("status"))).append("\",")
                            .append("\"createdAt\":\"").append(escape(String.valueOf(rs.getTimestamp("created_at")))).append("\",")
                            .append("\"customer\":{")
                            .append("\"name\":\"").append(escape(rs.getString("user_name"))).append("\",")
                            .append("\"email\":\"").append(escape(rs.getString("user_email"))).append("\",")
                            .append("\"phone\":\"").append(escape(rs.getString("user_phone"))).append("\"")
                            .append("},")
                            .append("\"items\":[");
                    }

                    int productId =
                            rs.getInt("product_id");

                    if (!rs.wasNull()) {

                        if (!firstItem) {
                            json.append(",");
                        }

                        firstItem = false;

                        json.append("{")
                            .append("\"productId\":").append(productId).append(",")
                            .append("\"name\":\"").append(escape(rs.getString("product_name"))).append("\",")
                            .append("\"quantity\":").append(rs.getInt("quantity")).append(",")
                            .append("\"price\":").append(rs.getBigDecimal("price"))
                            .append("}");
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().print(
                    "{\"error\":\"database\"}"
            );

            return;
        }

        if (!firstOrder) {
            json.append("]}");
        }

        json.append("]}");

        response.getWriter().print(json.toString());
    }

    private String escape(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
}