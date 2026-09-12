package com.auramart.servlet;

import com.auramart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/session-check")
public class SessionServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            response.getWriter().print(
                "{\"loggedIn\":false}"
            );
            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        if (user == null) {

            response.getWriter().print(
                "{\"loggedIn\":false}"
            );

            return;
        }

        response.getWriter().print(
            "{"
            + "\"loggedIn\":true,"
            + "\"id\":" + user.getId() + ","
            + "\"name\":\"" + escape(user.getName()) + "\","
            + "\"email\":\"" + escape(user.getEmail()) + "\""
            + "}"
        );
    }

    private String escape(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }
}