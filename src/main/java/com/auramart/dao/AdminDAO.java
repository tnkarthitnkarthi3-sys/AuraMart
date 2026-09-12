package com.auramart.dao;

import com.auramart.model.Product;
import com.auramart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    public List<Product> getAllProducts() throws SQLException {

        List<Product> products = new ArrayList<>();

        String sql =
                "SELECT id, name, category, description, price, stock, " +
                "image, active, created_at, updated_at " +
                "FROM products " +
                "ORDER BY id DESC";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCategory(rs.getString("category"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setStock(rs.getInt("stock"));
                p.setImage(rs.getString("image"));
                p.setActive(rs.getBoolean("active"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));

                products.add(p);
            }
        }

        return products;
    }


    public int getTotalProducts()
            throws SQLException {

        return getCount(
                "SELECT COUNT(*) FROM products"
        );
    }


    public int getInStockProducts()
            throws SQLException {

        return getCount(
                "SELECT COUNT(*) FROM products " +
                "WHERE active = 1 AND stock > 0"
        );
    }


    public int getOutOfStockProducts()
            throws SQLException {

        return getCount(
                "SELECT COUNT(*) FROM products " +
                "WHERE active = 1 AND stock = 0"
        );
    }


    public int getTotalOrders()
            throws SQLException {

        return getCount(
                "SELECT COUNT(*) FROM orders"
        );
    }


    public int getTotalUsers()
            throws SQLException {

        return getCount(
                "SELECT COUNT(*) FROM users"
        );
    }


    public int getPendingOrders()
            throws SQLException {

        return getCount(
                "SELECT COUNT(*) FROM orders " +
                "WHERE UPPER(status) = 'PENDING'"
        );
    }


    private int getCount(String sql)
            throws SQLException {

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }
}