package com.auramart.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.auramart.model.User;
import com.auramart.util.DBConnection;

public class UserDAO {

// ================================
// REGISTER USER
// ================================

public boolean registerUser(User user) {

    String sql =
        "INSERT INTO users (name, email, password, phone, address) " +
        "VALUES (?, ?, ?, ?, ?)";

    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement =
            connection.prepareStatement(sql)
    ) {

        statement.setString(1, user.getName());
        statement.setString(2, user.getEmail());
        statement.setString(3, user.getPassword());
        statement.setString(4, user.getPhone());
        statement.setString(5, user.getAddress());

        int rows = statement.executeUpdate();

        return rows > 0;

    } catch (SQLException e) {

        e.printStackTrace();

        return false;
    }
}


// ================================
// LOGIN USER
// ================================

public User loginUser(String email, String password) {

    String sql =
        "SELECT id, name, email, password, phone, address " +
        "FROM users " +
        "WHERE email = ? AND password = ?";

    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement =
            connection.prepareStatement(sql)
    ) {

        statement.setString(1, email);
        statement.setString(2, password);

        try (ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {

                User user = new User(
                    resultSet.getString("name"),
                    resultSet.getString("email"),
                    resultSet.getString("password"),
                    resultSet.getString("phone"),
                    resultSet.getString("address")
                );

                return user;
            }
        }

    } catch (SQLException e) {

        e.printStackTrace();
    }

    return null;
}


}
