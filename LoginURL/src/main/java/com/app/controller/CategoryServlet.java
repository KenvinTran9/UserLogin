package com.app.controller;

import com.app.model.Category;
import com.app.service.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 10,        // 10 MB
        maxRequestSize = 1024 * 1024 * 50      // 50 MB
)
public class CategoryServlet extends HttpServlet {
    private CategoryService categoryService;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    public void init() throws ServletException {
        categoryService = new CategoryService();
    }

    /**
     * Get the upload directory path, create if not exists
     */
    private String getUploadPath(HttpServletRequest request) {
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        return uploadPath;
    }

    /**
     * Save uploaded file and return the relative path (uploads/filename)
     */
    private String saveFile(Part filePart, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        String originalName = getFileName(filePart);
        if (originalName == null || originalName.isEmpty()) {
            return null;
        }
        // Generate unique file name to avoid conflicts
        String extension = "";
        int dotIndex = originalName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = originalName.substring(dotIndex);
        }
        String uniqueName = UUID.randomUUID().toString() + extension;

        String uploadPath = getUploadPath(request);
        filePart.write(uploadPath + File.separator + uniqueName);

        return UPLOAD_DIR + "/" + uniqueName;
    }

    /**
     * Extract original file name from Part header
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.getRequestDispatcher("/views/category/add.jsp").forward(request, response);
                break;

            case "edit":
                String editId = request.getParameter("id");
                Category category = categoryService.getCategoryById(editId);
                if (category != null) {
                    request.setAttribute("category", category);
                    request.getRequestDispatcher("/views/category/edit.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/category?error=notfound");
                }
                break;

            case "delete":
                String deleteId = request.getParameter("id");
                categoryService.deleteCategory(deleteId);
                response.sendRedirect(request.getContextPath() + "/category?success=deleted");
                break;

            case "list":
            default:
                List<Category> categories = categoryService.getAllCategories();
                request.setAttribute("categories", categories);

                String success = request.getParameter("success");
                String error = request.getParameter("error");
                if (success != null) {
                    switch (success) {
                        case "added": request.setAttribute("message", "Thêm danh mục thành công!"); break;
                        case "updated": request.setAttribute("message", "Cập nhật danh mục thành công!"); break;
                        case "deleted": request.setAttribute("message", "Xóa danh mục thành công!"); break;
                    }
                }
                if (error != null) {
                    request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại!");
                }

                request.getRequestDispatcher("/views/category/list.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            // Handle image upload
            Part imagePart = request.getPart("image");
            String imagePath = saveFile(imagePart, request);

            // Handle file upload
            Part filePart = request.getPart("file");
            String filePath = saveFile(filePart, request);
            String fileName = (filePart != null && filePart.getSize() > 0) ? getFileName(filePart) : null;

            if (categoryService.addCategory(name, description, imagePath, filePath, fileName)) {
                response.sendRedirect(request.getContextPath() + "/category?success=added");
            } else {
                request.setAttribute("error", "Tên danh mục không được để trống!");
                request.getRequestDispatcher("/views/category/add.jsp").forward(request, response);
            }

        } else if ("update".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            // Handle image upload (null = keep old)
            Part imagePart = request.getPart("image");
            String imagePath = saveFile(imagePart, request);

            // Handle file upload (null = keep old)
            Part filePart = request.getPart("file");
            String filePath = saveFile(filePart, request);
            String fileName = (filePart != null && filePart.getSize() > 0) ? getFileName(filePart) : null;

            if (categoryService.updateCategory(id, name, description, imagePath, filePath, fileName)) {
                response.sendRedirect(request.getContextPath() + "/category?success=updated");
            } else {
                request.setAttribute("error", "Cập nhật thất bại! Kiểm tra lại thông tin.");
                Category category = categoryService.getCategoryById(id);
                request.setAttribute("category", category);
                request.getRequestDispatcher("/views/category/edit.jsp").forward(request, response);
            }
        }
    }
}
