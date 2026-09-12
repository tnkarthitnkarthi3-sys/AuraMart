package com.auramart.controller;

import com.auramart.dao.AdminDAO;
import com.auramart.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-dashboard-data")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {

            int totalProducts =
                    adminDAO.getTotalProducts();

            int totalOrders =
                    adminDAO.getTotalOrders();

            int inStock =
                    adminDAO.getInStockProducts();

            int outOfStock =
                    adminDAO.getOutOfStockProducts();

            int totalUsers =
                    adminDAO.getTotalUsers();

            int pendingOrders =
                    adminDAO.getPendingOrders();

            String json =
                    "{"
                    + "\"totalProducts\":" + totalProducts + ","
                    + "\"totalUsers\":" + totalUsers + ","
                    + "\"totalOrders\":" + totalOrders + ","
                    + "\"pendingOrders\":" + pendingOrders + ","
                    + "\"inStock\":" + inStock + ","
                    + "\"outOfStock\":" + outOfStock
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
