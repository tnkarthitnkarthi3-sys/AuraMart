package com.auramart.dao;

import com.auramart.model.User;
import com.auramart.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public boolean registerUser(User user) {

        String sql = "INSERT INTO users (name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail().trim().toLowerCase());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("REGISTER ERROR:");
            e.printStackTrace();
            return false;
        }
    }

    public User loginUser(String email, String password) {

        System.out.println("================================");
        System.out.println("LOGIN DEBUG");
        System.out.println("Email = [" + email + "]");

        String sql =
            "SELECT id, name, email, password, phone, address " +
            "FROM users " +
            "WHERE email = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            System.out.println("DATABASE CONNECTION = SUCCESS");

            ps.setString(1, email.trim().toLowerCase());
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    System.out.println("USER FOUND = YES");
                    System.out.println("DB EMAIL = [" + rs.getString("email") + "]");

                    User user = new User(
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("address")
                    );

                    user.setId(rs.getInt("id"));

                    System.out.println("DB USER ID = " + user.getId());

                    return user;
                }

                System.out.println("USER FOUND = NO");
            }

        } catch (Exception e) {

            System.out.println("LOGIN DATABASE ERROR");
            e.printStackTrace();
        }

        System.out.println("================================");

        return null;
    }
}
