package com.auramart.controller;

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

    private final UserDAO userDAO =
            new UserDAO();


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email =
                clean(
                        request.getParameter("email")
                ).toLowerCase();

        String password =
                request.getParameter("password");


        // =====================================
        // VALIDATION
        // =====================================

        if (
                email.isEmpty() ||
                password == null ||
                password.isEmpty()
        ) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.html?error=validation"
            );

            return;
        }


        // =====================================
        // AUTHENTICATE
        // =====================================

        User user =
                userDAO.loginUser(
                        email,
                        password
                );


        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.html?error=invalid"
            );

            return;
        }


        // =====================================
        // SESSION FIXATION PROTECTION
        // =====================================

        HttpSession oldSession =
                request.getSession(false);

        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session =
                request.getSession(true);


        // =====================================
        // SESSION DATA
        // =====================================

        session.setAttribute(
                "loggedInUser",
                user
        );

        session.setAttribute(
                "userId",
                user.getId()
        );

        session.setAttribute(
                "userName",
                user.getName()
        );

        session.setAttribute(
                "userEmail",
                user.getEmail()
        );

        session.setAttribute(
                "userRole",
                user.getRole()
        );


        // =====================================
        // SESSION TIMEOUT
        // =====================================

        session.setMaxInactiveInterval(
                30 * 60
        );


        // =====================================
        // ROLE REDIRECT
        // =====================================

        String role =
                user.getRole()
                        .toUpperCase();


        switch (role) {

            case "ADMIN":

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-dashboard.html"
                );

                break;


            case "SELLER":

                response.sendRedirect(
                        request.getContextPath()
                        + "/seller/dashboard.html"
                );

                break;


            case "BUYER":

            default:

                response.sendRedirect(
                        request.getContextPath()
                        + "/products"
                );

                break;
        }
    }


    private String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }
}
