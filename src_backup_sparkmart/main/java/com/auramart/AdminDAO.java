package com.auramart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.auramart.util.DBConnection;

public class AdminDAO {

    public Admin login(String username, String password) {

        Admin admin = null;

        String sql =
                "SELECT id, name, username, password " +
                "FROM admins " +
                "WHERE (username = ? OR email = ?) " +
                "AND password = ?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    admin = new Admin();

                    admin.setId(
                            rs.getInt("id")
                    );

                    admin.setName(
                            rs.getString("name")
                    );

                    admin.setUsername(
                            rs.getString("username")
                    );

                    admin.setPassword(
                            rs.getString("password")
                    );
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ADMIN LOGIN DATABASE ERROR"
            );

            e.printStackTrace();
        }

        return admin;
    }
}