package com.auramart;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("=================================");
        System.out.println("ADMIN LOGIN ATTEMPT");
        System.out.println("Username: " + username);
        System.out.println("=================================");

        Admin admin = adminDAO.login(username, password);

        if (admin != null) {

            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);

            System.out.println("ADMIN LOGIN SUCCESS: " + admin.getUsername());

            response.sendRedirect("admin-dashboard.html");

        } else {

            System.out.println("ADMIN LOGIN FAILED");

            response.sendRedirect("admin-login.html?error=invalid");
        }
    }
}
