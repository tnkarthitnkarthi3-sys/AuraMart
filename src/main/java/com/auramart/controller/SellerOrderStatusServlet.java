package com.auramart.controller;

import com.auramart.dao.OrderDAO;
import com.auramart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebServlet("/seller/order-status")
public class SellerOrderStatusServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    private static final Set<String> ALLOWED_STATUSES =
            Set.of(
                    "PLACED",
                    "CONFIRMED",
                    "PROCESSING",
                    "SHIPPED",
                    "OUT FOR DELIVERY",
                    "DELIVERED"
            );

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            !(session.getAttribute("loggedInUser") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.html"
            );
            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        if (!"SELLER".equalsIgnoreCase(user.getRole())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Seller access required"
            );
            return;
        }

        String orderIdText =
                request.getParameter("orderId");

        String status =
                request.getParameter("status");

        if (orderIdText == null ||
            status == null ||
            status.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order ID and status are required"
            );
            return;
        }

        int orderId;

        try {

            orderId =
                    Integer.parseInt(
                            orderIdText
                    );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order ID"
            );
            return;
        }

        status =
                status.trim().toUpperCase();

        if (!ALLOWED_STATUSES.contains(status)) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order status"
            );
            return;
        }

        try {

            boolean updated =
                    orderDAO.updateSellerOrderStatus(
                            user.getId(),
                            orderId,
                            status
                    );

            if (!updated) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Order not found or seller is not allowed"
                );
                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/seller/orders?updated=true"
            );

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to update seller order status",
                    e
            );
        }
    }
}
