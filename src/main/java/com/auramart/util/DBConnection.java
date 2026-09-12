package com.auramart.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/auramart"
            + "?useSSL=false"
            + "&serverTimezone=Asia/Kolkata"
            + "&allowPublicKeyRetrieval=true";

    private static final String USER = "root";
    private static final String PASSWORD = "karthi2008";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("### MYSQL JDBC DRIVER LOADED ###");
        } catch (ClassNotFoundException e) {
            System.out.println("### MYSQL JDBC DRIVER NOT FOUND ###");
            e.printStackTrace();
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        System.out.println("### CONNECTING TO MYSQL ###");
        System.out.println("DB URL = " + URL);
        System.out.println("DB USER = " + USER);

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
