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

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        System.out.println("===== REGISTER REQUEST =====");
        System.out.println("Name    : " + name);
        System.out.println("Email   : " + email);
        System.out.println("Phone   : " + phone);
        System.out.println("Address : " + address);

        if (name == null || email == null || password == null) {
            response.sendRedirect("register.html?error=invalid");
            return;
        }

        name = name.trim();
        email = email.trim().toLowerCase();

        if (name.isEmpty() || email.isEmpty() || password.isEmpty()) {
            response.sendRedirect("register.html?error=invalid");
            return;
        }

        User user = new User(
                name,
                email,
                password,
                phone,
                address
        );

        boolean registered = userDAO.registerUser(user);

        System.out.println("Register result: " + registered);

        if (registered) {

            System.out.println("USER REGISTERED SUCCESSFULLY");

            response.sendRedirect("login.html?registered=true");

        } else {

            System.out.println("USER REGISTRATION FAILED");

            response.sendRedirect("register.html?error=failed");
        }
    }
}

