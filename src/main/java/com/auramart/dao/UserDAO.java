package com.auramart.dao;

import com.auramart.model.User;
import com.auramart.security.PasswordUtil;
import com.auramart.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    // ==========================================
    // REGISTER
    // ==========================================

    public boolean registerUser(User user) {

        String sql =
                "INSERT INTO users " +
                "(name, email, password, phone, address, role) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    user.getName()
            );

            statement.setString(
                    2,
                    user.getEmail()
            );

            statement.setString(
                    3,
                    PasswordUtil.hash(
                            user.getPassword()
                    )
            );

            statement.setString(
                    4,
                    user.getPhone()
            );

            statement.setString(
                    5,
                    user.getAddress()
            );

            // PUBLIC REGISTRATION = BUYER ONLY
            statement.setString(
                    6,
                    "BUYER"
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }


    // ==========================================
    // EMAIL EXISTS
    // ==========================================

    public boolean emailExists(String email) {

        String sql =
                "SELECT id FROM users WHERE email = ? LIMIT 1";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(1, email);

            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                return rs.next();
            }

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }


    // ==========================================
    // LOGIN
    // ==========================================

    public User loginUser(
            String email,
            String password
    ) {

        String sql =
                "SELECT id, name, email, password, " +
                "phone, address, role " +
                "FROM users " +
                "WHERE email = ? LIMIT 1";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    email
            );

            try (
                    ResultSet rs =
                            statement.executeQuery()
            ) {

                if (!rs.next()) {
                    return null;
                }

                String storedPassword =
                        rs.getString("password");

                String suppliedPassword =
                        password;

                /*
                 * New accounts use SHA-256.
                 *
                 * Existing old accounts may contain
                 * plain passwords. This keeps old accounts
                 * working during migration.
                 */

                boolean passwordCorrect;

                if (
                        PasswordUtil.looksHashed(
                                storedPassword
                        )
                ) {

                    passwordCorrect =
                            storedPassword.equals(
                                    PasswordUtil.hash(
                                            suppliedPassword
                                    )
                            );

                } else {

                    passwordCorrect =
                            storedPassword.equals(
                                    suppliedPassword
                            );

                    /*
                     * Upgrade old password to hash
                     * after successful login.
                     */
                    if (passwordCorrect) {

                        updatePassword(
                                rs.getInt("id"),
                                PasswordUtil.hash(
                                        suppliedPassword
                                )
                        );
                    }
                }

                if (!passwordCorrect) {
                    return null;
                }

                User user =
                        new User();

                user.setId(
                        rs.getInt("id")
                );

                user.setName(
                        rs.getString("name")
                );

                user.setEmail(
                        rs.getString("email")
                );

                user.setPassword(
                        storedPassword
                );

                user.setPhone(
                        rs.getString("phone")
                );

                user.setAddress(
                        rs.getString("address")
                );

                String role =
                        rs.getString("role");

                if (
                        role == null ||
                        role.trim().isEmpty()
                ) {
                    role = "BUYER";
                }

                user.setRole(
                        role.toUpperCase()
                );

                return user;
            }

        } catch (Exception e) {

            e.printStackTrace();

            return null;
        }
    }


    // ==========================================
    // UPDATE PASSWORD
    // ==========================================

    private boolean updatePassword(
            int userId,
            String hashedPassword
    ) {

        String sql =
                "UPDATE users SET password = ? " +
                "WHERE id = ?";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    hashedPassword
            );

            statement.setInt(
                    2,
                    userId
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }

    // ==========================================
    // FIND USER BY ID
    // ==========================================

    public User getUserById(int userId) {

        String sql =
                "SELECT id, name, email, password, phone, address, role " +
                "FROM users WHERE id = ? LIMIT 1";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setInt(1, userId);

            try (ResultSet rs = statement.executeQuery()) {

                if (!rs.next()) {
                    return null;
                }

                User user = new User();

                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));

                return user;
            }

        } catch (Exception e) {

            e.printStackTrace();
            return null;
        }
    }


    // ==========================================
    // UPDATE PROFILE
    // ==========================================

    public boolean updateProfile(
            int userId,
            String name,
            String phone,
            String address
    ) {

        String sql =
                "UPDATE users " +
                "SET name = ?, phone = ?, address = ? " +
                "WHERE id = ?";

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(sql)
        ) {

            statement.setString(1, name);
            statement.setString(2, phone);
            statement.setString(3, address);
            statement.setInt(4, userId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
            return false;
        }
    }
}
