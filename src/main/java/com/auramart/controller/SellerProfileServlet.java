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

@WebServlet("/seller/profile")
public class SellerProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.html"
            );
            return;
        }

        Object loggedInUser =
                session.getAttribute("loggedInUser");

        if (!(loggedInUser instanceof User)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.html"
            );
            return;
        }

        User sessionUser =
                (User) loggedInUser;

        if (!"SELLER".equalsIgnoreCase(
                sessionUser.getRole())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Seller access required"
            );
            return;
        }

        User user =
                userDAO.getUserById(
                        sessionUser.getId()
                );

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "User not found"
            );
            return;
        }

        request.setAttribute(
                "sellerUser",
                user
        );

        request.getRequestDispatcher(
                "/seller/profile.jsp"
        ).forward(request, response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.html"
            );
            return;
        }

        Object loggedInUser =
                session.getAttribute("loggedInUser");

        if (!(loggedInUser instanceof User)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.html"
            );
            return;
        }

        User sessionUser =
                (User) loggedInUser;

        if (!"SELLER".equalsIgnoreCase(
                sessionUser.getRole())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Seller access required"
            );
            return;
        }

        String name =
                request.getParameter("name");

        String phone =
                request.getParameter("phone");

        String address =
                request.getParameter("address");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute(
                    "error",
                    "Name is required."
            );
            doGet(request, response);
            return;
        }

        boolean updated =
                userDAO.updateProfile(
                        sessionUser.getId(),
                        name.trim(),
                        phone == null ? "" : phone.trim(),
                        address == null ? "" : address.trim()
                );

        if (updated) {

            User updatedUser =
                    userDAO.getUserById(
                            sessionUser.getId()
                    );

            session.setAttribute(
                    "loggedInUser",
                    updatedUser
            );

            session.setAttribute(
                    "userName",
                    updatedUser.getName()
            );

            session.setAttribute(
                    "userEmail",
                    updatedUser.getEmail()
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/seller/profile?success=true"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/seller/profile?error=true"
            );
        }
    }
}