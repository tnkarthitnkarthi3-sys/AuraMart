package com.auramart.dao;

import com.auramart.model.Product;
import com.auramart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts() throws SQLException {

        List<Product> products = new ArrayList<>();

        String sql =
                "SELECT id, seller_id, name, category, description, price, stock, " +
                "image, active, created_at, updated_at " +
                "FROM products " +
                "WHERE active = 1 " +
                "ORDER BY id DESC";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        }

        return products;
    }


    public Product getProductById(int id) throws SQLException {

        String sql =
                "SELECT id, seller_id, name, category, description, price, stock, " +
                "image, active, created_at, updated_at " +
                "FROM products WHERE id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        }

        return null;
    }


    public boolean addProduct(
            String name,
            String category,
            String description,
            java.math.BigDecimal price,
            int stock,
            String image) throws SQLException {

        String sql =
                "INSERT INTO products " +
                "(name, category, description, price, stock, image, active) " +
                "VALUES (?, ?, ?, ?, ?, ?, 1)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, description);
            ps.setBigDecimal(4, price);
            ps.setInt(5, stock);
            ps.setString(6, image);

            return ps.executeUpdate() == 1;
        }
    }


    public boolean updateProduct(
            int id,
            String name,
            String category,
            String description,
            java.math.BigDecimal price,
            String image) throws SQLException {

        String sql =
                "UPDATE products SET " +
                "name = ?, category = ?, description = ?, " +
                "price = ?, image = ? " +
                "WHERE id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, description);
            ps.setBigDecimal(4, price);
            ps.setString(5, image);
            ps.setInt(6, id);

            return ps.executeUpdate() == 1;
        }
    }


    public boolean refillStock(
            int id,
            int quantity) throws SQLException {

        if (quantity <= 0) {
            return false;
        }

        String sql =
                "UPDATE products " +
                "SET stock = stock + ? " +
                "WHERE id = ? AND active = 1";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, quantity);
            ps.setInt(2, id);

            return ps.executeUpdate() == 1;
        }
    }


    public boolean deactivateProduct(int id)
            throws SQLException {

        String sql =
                "UPDATE products " +
                "SET active = 0 " +
                "WHERE id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            return ps.executeUpdate() == 1;
        }
    }


    public boolean reduceStock(
            Connection conn,
            int productId,
            int quantity) throws SQLException {

        String sql =
                "UPDATE products " +
                "SET stock = stock - ? " +
                "WHERE id = ? " +
                "AND active = 1 " +
                "AND stock >= ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);

            return ps.executeUpdate() == 1;
        }
    }


    private Product mapProduct(ResultSet rs)
            throws SQLException {

        Product product = new Product();

        product.setId(rs.getInt("id"));
        product.setSellerId(rs.getInt("seller_id"));
        product.setName(rs.getString("name"));
        product.setCategory(rs.getString("category"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));
        product.setImage(rs.getString("image"));
        product.setActive(rs.getBoolean("active"));
        product.setCreatedAt(
                rs.getTimestamp("created_at")
        );
        product.setUpdatedAt(
                rs.getTimestamp("updated_at")
        );

        return product;
    }

    public boolean updatePrice(
            int id,
            java.math.BigDecimal newPrice)
            throws SQLException {

        if (newPrice == null ||
            newPrice.compareTo(java.math.BigDecimal.ZERO) < 0) {
            return false;
        }

        String sql =
                "UPDATE products SET price = ? " +
                "WHERE id = ? AND active = 1";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setBigDecimal(1, newPrice);
            ps.setInt(2, id);

            return ps.executeUpdate() == 1;
        }
    }
    public boolean activateProduct(int id)
            throws SQLException {

        String sql =
                "UPDATE products SET active = 1 " +
                "WHERE id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            return ps.executeUpdate() == 1;
        }
    }


    // ================= SELLER PRODUCT CRUD =================

    public List<Product> getProductsBySeller(int sellerId)
            throws SQLException {

        List<Product> products = new ArrayList<>();

        String sql =
                "SELECT id, seller_id, name, category, description, " +
                "price, stock, image, active, created_at, updated_at " +
                "FROM products " +
                "WHERE seller_id = ? AND active = 1 " +
                "ORDER BY id DESC";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        }

        return products;
    }


    public boolean addSellerProduct(
            int sellerId,
            String name,
            String category,
            String description,
            java.math.BigDecimal price,
            int stock,
            String image) throws SQLException {

        String sql =
                "INSERT INTO products " +
                "(seller_id, name, category, description, price, stock, image, active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 1)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, sellerId);
            ps.setString(2, name);
            ps.setString(3, category);
            ps.setString(4, description);
            ps.setBigDecimal(5, price);
            ps.setInt(6, stock);
            ps.setString(7, image);

            return ps.executeUpdate() == 1;
        }
    }


    public boolean updateSellerProduct(
            int sellerId,
            int productId,
            String name,
            String category,
            String description,
            java.math.BigDecimal price,
            int stock,
            String image) throws SQLException {

        String sql =
                "UPDATE products SET " +
                "name = ?, category = ?, description = ?, " +
                "price = ?, stock = ?, image = ? " +
                "WHERE id = ? AND seller_id = ? AND active = 1";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, description);
            ps.setBigDecimal(4, price);
            ps.setInt(5, stock);
            ps.setString(6, image);
            ps.setInt(7, productId);
            ps.setInt(8, sellerId);

            return ps.executeUpdate() == 1;
        }
    }


    public boolean deleteSellerProduct(
            int sellerId,
            int productId) throws SQLException {

        String sql =
                "UPDATE products SET active = 0 " +
                "WHERE id = ? AND seller_id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, productId);
            ps.setInt(2, sellerId);

            return ps.executeUpdate() == 1;
        }
    }


    public Product getSellerProductById(
            int sellerId,
            int productId) throws SQLException {

        String sql =
                "SELECT id, seller_id, name, category, description, " +
                "price, stock, image, active, created_at, updated_at " +
                "FROM products " +
                "WHERE id = ? AND seller_id = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, productId);
            ps.setInt(2, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        }

        return null;
    }

}


