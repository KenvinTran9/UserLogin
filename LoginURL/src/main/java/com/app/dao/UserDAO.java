package com.app.dao;

import com.app.model.User;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;

import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;

public class UserDAO {
    private MongoCollection<Document> collection;

    public UserDAO() {
        MongoDatabase db = MongoDBConnection.getInstance().getDatabase();
        collection = db.getCollection("users");
        seedData();
    }

    /**
     * Seed default admin user if collection is empty
     */
    private void seedData() {
        if (collection.countDocuments() == 0) {
            Document admin = new Document()
                    .append("username", "admin")
                    .append("password", "admin123")
                    .append("fullName", "Administrator")
                    .append("email", "admin@example.com");
            collection.insertOne(admin);
        }
    }

    public User findByUsernameAndPassword(String username, String password) {
        Document doc = collection.find(
                and(eq("username", username), eq("password", password))
        ).first();
        return documentToUser(doc);
    }

    public User findByUsername(String username) {
        Document doc = collection.find(eq("username", username)).first();
        return documentToUser(doc);
    }

    public void insert(User user) {
        Document doc = new Document()
                .append("username", user.getUsername())
                .append("password", user.getPassword())
                .append("fullName", user.getFullName())
                .append("email", user.getEmail());
        collection.insertOne(doc);
    }

    private User documentToUser(Document doc) {
        if (doc == null) return null;
        User user = new User();
        user.setId(doc.getObjectId("_id").toHexString());
        user.setUsername(doc.getString("username"));
        user.setPassword(doc.getString("password"));
        user.setFullName(doc.getString("fullName"));
        user.setEmail(doc.getString("email"));
        return user;
    }
}
