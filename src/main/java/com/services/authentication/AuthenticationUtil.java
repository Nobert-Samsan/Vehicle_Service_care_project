package com.services.authentication;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

public class AuthenticationUtil {
    private static final String USERNAME_ATTRIBUTE = "username";

    public static boolean isAuthenticated(HttpServletRequest request) {
        // Use Optional to avoid potential NullPointerExceptions
        return Optional.ofNullable(request.getSession(false))
                       .map(session -> session.getAttribute(USERNAME_ATTRIBUTE) != null)
                       .orElse(false);
    }
}

