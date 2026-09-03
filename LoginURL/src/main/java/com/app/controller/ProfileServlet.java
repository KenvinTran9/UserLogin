package com.app.controller;

import com.app.model.User;
import com.app.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 10,        // 10 MB
        maxRequestSize = 1024 * 1024 * 50      // 50 MB
)
public class ProfileServlet extends HttpServlet {
    private UserService userService;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get fresh user data from DB
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            User user = userService.findById(userId);
            if (user != null) {
                request.setAttribute("user", user);
                session.setAttribute("user", user);
                session.setAttribute("fullName", user.getFullName());
            }
        }

        // Check for success message
        String success = request.getParameter("success");
        if ("updated".equals(success)) {
            request.setAttribute("message", "Cập nhật profile thành công!");
        }

        request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        // Handle image upload
        Part imagePart = request.getPart("image");
        String imagePath = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            imagePath = saveFile(imagePart, request);
        }

        // Update profile
        User updatedUser = userService.updateProfile(userId, fullName, phone, imagePath);

        if (updatedUser != null) {
            // Update session with new data
            session.setAttribute("user", updatedUser);
            session.setAttribute("fullName", updatedUser.getFullName());
            response.sendRedirect(request.getContextPath() + "/profile?success=updated");
        } else {
            request.setAttribute("error", "Cập nhật profile thất bại!");
            User user = userService.findById(userId);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
        }
    }

    private String saveFile(Part filePart, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        String originalName = getFileName(filePart);
        if (originalName == null || originalName.isEmpty()) {
            return null;
        }
        String extension = "";
        int dotIndex = originalName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = originalName.substring(dotIndex);
        }
        String uniqueName = UUID.randomUUID().toString() + extension;

        String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        filePart.write(uploadPath + File.separator + uniqueName);

        return UPLOAD_DIR + "/" + uniqueName;
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
