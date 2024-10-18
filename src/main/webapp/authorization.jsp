<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONObject" %>

<%
String authorizationCode = request.getParameter("code");
String sessionState = request.getParameter("session_state");
session.setAttribute("sessionState", sessionState);

if (authorizationCode == null || authorizationCode.isEmpty()) {
    out.println("Authorization code is missing.");
} else {
    Properties props = loadProperties("/WEB-INF/authorization.properties");
    if (props == null) {
        out.println("Failed to load properties.");
        return;
    }

    String clientId = props.getProperty("oauth.client_id");
    String clientSecret = props.getProperty("oauth.client_secret");
    String tokenEndpoint = props.getProperty("oauth.token_endpoint");
    String redirectUri = props.getProperty("oauth.redirect_uri");

    try {
        String tokenResponse = exchangeAuthorizationCodeForToken(authorizationCode, clientId, clientSecret, tokenEndpoint, redirectUri);
        if (tokenResponse != null) {
            processTokenResponse(tokenResponse, request);
            response.sendRedirect("home.jsp");
        } else {
            out.println("Failed to obtain access token.");
        }
    } catch (IOException e) {
        e.printStackTrace();
        out.println("An error occurred during token exchange.");
    }
}

%>

<%! 
// Load properties from a file
private Properties loadProperties(String path) {
    Properties properties = new Properties();
    try (InputStream input = getServletContext().getResourceAsStream(path)) {
        if (input == null) {
            return null;
        }
        properties.load(input);
    } catch (IOException e) {
        e.printStackTrace();
        return null;
    }
    return properties;
}

// Exchange the authorization code for an access token
private String exchangeAuthorizationCodeForToken(String authorizationCode, String clientId, String clientSecret, String tokenEndpoint, String redirectUri) throws IOException {
    String requestData = String.format("code=%s&grant_type=authorization_code&client_id=%s&client_secret=%s&redirect_uri=%s",
            authorizationCode, clientId, clientSecret, URLEncoder.encode(redirectUri, "UTF-8"));

    URL tokenUrl = new URL(tokenEndpoint);
    HttpURLConnection tokenConnection = (HttpURLConnection) tokenUrl.openConnection();
    tokenConnection.setRequestMethod("POST");
    tokenConnection.setDoOutput(true);

    try (DataOutputStream tokenOutputStream = new DataOutputStream(tokenConnection.getOutputStream())) {
        tokenOutputStream.writeBytes(requestData);
        tokenOutputStream.flush();
    }

    int tokenResponseCode = tokenConnection.getResponseCode();
    if (tokenResponseCode == HttpURLConnection.HTTP_OK) {
        try (BufferedReader tokenReader = new BufferedReader(new InputStreamReader(tokenConnection.getInputStream()))) {
            StringBuilder tokenResponse = new StringBuilder();
            String line;
            while ((line = tokenReader.readLine()) != null) {
                tokenResponse.append(line);
            }
            return tokenResponse.toString();
        }
    }
    return null;
}

// Process the token response and store tokens in session
private void processTokenResponse(String tokenResponse, HttpServletRequest request) {
    JSONObject jsonResponse = new JSONObject(tokenResponse);
    String access_token = jsonResponse.optString("access_token");
    String id_token = jsonResponse.optString("id_token");

    request.getSession().setAttribute("access_token", access_token);
    request.getSession().setAttribute("id_token", id_token);
}
%>
