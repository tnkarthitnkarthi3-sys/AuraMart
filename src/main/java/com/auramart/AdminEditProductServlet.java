package com.auramart;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/admin-edit-product")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 6 * 1024 * 1024
)
public class AdminEditProductServlet extends HttpServlet {

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

        try {
            String idText = request.getParameter("id");

            if (idText == null || idText.trim().isEmpty()) {
                response.sendRedirect(
                    request.getContextPath() + "/admin/products"
                );
                return;
            }

            int id = Integer.parseInt(idText);

            Product product = productDAO.getProductById(id);

            if (product == null) {
                response.sendRedirect(
                    request.getContextPath() + "/admin/products"
                );
                return;
            }

            request.setAttribute("product", product);

            request.getRequestDispatcher(
                "/admin-edit-product.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(
                request.getContextPath() + "/admin/products"
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        System.out.println("=================================");
        System.out.println("ADMIN UPDATE PRODUCT REQUEST");
        System.out.println("=================================");

        try {
            int id = Integer.parseInt(
                request.getParameter("id")
            );

            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");

            BigDecimal price = new BigDecimal(
                request.getParameter("price")
            );

            int stock = Integer.parseInt(
                request.getParameter("stock")
            );

            String image =
                request.getParameter("currentImage");

            /*
             * LOCAL IMAGE UPLOAD
             */
            Part imagePart = request.getPart("imageFile");

            if (imagePart != null &&
                imagePart.getSize() > 0) {

                String submittedName =
                    Paths.get(
                        imagePart.getSubmittedFileName()
                    ).getFileName().toString();

                String extension = "";

                int dot = submittedName.lastIndexOf('.');

                if (dot >= 0) {
                    extension =
                        submittedName.substring(dot)
                                   .toLowerCase();
                }

                if (!extension.equals(".jpg") &&
                    !extension.equals(".jpeg") &&
                    !extension.equals(".png") &&
                    !extension.equals(".webp")) {

                    response.sendRedirect(
                        request.getContextPath()
                        + "/admin-edit-product?id="
                        + id
                        + "&error=image"
                    );
                    return;
                }

                String fileName =
                    UUID.randomUUID().toString()
                    + extension;

                String uploadPath =
                    getServletContext()
                    .getRealPath("/uploads");

                Path uploadDir =
                    Paths.get(uploadPath);

                Files.createDirectories(uploadDir);

                Path target =
                    uploadDir.resolve(fileName);

                Files.copy(
                    imagePart.getInputStream(),
                    target,
                    StandardCopyOption.REPLACE_EXISTING
                );

                image = "uploads/" + fileName;

                System.out.println(
                    "IMAGE UPLOADED: " + image
                );
            }

            boolean active =
                "true".equals(
                    request.getParameter("active")
                );

            Product product = new Product();

            product.setId(id);
            product.setName(name);
            product.setCategory(category);
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setImage(image);
            product.setActive(active);

            boolean success =
                productDAO.updateProduct(product);

            if (success) {

                System.out.println(
                    "UPDATE PRODUCT: true"
                );

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/products"
                );

            } else {

                System.out.println(
                    "UPDATE PRODUCT: false"
                );

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin-edit-product?id="
                    + id
                    + "&error=failed"
                );
            }

        } catch (Exception e) {

            System.out.println(
                "UPDATE PRODUCT ERROR"
            );

            e.printStackTrace();

            response.sendRedirect(
                request.getContextPath()
                + "/admin/products"
            );
        }
    }
}
