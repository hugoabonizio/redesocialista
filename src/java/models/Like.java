package models;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import libs.*;

public class Like extends ActiveRecord {
    private int message_id;
    private int user_id;
    private int value;
    private Timestamp created_at;
    
    public void like() throws SQLException {
        value = 1;
        save();
    }
    
    public void dislike() throws SQLException {
        value = -1;
        save();
    }
    
    public boolean hasLike(int message_id, int user_id) throws SQLException {
        
        System.out.println("SELECT * FROM \"like\" WHERE message_id = ? AND user_id = ?;");
        System.out.println(message_id);
        System.out.println(user_id);
        
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM \"like\" WHERE message_id = ? AND user_id = ?;");
        stmt.setInt(1, message_id);
        stmt.setInt(2, user_id);
        ResultSet result = stmt.executeQuery();
        if (result.next()) {
            return true;
        } else {
            return false;
        }
    }
    
    @Override
    public void save() throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("INSERT INTO \"like\" (message_id, user_id, value) VALUES (?, ?, ?)");
        stmt.setInt(1, message_id);
        stmt.setInt(2, user_id);
        stmt.setInt(3, value);
        System.out.println("INSERT INTO like (message_id, user_id, value) VALUES (?, ?, ?)");
        stmt.execute();
    }

    public int getMessage_id() {
        return message_id;
    }
    public void setMessage_id(int message_id) {
        this.message_id = message_id;
    }

    public int getUser_id() {
        return user_id;
    }
    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }
}
