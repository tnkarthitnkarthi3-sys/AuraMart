package com.auramart.controller;

import com.auramart.dao.UserDAO;
import com.auramart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO =
            new UserDAO();


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name =
                clean(request.getParameter("name"));

        String email =
                clean(request.getParameter("email"))
                        .toLowerCase();

        String password =
                request.getParameter("password");

        String phone =
                clean(request.getParameter("phone"));

        String address =
                clean(request.getParameter("address"));


        // =====================================
        // VALIDATION
        // =====================================

        if (
                name.isEmpty() ||
                email.isEmpty() ||
                password == null ||
                password.length() < 6
        ) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.html?error=validation"
            );

            return;
        }


        if (
                !email.matches(
                        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
                )
        ) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.html?error=email"
            );

            return;
        }


        if (
                userDAO.emailExists(email)
        ) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.html?error=exists"
            );

            return;
        }


        // =====================================
        // CREATE BUYER
        // =====================================

        User user =
                new User();

        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setAddress(address);

        // NEVER trust public role input
        user.setRole("BUYER");


        boolean success =
                userDAO.registerUser(user);


        if (success) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.html?registered=true"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.html?error=failed"
            );
        }
    }


    private String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }
}
