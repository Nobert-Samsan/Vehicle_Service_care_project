<%@ page import="java.io.*, java.util.*" %>

<%
    // Load the properties file safely
    Properties props = new Properties();
    try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/authorization.properties")) {
        if (input == null) {
            throw new FileNotFoundException("Properties file not found");
        }
        props.load(input);
    } catch (IOException e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load authorization properties.");
        return;
    }

    // Construct the OAuth URL
    String authEndpoint = props.getProperty("oauth.auth_endpoint");
    String scope = props.getProperty("oauth.scope");
    String responseType = props.getProperty("oauth.response_type");
    String redirectUri = props.getProperty("oauth.redirect_uri");
    String clientId = props.getProperty("oauth.client_id");
    String oauthUrl = String.format("%s?scope=%s&response_type=%s&redirect_uri=%s&client_id=%s",
            authEndpoint, scope, responseType, redirectUri, clientId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-image: url('images/Car.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .login-page {
            display: flex;
            justify-content: flex-end;
            width: 100%;
            margin-right: 200px;
            align-items: center;
        }

        .form {
            background-color: #15305c;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            min-width: 350px;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 50px;
        }

        .login-header {
            text-align: center;
            color: #eee;
            margin-bottom: 20px;
        }

        .login-header h1 {
            font-size: 40px;
            margin: 0;
        }

        .login-header p {
            font-size: 16px;
        }

        .login-form {
            text-align: center;
            margin-top: 20px;
        }

        .login-form button {
            background-color: #1B1212;
            color: #eee;
            border: none;
            padding: 15px 30px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: background-color 0.3s ease;
        }

        .login-form button a {
            color: inherit;
            text-decoration: none;
        }

        .login-form button:hover {
            background-color: #333;
        }
    </style>
</head>
<body>
    <div class="login-page">
        <div class="form">
            <div class="login-header">
                <h1>Vehicle Service Care</h1>
                <p>Your Journey Begins Here</p>
            </div>
            <div class="login-form">
                <button>
                    <a href="<%= oauthUrl %>">Sign In</a>
                </button>
            </div>
        </div>
    </div>
</body>
</html>
