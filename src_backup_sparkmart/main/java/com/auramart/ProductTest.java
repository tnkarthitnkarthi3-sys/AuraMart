package com.auramart;

import java.util.List;

public class ProductTest {

    public static void main(String[] args) {

        System.out.println("=================================");
        System.out.println("PRODUCT DAO TEST");
        System.out.println("=================================");

        ProductDAO dao = new ProductDAO();

        List<Product> products = dao.getAllProducts();

        System.out.println("Total Products: " + products.size());

        for (Product product : products) {

            System.out.println("---------------------------------");
            System.out.println("ID       : " + product.getId());
            System.out.println("Name     : " + product.getName());
            System.out.println("Category : " + product.getCategory());
            System.out.println("Price    : " + product.getPrice());
            System.out.println("Stock    : " + product.getStock());
            System.out.println("Active   : " + product.isActive());
        }

        System.out.println("=================================");
    }
}
