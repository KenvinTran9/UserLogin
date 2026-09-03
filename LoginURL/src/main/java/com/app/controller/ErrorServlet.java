package com.app.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "ErrorServlet", urlPatterns = {"/error"})
public class ErrorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = request.getParameter("message");
        if (message == null || message.isEmpty()) {
            message = "Tên đăng nhập hoặc mật khẩu không đúng!";
        }
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }
}
