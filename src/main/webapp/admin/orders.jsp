<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.auramart.model.Order" %>

<%
List<Order> orders =
    (List<Order>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>AuraMart - Admin Order Management</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f5f7fb;
    color: #111827;
}

.header {
    background: #111827;
    color: white;
    min-height: 65px;
    padding: 0 28px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.brand {
    font-size: 23px;
    font-weight: 700;
}

.admin-title {
    font-size: 14px;
    color: #d1d5db;
}

.container {
    max-width: 1450px;
    margin: 25px auto;
    padding: 0 20px;
}

.top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
}

.top h2 {
    margin: 0;
    font-size: 26px;
}

.top p {
    margin: 6px 0 0;
    color: #6b7280;
}

.back-btn {
    background: #2563eb;
    color: white;
    padding: 11px 18px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
}

.back-btn:hover {
    background: #1d4ed8;
}

.table-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 3px 15px rgba(0,0,0,0.07);
}

.table-wrapper {
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 1050px;
    border-collapse: collapse;
}

th {
    background: #1f2937;
    color: white;
    padding: 13px;
    text-align: left;
    font-size: 13px;
}

td {
    padding: 13px;
    border-bottom: 1px solid #eef0f3;
    font-size: 14px;
    vertical-align: middle;
}

tr:hover td {
    background: #f9fafb;
}

.order-id {
    font-weight: 700;
}

.customer {
    font-weight: 700;
}

.email {
    color: #6b7280;
    font-size: 13px;
    margin-top: 3px;
}

.amount {
    font-weight: 700;
}

.status {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
    background: #dcfce7;
    color: #15803d;
}

.empty {
    text-align: center;
    padding: 60px 20px;
    color: #6b7280;
}

.empty-icon {
    font-size: 42px;
    margin-bottom: 10px;
}

@media(max-width:800px) {

    .header {
        padding: 15px;
    }

    .admin-title {
        display: none;
    }

    .container {
        padding: 0 10px;
    }

    .top {
        align-items: flex-start;
        gap: 10px;
    }

    .top h2 {
        font-size: 21px;
    }

}

</style>

</head>

<body>

<header class="header">

    <div class="brand">
        AuraMart Admin
    </div>

    <div class="admin-title">
        Order Management
    </div>

</header>

<div class="container">

    <div class="top">

        <div>
            <h2>Order Management</h2>
            <p>View all customer orders placed through AuraMart.</p>
        </div>

        <a
            href="<%= request.getContextPath() %>/admin/products"
            class="back-btn">
            Manage Products
        </a>

    </div>

    <div class="table-card">

        <div class="table-wrapper">

            <table>

                <thead>

                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Order Date</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                    </tr>

                </thead>

                <tbody>

                <%
                if (orders != null && !orders.isEmpty()) {

                    for (Order order : orders) {
                %>

                    <tr>

                        <td>
                            <span class="order-id">
                                #<%= order.getId() %>
                            </span>
                        </td>

                        <td>

                            <div class="customer">
                                <%= order.getUserId() %>
                            </div>

                        </td>

                        <td>
                            <%= order.getCreatedAt() %>
                        </td>

                        <td>

                            <span class="amount">
                                â‚¹<%= order.getTotalAmount() %>
                            </span>

                        </td>

                        <td>

                            <span class="status">
                                <%= order.getStatus() %>
                            </span>

                        </td>

                    </tr>

                <%
                    }

                } else {
                %>

                    <tr>

                        <td colspan="5" class="empty">

                            <div class="empty-icon">
                                ðŸ“¦
                            </div>

                            <strong>No orders found.</strong>

                            <div style="margin-top:8px;">
                                Customer orders will appear here after checkout.
                            </div>

                        </td>

                    </tr>

                <%
                }
                %>

                </tbody>

            </table>

        </div>

    </div>

</div>

</body>
</html>

