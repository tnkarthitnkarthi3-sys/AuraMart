package com.auramart;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-products")
public class AdminProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=================================");
        System.out.println("ADMIN PRODUCTS REQUEST");
        System.out.println("=================================");

        List<Product> sourceProducts =
                productDAO.getAllProducts();

        System.out.println(
                "Total Products: "
                + sourceProducts.size()
        );

        List<com.auramart.model.Product> products =
                new ArrayList<>();

        for (Product source : sourceProducts) {

            com.auramart.model.Product target =
                    new com.auramart.model.Product();

            target.setId(source.getId());
            target.setName(source.getName());
            target.setCategory(source.getCategory());
            target.setDescription(source.getDescription());
            target.setPrice(source.getPrice());
            target.setStock(source.getStock());
            target.setImage(source.getImage());
            target.setActive(source.isActive());
            target.setCreatedAt(source.getCreatedAt());
            target.setUpdatedAt(source.getUpdatedAt());

            products.add(target);
        }

        request.setAttribute(
                "products",
                products
        );

        request.getRequestDispatcher(
                "/admin-products.jsp"
        ).forward(request, response);
    }
}