package models;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import libs.ActiveRecord;
import static libs.ActiveRecord.conn;

public class Message extends ActiveRecord {
    private int id;
    private int user_id;
    private int original_user_id;
    private int original_message_id;
    private String body;
    private Timestamp message_date;
    
    public List<MessagePOJO> timeline_messages() throws Exception {
        List<Object> messages = new ArrayList<Object>();
        where("user_id IN (SELECT followed_id FROM follow WHERE follower_id = " + user_id + ")")
                .order("message_date DESC").transfer(messages);
        
        List<MessagePOJO> messages_cast = new ArrayList<MessagePOJO>();
        for (Object obj: messages) {
            int likes;
            PreparedStatement stmt = conn.prepareStatement("SELECT sum(\"value\") AS sum_result FROM \"like\" WHERE message_id = ?;");
            stmt.setInt(1, ((Message) obj).getId());
            ResultSet result = stmt.executeQuery();
            
            if (result.next()) {
                likes = result.getInt("sum_result");
            } else {
                likes = 0;
            }
            messages_cast.add(new MessagePOJO((Message) obj, likes));
        }
        return messages_cast;
    }
    
    public List<MessagePOJO> getMessagesFrom(int user_id, int offset) throws ClassNotFoundException, Exception {
        List<Object> messages = new ArrayList<Object>();
        where("user_id = " + user_id).order("message_date DESC").limit(15 * offset).transfer(messages);
        
        List<MessagePOJO> messages_cast = new ArrayList<MessagePOJO>();
        
        for (Object obj: messages) {
            int likes;
            PreparedStatement stmt = conn.prepareStatement("SELECT sum(\"value\") AS sum_result FROM \"like\" WHERE message_id = ?;");
            stmt.setInt(1, ((Message) obj).getId());
            ResultSet result = stmt.executeQuery();

            if (result.next()) {
                likes = result.getInt("sum_result");
            } else {
                likes = 0;
            }
            messages_cast.add(new MessagePOJO((Message) obj, likes));
        }
        return messages_cast;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public Timestamp getMessage_date() {
        return message_date;
    }

    public void setMessage_date(Timestamp message_date) {
        this.message_date = message_date;
    }

    public int getOriginal_user_id() {
        return original_user_id;
    }

    public void setOriginal_user_id(int original_user_id) {
        this.original_user_id = original_user_id;
    }

    public int getOriginal_message_id() {
        return original_message_id;
    }

    public void setOriginal_message_id(int original_message_id) {
        this.original_message_id = original_message_id;
    }
    
}