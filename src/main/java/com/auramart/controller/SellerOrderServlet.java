package com.auramart.controller;

import com.auramart.dao.OrderDAO;
import com.auramart.model.SellerOrder;
import com.auramart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/seller/orders")
public class SellerOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    private boolean isSeller(HttpSession session) {

        if (session == null) {
            return false;
        }

        Object loggedInUser =
                session.getAttribute("loggedInUser");

        if (!(loggedInUser instanceof User)) {
            return false;
        }

        User user = (User) loggedInUser;

        return "SELLER".equalsIgnoreCase(user.getRole());
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (!isSeller(session)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login.html"
            );

            return;
        }

        User user =
                (User) session.getAttribute(
                        "loggedInUser"
                );

        try {

            List<SellerOrder> orders =
                    orderDAO.getOrdersBySellerId(
                            user.getId()
                    );

            request.setAttribute(
                    "sellerOrders",
                    orders
            );

            request.getRequestDispatcher(
                    "/seller/orders.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to load seller orders."
            );

            request.getRequestDispatcher(
                    "/seller/orders.jsp"
            ).forward(request, response);
        }
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (!isSeller(session)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Seller access required"
            );

            return;
        }

        User user =
                (User) session.getAttribute(
                        "loggedInUser"
                );

        String action =
                request.getParameter("action");

        if (!"update-status".equalsIgnoreCase(action)) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid seller order action"
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

        status = status.trim().toUpperCase();

        /*
         * ==========================================
         * ALLOWED SELLER STATUS
         * ==========================================
         */

        if (!isAllowedStatus(status)) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order status"
            );

            return;
        }

        try {

            /*
             * ==========================================
             * GET CURRENT ORDER STATUS FOR THIS SELLER
             * ==========================================
             */

            List<SellerOrder> orders =
                    orderDAO.getOrdersBySellerId(
                            user.getId()
                    );

            SellerOrder targetOrder = null;

            for (SellerOrder order : orders) {

                if (order.getOrderId() == orderId) {

                    targetOrder = order;
                    break;
                }
            }

            if (targetOrder == null) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You cannot update this order"
                );

                return;
            }

            String currentStatus =
                    targetOrder.getStatus();

            /*
             * ==========================================
             * STATUS MUST MOVE FORWARD ONLY
             * ==========================================
             */

            if (!isValidNextStatus(
                    currentStatus,
                    status
            )) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid status progression: "
                                + currentStatus
                                + " -> "
                                + status
                );

                return;
            }

            boolean updated =
                    orderDAO.updateSellerOrderStatus(
                            user.getId(),
                            orderId,
                            status
                    );

            if (!updated) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Order status update failed"
                );

                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                            + "/seller/orders?updated=true"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to update order status"
            );
        }
    }


    /*
     * ==========================================
     * ALLOWED STATUS VALUES
     * ==========================================
     */

    private boolean isAllowedStatus(String status) {

        return
                "PLACED".equals(status)
                || "CONFIRMED".equals(status)
                || "PROCESSING".equals(status)
                || "SHIPPED".equals(status)
                || "OUT FOR DELIVERY".equals(status)
                || "DELIVERED".equals(status);
    }


    /*
     * ==========================================
     * STATUS PROGRESSION
     * ==========================================
     */

    private boolean isValidNextStatus(
            String currentStatus,
            String newStatus) {

        if (currentStatus == null) {
            return false;
        }

        currentStatus =
                currentStatus.trim().toUpperCase();

        /*
         * Same status = no update
         */

        if (currentStatus.equals(newStatus)) {
            return false;
        }

        switch (currentStatus) {

            case "PLACED":

                return "CONFIRMED".equals(newStatus);

            case "CONFIRMED":

                return "PROCESSING".equals(newStatus);

            case "PROCESSING":

                return "SHIPPED".equals(newStatus);

            case "SHIPPED":

                return "OUT FOR DELIVERY".equals(newStatus);

            case "OUT FOR DELIVERY":

                return "DELIVERED".equals(newStatus);

            case "DELIVERED":

                return false;

            default:

                return false;
        }
    }
}
