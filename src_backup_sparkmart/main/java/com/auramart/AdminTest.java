package com.auramart;

public class AdminTest {

    public static void main(String[] args) {

        System.out.println("=================================");
        System.out.println("ADMIN DAO TEST");
        System.out.println("=================================");

        AdminDAO dao = new AdminDAO();

        Admin admin = dao.login("admin", "karthi2008");

        if (admin != null) {

            System.out.println("ADMIN LOGIN SUCCESS");
            System.out.println("ID       : " + admin.getId());
            System.out.println("NAME     : " + admin.getName());
            System.out.println("USERNAME : " + admin.getUsername());

        } else {

            System.out.println("ADMIN LOGIN FAILED");
        }

        System.out.println("=================================");
    }
}
