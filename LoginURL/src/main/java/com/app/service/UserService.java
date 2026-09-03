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
}
