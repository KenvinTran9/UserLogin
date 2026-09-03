package com.app.service;

import com.app.dao.UserDAO;
import com.app.model.User;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            return null;
        }
        return userDAO.findByUsernameAndPassword(username.trim(), password.trim());
    }

    public User findByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    public User findById(Long id) {
        return userDAO.findById(id);
    }

    public User updateProfile(Long id, String fullName, String phone, String imagePath) {
        User user = userDAO.findById(id);
        if (user == null) return null;

        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName.trim());
        }
        if (phone != null) {
            user.setPhone(phone.trim());
        }
        if (imagePath != null) {
            user.setImagePath(imagePath);
        }
        return userDAO.update(user);
    }
}
