package com.auramart.controller;

import com.auramart.dao.OrderDAO;
import com.auramart.dao.ProductDAO;
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

@WebServlet("/seller/dashboard-data")
public class SellerDashboardServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            !(session.getAttribute("loggedInUser") instanceof User)) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().print(
                    "{\"error\":\"login\"}"
            );

            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        if (!"SELLER".equalsIgnoreCase(user.getRole())) {

            response.setStatus(
                    HttpServletResponse.SC_FORBIDDEN
            );

            response.getWriter().print(
                    "{\"error\":\"seller\"}"
            );

            return;
        }

        try {

            List<SellerOrder> orders =
                    orderDAO.getOrdersBySellerId(
                            user.getId()
                    );

            int totalOrders =
                    orders.size();

            int newOrders = 0;

            for (SellerOrder order : orders) {

                String status =
                        order.getStatus();

                if (status != null &&
                    "PLACED".equalsIgnoreCase(
                            status.trim()
                    )) {

                    newOrders++;
                }
            }

            int totalProducts =
                    productDAO.getProductsBySeller(
                            user.getId()
                    ).size();

            String json =
                    "{"
                    + "\"totalProducts\":"
                    + totalProducts
                    + ","
                    + "\"totalOrders\":"
                    + totalOrders
                    + ","
                    + "\"newOrders\":"
                    + newOrders
                    + "}";

            response.getWriter().print(json);

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().print(
                    "{\"error\":\"database\"}"
            );
        }
    }
}
