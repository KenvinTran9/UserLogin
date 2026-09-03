package com.app.dao;

import com.app.model.Category;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.result.DeleteResult;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

public class CategoryDAO {
    private MongoCollection<Document> collection;

    public CategoryDAO() {
        MongoDatabase db = MongoDBConnection.getInstance().getDatabase();
        collection = db.getCollection("categories");
    }

    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        for (Document doc : collection.find()) {
            categories.add(documentToCategory(doc));
        }
        return categories;
    }

    public Category findById(String id) {
        Document doc = collection.find(eq("_id", new ObjectId(id))).first();
        return documentToCategory(doc);
    }

    public void insert(Category category) {
        Document doc = new Document()
                .append("name", category.getName())
                .append("description", category.getDescription())
                .append("imagePath", category.getImagePath())
                .append("filePath", category.getFilePath())
                .append("fileName", category.getFileName());
        collection.insertOne(doc);
    }

    public void update(Category category) {
        Document updateDoc = new Document("$set",
                new Document()
                        .append("name", category.getName())
                        .append("description", category.getDescription())
                        .append("imagePath", category.getImagePath())
                        .append("filePath", category.getFilePath())
                        .append("fileName", category.getFileName())
        );
        collection.updateOne(eq("_id", new ObjectId(category.getId())), updateDoc);
    }

    public boolean delete(String id) {
        DeleteResult result = collection.deleteOne(eq("_id", new ObjectId(id)));
        return result.getDeletedCount() > 0;
    }

    private Category documentToCategory(Document doc) {
        if (doc == null) return null;
        Category category = new Category();
        category.setId(doc.getObjectId("_id").toHexString());
        category.setName(doc.getString("name"));
        category.setDescription(doc.getString("description"));
        category.setImagePath(doc.getString("imagePath"));
        category.setFilePath(doc.getString("filePath"));
        category.setFileName(doc.getString("fileName"));
        return category;
    }
}
