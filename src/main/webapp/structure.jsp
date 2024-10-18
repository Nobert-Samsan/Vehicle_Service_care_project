<% 
    String sessionState = (String) session.getAttribute("sessionState"); 
    String clientId = "Xy3JSmvWQAKLtgPc9plGJ72doa7b";
    String postLogoutRedirectUri = "http://localhost:8082/Vehicle_Service_Care/index.jsp";
    String logoutUrl = "https://api.asgardeo.io/t/samsan/oidc/logout";
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #333;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #000;
            display: flex;
            justify-content: space-around;
            align-items: center;
            padding: 10px;
        }

        .nav-link {
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            margin: 0 20px;
            padding: 5px 10px;
            border-radius: 3px;
        }

        .nav-link.active {
            background-color: #555;
        }

        #logout-btn {
            background-color: #d9534f;
            color: #fff;
            padding: 8px 12px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
        }

        #logout-btn:hover {
            background-color: #c9302c;
        }
    </style>
</head>

<body>
    <div class="navbar">
        <a class="nav-link" href="home.jsp">Profile</a>
        <a class="nav-link" href="service_registration.jsp">Add Reservation</a>
        <a class="nav-link" href="delete_registration.jsp">Upcoming Reservations</a>
        <a class="nav-link" href="view_registration.jsp">View All</a>
        <form id="logout-form" action="<%= logoutUrl %>" method="POST">
            <input type="hidden" name="client_id" value="<%= clientId %>">
            <input type="hidden" name="post_logout_redirect_uri" value="<%= postLogoutRedirectUri %>">
            <input type="hidden" name="state" value="<%= sessionState %>">
            <button id="logout-btn" type="submit">Logout</button>
        </form>
    </div>

    <!-- Additional content can go here -->

</body>

</html>
