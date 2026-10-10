package com.auramart.controller;

import com.auramart.dao.AdminDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

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

            int totalUsers = adminDAO.getTotalUsers();
            int totalSellers = adminDAO.getTotalSellers();
            int totalOrders = adminDAO.getTotalOrders();

            String json =
                    "{"
                    + "\"totalUsers\":" + totalUsers + ","
                    + "\"totalSellers\":" + totalSellers + ","
                    + "\"totalOrders\":" + totalOrders
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
