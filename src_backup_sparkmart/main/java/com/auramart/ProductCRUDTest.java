package com.auramart;

public class ProductCRUDTest {

    public static void main(String[] args) {

        System.out.println("=================================");
        System.out.println("PRODUCT DELETE TEST");
        System.out.println("=================================");

        ProductDAO dao = new ProductDAO();

        Product product = dao.getProductById(101);

        if (product == null) {
            System.out.println("TEST PRODUCT NOT FOUND");
            return;
        }

        System.out.println("Product Found:");
        System.out.println("ID   : " + product.getId());
        System.out.println("Name : " + product.getName());

        boolean deleted = dao.deleteProduct(101);

        System.out.println("---------------------------------");
        System.out.println("DELETE PRODUCT: " + deleted);

        if (deleted) {
            System.out.println("Product deleted successfully.");
        } else {
            System.out.println("Product delete failed.");
        }

        Product deletedProduct = dao.getProductById(101);

        System.out.println("---------------------------------");

        if (deletedProduct == null) {
            System.out.println("VERIFY DELETE: SUCCESS");
            System.out.println("Product no longer exists in database.");
        } else {
            System.out.println("VERIFY DELETE: FAILED");
        }

        System.out.println("=================================");
    }
}
