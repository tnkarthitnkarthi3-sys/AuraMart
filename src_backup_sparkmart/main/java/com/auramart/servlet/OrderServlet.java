package com.auramart.servlet;

import com.auramart.dao.OrderDAO;
import com.auramart.model.Order;
import com.auramart.model.OrderItem;
import com.auramart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/place-order")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        System.out.println("========================================");
        System.out.println("AURAMART PLACE ORDER REQUEST");
        System.out.println("URI = " + request.getRequestURI());
        System.out.println("SESSION ID = " +
                (session == null ? "NULL" : session.getId()));

        if (session == null) {
            System.out.println("ORDER ERROR: SESSION IS NULL");
            response.sendRedirect("login.html?error=login");
            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        System.out.println("SESSION USER = " + user);

        if (user == null) {
            System.out.println("ORDER ERROR: loggedInUser IS NULL");
            response.sendRedirect("login.html?error=login");
            return;
        }

        System.out.println("ORDER USER ID = " + user.getId());
        System.out.println("ORDER USER EMAIL = " + user.getEmail());

        try {

            String subtotalParam =
                    request.getParameter("subtotal");

            String deliveryParam =
                    request.getParameter("deliveryCharge");

            String serviceParam =
                    request.getParameter("serviceCharge");

            String totalParam =
                    request.getParameter("totalAmount");

            String address =
                    request.getParameter("deliveryAddress");

            if (subtotalParam == null ||
                deliveryParam == null ||
                serviceParam == null ||
                totalParam == null ||
                address == null ||
                address.trim().isEmpty()) {

                System.out.println("ORDER ERROR: INVALID ORDER DATA");
                response.sendRedirect("cart.html?error=invalid");
                return;
            }

            BigDecimal subtotal =
                    new BigDecimal(subtotalParam);

            BigDecimal deliveryCharge =
                    new BigDecimal(deliveryParam);

            BigDecimal serviceCharge =
                    new BigDecimal(serviceParam);

            BigDecimal totalAmount =
                    new BigDecimal(totalParam);

            String[] productIds =
                    request.getParameterValues("productId");

            String[] quantities =
                    request.getParameterValues("quantity");

            String[] prices =
                    request.getParameterValues("price");

            if (productIds == null ||
                quantities == null ||
                prices == null ||
                productIds.length == 0) {

                System.out.println("ORDER ERROR: CART ITEMS EMPTY");
                response.sendRedirect("cart.html?error=empty");
                return;
            }

            List<OrderItem> items = new ArrayList<>();

            for (int i = 0; i < productIds.length; i++) {

                OrderItem item = new OrderItem();

                item.setProductId(
                        Integer.parseInt(productIds[i])
                );

                item.setQuantity(
                        Integer.parseInt(quantities[i])
                );

                item.setPrice(
                        new BigDecimal(prices[i])
                );

                items.add(item);
            }

            Order order = new Order();

            order.setUserId(user.getId());
            order.setSubtotal(subtotal);
            order.setDeliveryCharge(deliveryCharge);
            order.setServiceCharge(serviceCharge);
            order.setTotalAmount(totalAmount);
            order.setDeliveryAddress(address.trim());
            order.setStatus("PLACED");

            System.out.println("CREATING ORDER...");
            System.out.println("ITEM COUNT = " + items.size());

            int orderId =
                    orderDAO.createOrder(order, items);

            System.out.println(
                    "ORDER CREATED SUCCESSFULLY - ID = "
                    + orderId
            );

            System.out.println("REDIRECTING TO ORDERS");

            response.sendRedirect(
                    request.getContextPath()
                    + "/orders.html?success=true"
            );

        } catch (Exception e) {

            System.out.println("ORDER DATABASE ERROR");
            e.printStackTrace();

            response.sendRedirect(
                    "cart.html?error=database"
            );
        }

        System.out.println("========================================");
    }
}
