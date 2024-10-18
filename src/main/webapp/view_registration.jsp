<%@ page import="com.services.authentication.AuthenticationUtil" %>
<%@ page import="com.services.database.DatabaseConnection" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="structure.jsp" %>

<%
    if (!AuthenticationUtil.isAuthenticated(request)) {
        response.sendRedirect("index.jsp"); // Redirect to login if not authenticated
        return;
    }

    String username = (String) request.getSession().getAttribute("username");
    List<Map<String, String>> reservations = new ArrayList<>();
    try (Connection connection = new DatabaseConnection().getConnection();
         PreparedStatement ps = connection.prepareStatement("SELECT * FROM vehicle_service WHERE username=?")) {
        
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> reservation = new HashMap<>();
                reservation.put("bookingId", rs.getString(1));
                reservation.put("date", rs.getString(2));
                reservation.put("time", rs.getString(3));
                reservation.put("location", rs.getString(4));
                reservation.put("vehicleNumber", rs.getString(5));
                reservation.put("mileage", rs.getString(6));
                reservation.put("message", rs.getString(7));
                reservations.add(reservation);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace(); // Proper error logging
    }
%>

<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        h4 {
            color: #333;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #333;
            color: #fff;
        }

        .no-reservation {
            text-align: center;
            color: #666;
            margin: 20px auto;
        }
    </style>
</head>
<body>

<% if (!reservations.isEmpty()) { %>
    <table>
        <thead>
            <tr>
                <th>Booking ID</th>
                <th>Date</th>
                <th>Time</th>
                <th>Location</th>
                <th>Vehicle Number</th>
                <th>Mileage</th>
                <th>Message</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="reservation" items="${reservations}">
                <tr>
                    <td>${reservation.bookingId}</td>
                    <td>${reservation.date}</td>
                    <td>${reservation.time}</td>
                    <td>${reservation.location}</td>
                    <td>${reservation.vehicleNumber}</td>
                    <td>${reservation.mileage}</td>
                    <td>${reservation.message}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
<% } else { %>
    <p class="no-reservation">No reservations found.</p>
<% } %>

</body>
</html>
