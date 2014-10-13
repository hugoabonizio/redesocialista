package models;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import libs.*;

public class Like extends ActiveRecord {
    private int message_id;
    private int user_id;
    private int value;
    private Timestamp created_at;
    private int server_id;
    
    public void like() throws SQLException {
        setValue(1);
        save();
    }
    
    public void dislike() throws SQLException {
        setValue(-1);
        save();
    }
    
    public List<Like> all() throws Exception {
        List<Object> likes = new ArrayList<Object>();
        
        try {
            where("server_id IS NULL OR server_id = 0").transfer(likes);

            List<Like> likes_cast = new ArrayList<Like>();
            for (Object obj: likes) {
                likes_cast.add((Like) obj);
            }
            return likes_cast;
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        return null;
        
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
        PreparedStatement stmt = conn.prepareStatement("INSERT INTO \"like\" (message_id, user_id, value, server_id) VALUES (?, ?, ?, ?)");
        stmt.setInt(1, message_id);
        stmt.setInt(2, user_id);
        stmt.setInt(3, getValue());
        stmt.setInt(4, server_id);
        System.out.println(stmt);
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

    public int getValue() {
        return value;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public int getServer_id() {
        return server_id;
    }

    public void setServer_id(int server_id) {
        this.server_id = server_id;
    }

    public void setValue(int value) {
        this.value = value;
    }
}
