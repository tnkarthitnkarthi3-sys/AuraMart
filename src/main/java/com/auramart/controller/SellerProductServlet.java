package com.auramart.controller;

import com.auramart.dao.ProductDAO;
import com.auramart.model.Product;
import com.auramart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/seller/products")
public class SellerProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("loggedInUser") instanceof User)) {

            response.sendRedirect(
                request.getContextPath() + "/login.html"
            );
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        if (!"SELLER".equalsIgnoreCase(user.getRole())) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Seller access required"
            );
            return;
        }

        try {
            List<Product> products =
                    productDAO.getProductsBySeller(user.getId());

            request.setAttribute("products", products);

            request.getRequestDispatcher(
                "/seller/products.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load seller products",
                e
            );
        }
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("loggedInUser") instanceof User)) {

            response.sendRedirect(
                request.getContextPath() + "/login.html"
            );
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");

        if (!"SELLER".equalsIgnoreCase(user.getRole())) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Seller access required"
            );
            return;
        }

        String action = request.getParameter("action");

        try {

            if ("add".equalsIgnoreCase(action)) {

                String name = request.getParameter("name");
                String category = request.getParameter("category");
                String description = request.getParameter("description");
                String priceText = request.getParameter("price");
                String stockText = request.getParameter("stock");
                String image = request.getParameter("image");

                if (name == null || name.trim().isEmpty()) {
                    response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Product name is required"
                    );
                    return;
                }

                BigDecimal price = new BigDecimal(priceText);
                int stock = Integer.parseInt(stockText);

                productDAO.addSellerProduct(
                    user.getId(),
                    name.trim(),
                    category,
                    description,
                    price,
                    stock,
                    image
                );

            } else if ("update".equalsIgnoreCase(action)) {

                int productId =
                    Integer.parseInt(
                        request.getParameter("id")
                    );

                String name = request.getParameter("name");
                String category = request.getParameter("category");
                String description = request.getParameter("description");
                BigDecimal price =
                    new BigDecimal(request.getParameter("price"));
                int stock =
                    Integer.parseInt(
                        request.getParameter("stock")
                    );
                String image = request.getParameter("image");

                productDAO.updateSellerProduct(
                    user.getId(),
                    productId,
                    name,
                    category,
                    description,
                    price,
                    stock,
                    image
                );

            } else if ("delete".equalsIgnoreCase(action)) {

                int productId =
                    Integer.parseInt(
                        request.getParameter("id")
                    );

                productDAO.deleteSellerProduct(
                    user.getId(),
                    productId
                );
            }

            response.sendRedirect(
                request.getContextPath() + "/seller/products"
            );

        } catch (NumberFormatException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid price, stock or product ID"
            );

        } catch (Exception e) {

            throw new ServletException(
                "Seller product operation failed",
                e
            );
        }
    }
}
