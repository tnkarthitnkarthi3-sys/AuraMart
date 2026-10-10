package com.auramart.security;

import com.auramart.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebFilter("/*")
public class RoleFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS =
            Set.of(
                    "/",
                    "/index.html",
                    "/login.html",
                    "/register.html",
                    "/login",
                    "/register",
                    "/logout",
                    "/products"
            );


    @Override
    public void doFilter(
            ServletRequest servletRequest,
            ServletResponse servletResponse,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpServletRequest request =
                (HttpServletRequest) servletRequest;

        HttpServletResponse response =
                (HttpServletResponse) servletResponse;


        String contextPath =
                request.getContextPath();

        String uri =
                request.getRequestURI();

        String path =
                uri.substring(
                        contextPath.length()
                );


        // =====================================
        // STATIC RESOURCES
        // =====================================

        if (
                path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/uploads/")
                || path.startsWith("/favicon")
        ) {

            chain.doFilter(
                    servletRequest,
                    servletResponse
            );

            return;
        }


        // =====================================
        // PUBLIC
        // =====================================

        if (PUBLIC_PATHS.contains(path)) {

            chain.doFilter(
                    servletRequest,
                    servletResponse
            );

            return;
        }


        // =====================================
        // SESSION
        // =====================================

        HttpSession session =
                request.getSession(false);


        if (session == null) {

            response.sendRedirect(
                    contextPath
                    + "/login.html?error=login"
            );

            return;
        }


        Object userObject =
                session.getAttribute(
                        "loggedInUser"
                );


        if (!(userObject instanceof User)) {

            response.sendRedirect(
                    contextPath
                    + "/login.html?error=login"
            );

            return;
        }


        User user =
                (User) userObject;

        String role =
                user.getRole()
                        .toUpperCase();


        // =====================================
        // ADMIN
        // =====================================

        if (
                path.startsWith("/admin")
                || path.startsWith("/admin/")
        ) {

            if (!"ADMIN".equals(role)) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Admin access required"
                );

                return;
            }
        }


        // =====================================
        // SELLER
        // =====================================

        if (
                path.startsWith("/seller")
                || path.startsWith("/seller/")
        ) {

            if (!"SELLER".equals(role)) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Seller access required"
                );

                return;
            }
        }


        // =====================================
        // BUYER
        // =====================================

        if (
                path.startsWith("/buyer")
                || path.startsWith("/buyer/")
        ) {

            if (!"BUYER".equals(role)) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Buyer access required"
                );

                return;
            }
        }


        chain.doFilter(
                servletRequest,
                servletResponse
        );
    }
}
