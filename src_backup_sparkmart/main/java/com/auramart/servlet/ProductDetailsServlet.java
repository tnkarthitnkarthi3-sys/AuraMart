package com.auramart.servlet;

import com.auramart.dao.ProductDAO;
import com.auramart.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/product-details")
public class ProductDetailsServlet extends HttpServlet {

    private final ProductDAO productDAO =
            new ProductDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String idParam =
                request.getParameter("id");

        if (idParam == null ||
            idParam.trim().isEmpty()) {

            response.sendRedirect("products");
            return;
        }

        try {

            int id =
                    Integer.parseInt(idParam);

            Product product =
                    productDAO.getProductById(id);

            if (product == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Product not found"
                );

                return;
            }

            request.setAttribute(
                    "product",
                    product
            );

            request.getRequestDispatcher(
                    "/product-details.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid product ID"
            );

        } catch (SQLException e) {

            System.out.println(
                    "PRODUCT DETAILS DATABASE ERROR"
            );

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load product details"
            );
        }
    }
}