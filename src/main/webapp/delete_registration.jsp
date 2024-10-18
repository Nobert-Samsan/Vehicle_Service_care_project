<%@ page import="com.services.authentication.AuthenticationUtil" %>
<%@ page import="com.services.database.DatabaseConnection" %>
<%@ page import="java.sql.*" %>
<%@ include file="structure.jsp" %>

<%
    // Authentication check
    if (!AuthenticationUtil.isAuthenticated(request)) {
        response.sendRedirect("index.jsp");
        return;
    }

    String message = "";
    boolean redirect = false;

    // Process delete request
    if (request.getParameter("delete") != null && request.getParameter("bookingId") != null) {
        String bookingId = request.getParameter("bookingId");

        try (DatabaseConnection dbConnection = new DatabaseConnection();
             Connection connection = dbConnection.getConnection()) {

            connection.setAutoCommit(false);

            String deleteSQL = "DELETE FROM vehicle_service WHERE booking_id = ?";
            try (PreparedStatement ps = connection.prepareStatement(deleteSQL)) {
                ps.setString(1, bookingId);
                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    message = "success";
                    connection.commit();
                } else {
                    message = "failure";
                    connection.rollback();
                }

                redirect = true;
            } catch (SQLException e) {
                e.printStackTrace();
                message = "failure";
                connection.rollback();
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "failure";
        }
    }

    if (redirect) {
        response.sendRedirect("delete_registration.jsp?msg=" + message);
        return;
    }

    // Fetch reservations
    String username = (String) request.getSession().getAttribute("username");

    if (username == null || username.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    try (DatabaseConnection dbConnection = new DatabaseConnection();
         Connection connection = dbConnection.getConnection()) {

        String selectSQL = "SELECT * FROM vehicle_service WHERE username = ? AND date >= ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {
            preparedStatement.setString(1, username);
            preparedStatement.setDate(2, java.sql.Date.valueOf(java.time.LocalDate.now()));

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
%>
                <style>
                    /* CSS Styles */
                    body { font-family: Arial, sans-serif; background-color: #f4f4f4; }
                    h4 { color: #333; }
                    table { width: 80%; margin: 20px auto; border-collapse: collapse; background-color: #fff; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
                    th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
                    th { background-color: #333; color: #fff; }
                    button { background-color: #d9534f; color: white; padding: 8px 12px; border: none; border-radius: 3px; cursor: pointer; font-size: 14px; }
                    button:hover { background-color: #c9302c; }
                </style>

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
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    if (resultSet.next()) {
                        do {
                    %>
                        <tr>
                            <td><%= resultSet.getString("booking_id") %></td>
                            <td><%= resultSet.getString("date") %></td>
                            <td><%= resultSet.getString("time") %></td>
                            <td><%= resultSet.getString("location") %></td>
                            <td><%= resultSet.getString("vehicle_no") %></td>
                            <td><%= resultSet.getString("mileage") %></td>
                            <td><%= resultSet.getString("message") %></td>
                            <td>
                                <form action="delete_registration.jsp" method="post">
                                    <input type="hidden" name="bookingId" value="<%= resultSet.getString("booking_id") %>">
                                    <button type="submit" name="delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <%
                        } while (resultSet.next());
                    } else {
                    %>
                        <tr>
                            <td colspan="8" style="text-align:center;">No Upcoming Reservations found.</td>
                        </tr>
                    <%
                    }
                    %>
                    </tbody>
                </table>
<%
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
