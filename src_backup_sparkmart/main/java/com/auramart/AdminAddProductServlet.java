package com.auramart;

import java.io.IOException;
import java.math.BigDecimal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-add-product")
public class AdminAddProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        System.out.println("=================================");
        System.out.println("ADMIN ADD PRODUCT REQUEST");
        System.out.println("=================================");

        try {

            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String priceText = request.getParameter("price");
            String stockText = request.getParameter("stock");
            String image = request.getParameter("image");

            String activeText = request.getParameter("active");

            BigDecimal price = new BigDecimal(priceText);
            int stock = Integer.parseInt(stockText);

            boolean active = "true".equals(activeText);

            Product product = new Product();

            product.setName(name);
            product.setCategory(category);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setImage(image);
            product.setActive(active);

            boolean success = productDAO.addProduct(product);

            if (success) {

                System.out.println("PRODUCT ADD SUCCESS");

                response.sendRedirect(
                    request.getContextPath() + "/admin-products"
                );

            } else {

                System.out.println("PRODUCT ADD FAILED");

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin-add-product.jsp?error=failed"
                );
            }

        } catch (Exception e) {

            System.out.println("PRODUCT ADD ERROR");
            e.printStackTrace();

            response.sendRedirect(
                request.getContextPath()
                + "/admin-add-product.jsp?error=invalid"
            );
        }
    }
}
