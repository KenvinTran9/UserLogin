package com.app.controller;

import com.app.model.Category;
import com.app.service.CategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 10,        // 10 MB
        maxRequestSize = 1024 * 1024 * 50      // 50 MB
)
public class CategoryServlet extends HttpServlet {
    private CategoryService categoryService;
    private static final String UPLOAD_DIR = "uploads";
    private static final List<String> ALLOWED_IMAGE_TYPES = Arrays.asList(
            "image/jpeg", "image/png", "image/gif", "image/jpg"
    );
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

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

    /**
     * Validate category form fields
     */
    private Map<String, String> validateCategoryForm(String name, String description,
                                                      Part imagePart, Part filePart) {
        Map<String, String> errors = new HashMap<>();

        // Validate name (required, 2-100 chars)
        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Tên danh mục không được để trống");
        } else if (name.trim().length() < 2) {
            errors.put("name", "Tên danh mục phải có ít nhất 2 ký tự");
        } else if (name.trim().length() > 100) {
            errors.put("name", "Tên danh mục không được vượt quá 100 ký tự");
        }

        // Validate description (max 500 chars)
        if (description != null && description.trim().length() > 500) {
            errors.put("description", "Mô tả không được vượt quá 500 ký tự");
        }

        // Validate image file (type + size)
        if (imagePart != null && imagePart.getSize() > 0) {
            String contentType = imagePart.getContentType();
            if (!ALLOWED_IMAGE_TYPES.contains(contentType)) {
                errors.put("image", "Chỉ chấp nhận file ảnh JPG, PNG, GIF");
            }
            if (imagePart.getSize() > MAX_FILE_SIZE) {
                errors.put("image", "Ảnh không được vượt quá 10MB");
            }
        }

        // Validate attached file (size)
        if (filePart != null && filePart.getSize() > 0) {
            if (filePart.getSize() > MAX_FILE_SIZE) {
                errors.put("file", "File đính kèm không được vượt quá 10MB");
            }
        }

        return errors;
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
            Part imagePart = request.getPart("image");
            Part filePart = request.getPart("file");

            // === SERVER-SIDE VALIDATION ===
            Map<String, String> errors = validateCategoryForm(name, description, imagePart, filePart);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("name", name);
                request.setAttribute("description", description);
                request.getRequestDispatcher("/views/category/add.jsp").forward(request, response);
                return;
            }

            // Handle image upload
            String imagePath = saveFile(imagePart, request);

            // Handle file upload
            String filePath = saveFile(filePart, request);
            String fileName = (filePart != null && filePart.getSize() > 0) ? getFileName(filePart) : null;

            if (categoryService.addCategory(name, description, imagePath, filePath, fileName)) {
                response.sendRedirect(request.getContextPath() + "/category?success=added");
            } else {
                request.setAttribute("error", "Không thể thêm danh mục. Vui lòng thử lại!");
                request.setAttribute("name", name);
                request.setAttribute("description", description);
                request.getRequestDispatcher("/views/category/add.jsp").forward(request, response);
            }

        } else if ("update".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            Part imagePart = request.getPart("image");
            Part filePart = request.getPart("file");

            // === SERVER-SIDE VALIDATION ===
            Map<String, String> errors = validateCategoryForm(name, description, imagePart, filePart);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                Category category = categoryService.getCategoryById(id);
                if (category != null) {
                    category.setName(name);
                    category.setDescription(description);
                }
                request.setAttribute("category", category);
                request.getRequestDispatcher("/views/category/edit.jsp").forward(request, response);
                return;
            }

            // Handle image upload (null = keep old)
            String imagePath = saveFile(imagePart, request);

            // Handle file upload (null = keep old)
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
