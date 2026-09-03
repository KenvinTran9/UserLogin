package com.app.service;

import com.app.dao.CategoryDAO;
import com.app.model.Category;

import java.util.List;

public class CategoryService {
    private CategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    public Category getCategoryById(String id) {
        return categoryDAO.findById(id);
    }

    public boolean addCategory(String name, String description,
                               String imagePath, String filePath, String fileName) {
        if (name == null || name.trim().isEmpty()) {
            return false;
        }
        Category category = new Category(name.trim(),
                description != null ? description.trim() : "");
        category.setImagePath(imagePath);
        category.setFilePath(filePath);
        category.setFileName(fileName);
        categoryDAO.insert(category);
        return true;
    }

    public boolean updateCategory(String id, String name, String description,
                                  String imagePath, String filePath, String fileName) {
        if (id == null || id.trim().isEmpty()
                || name == null || name.trim().isEmpty()) {
            return false;
        }
        Category existing = categoryDAO.findById(id);
        Category category = new Category(name.trim(),
                description != null ? description.trim() : "");
        category.setId(id);
        // Keep old image/file if no new upload
        category.setImagePath(imagePath != null ? imagePath : (existing != null ? existing.getImagePath() : null));
        category.setFilePath(filePath != null ? filePath : (existing != null ? existing.getFilePath() : null));
        category.setFileName(fileName != null ? fileName : (existing != null ? existing.getFileName() : null));
        categoryDAO.update(category);
        return true;
    }

    public boolean deleteCategory(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }
        return categoryDAO.delete(id);
    }
}
