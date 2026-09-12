package com.auramart.servlet;

import com.auramart.dao.AdminDAO;
import com.auramart.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            List<Product> products =
                    adminDAO.getAllProducts();

            request.setAttribute(
                    "products",
                    products
            );

            request.setAttribute(
                    "totalProducts",
                    adminDAO.getTotalProducts()
            );

            request.setAttribute(
                    "inStock",
                    adminDAO.getInStockProducts()
            );

            request.setAttribute(
                    "outOfStock",
                    adminDAO.getOutOfStockProducts()
            );

            request.setAttribute(
                    "totalOrders",
                    adminDAO.getTotalOrders()
            );

            request.getRequestDispatcher(
                    "/admin/admin.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load Admin Dashboard"
            );
        }
    }
}
