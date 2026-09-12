package com.auramart.util;

import java.sql.Connection;

public class DBTest {

    public static void main(String[] args) {

        try (Connection connection = DBConnection.getConnection()) {

            if (connection != null && !connection.isClosed()) {
                System.out.println("=================================");
                System.out.println("AURAMART DATABASE CONNECTED");
                System.out.println("MySQL Connection: SUCCESS");
                System.out.println("Database: auramart");
                System.out.println("=================================");
            }

        } catch (Exception e) {
            System.out.println("=================================");
            System.out.println("DATABASE CONNECTION FAILED");
            System.out.println("=================================");
            e.printStackTrace();
        }
    }
}