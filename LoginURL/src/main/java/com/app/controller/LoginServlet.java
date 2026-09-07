package com.app.controller;

import com.app.model.User;
import com.app.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is already logged in via session
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Check Cookie for "Remember Me"
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUser".equals(cookie.getName())) {
                    request.setAttribute("rememberedUser", cookie.getValue());
                    break;
                }
            }
        }

        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // === SERVER-SIDE VALIDATION ===
        Map<String, String> errors = new HashMap<>();

        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Vui lòng nhập tên đăng nhập");
        } else if (username.trim().length() < 3 || username.trim().length() > 50) {
            errors.put("username", "Tên đăng nhập phải từ 3 đến 50 ký tự");
        }

        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Vui lòng nhập mật khẩu");
        } else if (password.trim().length() < 3 || password.trim().length() > 50) {
            errors.put("password", "Mật khẩu phải từ 3 đến 50 ký tự");
        }

        // If validation errors, forward back to login
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // Attempt login
        User user = userService.login(username, password);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());

            // Handle "Remember Me" cookie
            if ("on".equals(remember)) {
                Cookie cookie = new Cookie("rememberedUser", user.getUsername());
                cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                cookie.setPath(request.getContextPath());
                response.addCookie(cookie);
            } else {
                // Remove cookie if unchecked
                Cookie cookie = new Cookie("rememberedUser", "");
                cookie.setMaxAge(0);
                cookie.setPath(request.getContextPath());
                response.addCookie(cookie);
            }

            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            // Login failed - show error inline on login page
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}
