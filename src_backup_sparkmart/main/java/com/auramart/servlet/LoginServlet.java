package com.auramart.servlet;

import com.auramart.Admin;
import com.auramart.AdminDAO;
import com.auramart.dao.UserDAO;
import com.auramart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("=================================");
        System.out.println("UNIFIED LOGIN REQUEST");
        System.out.println("EMAIL = [" + email + "]");
        System.out.println("=================================");

        if (email == null ||
            password == null ||
            email.trim().isEmpty() ||
            password.trim().isEmpty()) {

            response.sendRedirect("login.html?error=invalid");
            return;
        }

        email = email.trim().toLowerCase();
        password = password.trim();


        /*
         * =========================================
         * STEP 1: ADMIN LOGIN
         * =========================================
         *
         * Admin does NOT need customer registration.
         */

        Admin admin = adminDAO.login(email, password);

        if (admin != null) {

            System.out.println(
                    "ADMIN LOGIN SUCCESS"
            );

            HttpSession session =
                    request.getSession(true);

            session.setAttribute(
                    "admin",
                    admin
            );

            session.removeAttribute(
                    "loggedInUser"
            );

            System.out.println(
                    "ADMIN SESSION ID = "
                    + session.getId()
            );

            response.sendRedirect(
                    "admin-dashboard.html"
            );

            return;
        }


        /*
         * =========================================
         * STEP 2: CUSTOMER LOGIN
         * =========================================
         */

        User user =
                userDAO.loginUser(
                        email,
                        password
                );

        if (user != null) {

            System.out.println(
                    "CUSTOMER LOGIN SUCCESS"
            );

            HttpSession session =
                    request.getSession(true);

            session.setAttribute(
                    "loggedInUser",
                    user
            );

            session.removeAttribute(
                    "admin"
            );

            String checkout =
                    request.getParameter(
                            "checkout"
                    );

            if ("true".equalsIgnoreCase(checkout)) {

                response.sendRedirect(
                        "cart.html"
                );

            } else {

                response.sendRedirect(
                        "products"
                );
            }

            return;
        }


        /*
         * =========================================
         * STEP 3: LOGIN FAILED
         * =========================================
         */

        System.out.println(
                "LOGIN FAILED"
        );

        response.sendRedirect(
                "login.html?error=invalid"
        );
    }
}