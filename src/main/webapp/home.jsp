<%@include file="structure.jsp"%>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%@ page import="org.json.JSONObject" %>
<%
    // Extract the access token and id token from session
    String accessToken = (String) request.getSession().getAttribute("access_token");
    String idToken = (String) request.getSession().getAttribute("id_token");

    // Check if the access token is present
    if (accessToken == null || accessToken.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Load properties from authorization.properties file
    Properties props = new Properties();
    try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/authorization.properties")) {
        if (input == null) {
            throw new IOException("Authorization properties file not found.");
        }
        props.load(input);
    } catch (IOException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load authorization properties.");
        return;
    }

    // Get the user info endpoint URL from properties
    String userinfoEndpoint = props.getProperty("oauth.userinfo_endpoint");
    String username = "";
    String name = "";
    String email = "";
    String contactNumber = "";
    String country = "";

    // Fetch user information
    try {
        JSONObject userinfoJson = fetchUserInfo(userinfoEndpoint, accessToken);

        // Extract user details from the response JSON
        username = userinfoJson.optString("username");
        name = userinfoJson.optString("given_name");
        email = userinfoJson.optString("email");
        contactNumber = userinfoJson.optString("phone_number");
        JSONObject addressObject = userinfoJson.optJSONObject("address");
        country = (addressObject != null) ? addressObject.optString("country") : "";

        // Set username in the session
        session.setAttribute("username", username);
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <style>
        .profile-info {
            max-width: 600px;
            margin: 50px auto;
            background-color: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
        }

        .info-pair {
            margin-bottom: 15px;
        }

        .info-label {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .info-value {
            color: #d9534f;
        }
    </style>
</head>
<body>
<div class="profile-info">
    <h2 align="center">Profile</h2>

    <div class="info-pair">
        <p class="info-label">USERNAME</p>
        <h4 class="info-value"><%= username %></h4>
    </div>

    <div class="info-pair">
        <p class="info-label">NAME</p>
        <h4 class="info-value"><%= name %></h4>
    </div>

    <div class="info-pair">
        <p class="info-label">EMAIL</p>
        <h4 class="info-value"><%= email %></h4>
    </div>

    <div class="info-pair">
        <p class="info-label">CONTACT NO</p>
        <h4 class="info-value"><%= contactNumber %></h4>
    </div>

    <div class="info-pair">
        <p class="info-label">COUNTRY</p>
        <h4 class="info-value"><%= country %></h4>
    </div>
</div>
</body>
</html>

<%
    // Utility method to fetch user information
    private JSONObject fetchUserInfo(String endpoint, String accessToken) throws IOException {
        HttpURLConnection connection = null;
        try {
            URL url = new URL(endpoint);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Authorization", "Bearer " + accessToken);

            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                throw new IOException("Failed to fetch user info: HTTP " + responseCode);
            }

            try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                return new JSONObject(response.toString());
            }
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
%>
