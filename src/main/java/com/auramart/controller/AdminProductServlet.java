package com.auramart.controller;

import com.auramart.dao.ProductDAO;
import com.auramart.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            List<Product> products =
                    productDAO.getAllProducts();

            request.setAttribute(
                    "products",
                    products
            );

            request.getRequestDispatcher(
                    "/admin/products.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load products"
            );
        }
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action =
                request.getParameter("action");

        try {

            if ("add".equals(action)) {

                String name =
                        request.getParameter("name");

                String category =
                        request.getParameter("category");

                String description =
                        request.getParameter("description");

                BigDecimal price =
                        new BigDecimal(
                                request.getParameter("price")
                        );

                int stock =
                        Integer.parseInt(
                                request.getParameter("stock")
                        );

                String image =
                        request.getParameter("image");

                productDAO.addProduct(
                        name,
                        category,
                        description,
                        price,
                        stock,
                        image
                );
            }


            else if ("edit".equals(action)) {

                int id =
                        Integer.parseInt(
                                request.getParameter("id")
                        );

                String name =
                        request.getParameter("name");

                String category =
                        request.getParameter("category");

                String description =
                        request.getParameter("description");

                BigDecimal price =
                        new BigDecimal(
                                request.getParameter("price")
                        );

                String image =
                        request.getParameter("image");

                productDAO.updateProduct(
                        id,
                        name,
                        category,
                        description,
                        price,
                        image
                );
            }


            else if ("increasePrice".equals(action)) {

                int id = Integer.parseInt(
                        request.getParameter("id")
                );

                BigDecimal amount = new BigDecimal(
                        request.getParameter("amount")
                );

                Product product = productDAO.getProductById(id);

                if (product != null && amount.compareTo(BigDecimal.ZERO) > 0) {

                    BigDecimal newPrice =
                            product.getPrice().add(amount);

                    productDAO.updatePrice(id, newPrice);
                }
            }


            else if ("decreasePrice".equals(action)) {

                int id = Integer.parseInt(
                        request.getParameter("id")
                );

                BigDecimal amount = new BigDecimal(
                        request.getParameter("amount")
                );

                Product product = productDAO.getProductById(id);

                if (product != null && amount.compareTo(BigDecimal.ZERO) > 0) {

                    BigDecimal newPrice =
                            product.getPrice().subtract(amount);

                    if (newPrice.compareTo(BigDecimal.ZERO) >= 0) {
                        productDAO.updatePrice(id, newPrice);
                    }
                }
            }


            else if ("refill".equals(action)) {

                int id =
                        Integer.parseInt(
                                request.getParameter("id")
                        );

                int quantity =
                        Integer.parseInt(
                                request.getParameter("quantity")
                        );

                productDAO.refillStock(
                        id,
                        quantity
                );
            }


            else if ("delete".equals(action)) {

                int id =
                        Integer.parseInt(
                                request.getParameter("id")
                        );

                productDAO.deactivateProduct(id);
            }


            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/products"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/products?error=true"
            );
        }
    }
}

