package com.auramart.dao;

import com.auramart.model.Order;
import com.auramart.model.OrderItem;
import com.auramart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int createOrder(Order order, List<OrderItem> items)
            throws SQLException {

        if (order == null || items == null || items.isEmpty()) {
            throw new SQLException("Invalid order or empty order items");
        }

        String orderSql =
                "INSERT INTO orders " +
                "(user_id, subtotal, delivery_charge, service_charge, " +
                "total_amount, delivery_address, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        String stockCheckSql =
                "SELECT id, stock, active " +
                "FROM products " +
                "WHERE id = ? " +
                "FOR UPDATE";

        String itemSql =
                "INSERT INTO order_items " +
                "(order_id, product_id, quantity, price) " +
                "VALUES (?, ?, ?, ?)";

        String stockUpdateSql =
                "UPDATE products " +
                "SET stock = stock - ? " +
                "WHERE id = ? " +
                "AND active = 1 " +
                "AND stock >= ?";

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();

            conn.setAutoCommit(false);

            /*
             * ==========================================
             * STEP 1: CHECK ALL PRODUCTS + STOCK
             * ==========================================
             */

            for (OrderItem item : items) {

                if (item.getProductId() <= 0) {
                    throw new SQLException(
                            "Invalid product ID"
                    );
                }

                if (item.getQuantity() <= 0) {
                    throw new SQLException(
                            "Invalid product quantity"
                    );
                }

                if (item.getPrice() == null ||
                    item.getPrice().compareTo(
                            java.math.BigDecimal.ZERO) < 0) {

                    throw new SQLException(
                            "Invalid product price"
                    );
                }

                try (PreparedStatement ps =
                             conn.prepareStatement(stockCheckSql)) {

                    ps.setInt(1, item.getProductId());

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {

                            throw new SQLException(
                                    "Product not found: "
                                    + item.getProductId()
                            );
                        }

                        int stock =
                                rs.getInt("stock");

                        boolean active =
                                rs.getBoolean("active");

                        if (!active) {

                            throw new SQLException(
                                    "Product is inactive: "
                                    + item.getProductId()
                            );
                        }

                        if (stock < item.getQuantity()) {

                            throw new SQLException(
                                    "Insufficient stock for product ID: "
                                    + item.getProductId()
                            );
                        }
                    }
                }
            }

            /*
             * ==========================================
             * STEP 2: CREATE ORDER
             * ==========================================
             */

            int orderId;

            try (PreparedStatement ps =
                         conn.prepareStatement(
                                 orderSql,
                                 Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(
                        1,
                        order.getUserId()
                );

                ps.setBigDecimal(
                        2,
                        order.getSubtotal()
                );

                ps.setBigDecimal(
                        3,
                        order.getDeliveryCharge()
                );

                ps.setBigDecimal(
                        4,
                        order.getServiceCharge()
                );

                ps.setBigDecimal(
                        5,
                        order.getTotalAmount()
                );

                ps.setString(
                        6,
                        order.getDeliveryAddress()
                );

                ps.setString(
                        7,
                        order.getStatus()
                );

                ps.executeUpdate();

                try (ResultSet rs =
                             ps.getGeneratedKeys()) {

                    if (!rs.next()) {

                        throw new SQLException(
                                "Failed to get generated order ID"
                        );
                    }

                    orderId =
                            rs.getInt(1);
                }
            }

            /*
             * ==========================================
             * STEP 3: INSERT ORDER ITEMS
             * ==========================================
             */

            try (PreparedStatement ps =
                         conn.prepareStatement(itemSql)) {

                for (OrderItem item : items) {

                    ps.setInt(
                            1,
                            orderId
                    );

                    ps.setInt(
                            2,
                            item.getProductId()
                    );

                    ps.setInt(
                            3,
                            item.getQuantity()
                    );

                    ps.setBigDecimal(
                            4,
                            item.getPrice()
                    );

                    ps.addBatch();
                }

                ps.executeBatch();
            }

            /*
             * ==========================================
             * STEP 4: REDUCE ONLY PURCHASED STOCK
             * ==========================================
             */

            try (PreparedStatement ps =
                         conn.prepareStatement(stockUpdateSql)) {

                for (OrderItem item : items) {

                    ps.setInt(
                            1,
                            item.getQuantity()
                    );

                    ps.setInt(
                            2,
                            item.getProductId()
                    );

                    ps.setInt(
                            3,
                            item.getQuantity()
                    );

                    int updated =
                            ps.executeUpdate();

                    if (updated != 1) {

                        throw new SQLException(
                                "Stock update failed for product ID: "
                                + item.getProductId()
                        );
                    }
                }
            }

            /*
             * ==========================================
             * STEP 5: COMMIT
             * ==========================================
             */

            conn.commit();

            System.out.println(
                    "ORDER + ITEMS + STOCK UPDATED SUCCESSFULLY"
            );

            return orderId;

        } catch (SQLException e) {

            /*
             * ==========================================
             * ROLLBACK EVERYTHING
             * ==========================================
             */

            if (conn != null) {

                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }

            throw e;

        } finally {

            if (conn != null) {

                try {

                    conn.setAutoCommit(true);
                    conn.close();

                } catch (SQLException ignored) {
                }
            }
        }
    }


    public List<Order> getOrdersByUserId(int userId)
            throws SQLException {

        List<Order> orders =
                new ArrayList<>();

        String sql =
                "SELECT id, user_id, subtotal, delivery_charge, " +
                "service_charge, total_amount, delivery_address, " +
                "status, created_at " +
                "FROM orders " +
                "WHERE user_id = ? " +
                "ORDER BY created_at DESC";

        try (
                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setInt(
                    1,
                    userId
            );

            try (ResultSet rs =
                         ps.executeQuery()) {

                while (rs.next()) {

                    Order order =
                            new Order();

                    order.setId(
                            rs.getInt("id")
                    );

                    order.setUserId(
                            rs.getInt("user_id")
                    );

                    order.setSubtotal(
                            rs.getBigDecimal("subtotal")
                    );

                    order.setDeliveryCharge(
                            rs.getBigDecimal(
                                    "delivery_charge"
                            )
                    );

                    order.setServiceCharge(
                            rs.getBigDecimal(
                                    "service_charge"
                            )
                    );

                    order.setTotalAmount(
                            rs.getBigDecimal(
                                    "total_amount"
                            )
                    );

                    order.setDeliveryAddress(
                            rs.getString(
                                    "delivery_address"
                            )
                    );

                    order.setStatus(
                            rs.getString("status")
                    );

                    order.setCreatedAt(
                            rs.getTimestamp(
                                    "created_at"
                            )
                    );

                    orders.add(order);
                }
            }
        }

        return orders;
    }
}