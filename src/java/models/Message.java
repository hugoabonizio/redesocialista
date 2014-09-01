package models;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
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
    
    public List<MessagePOJO> getMessagesHashtag(String tag) throws Exception {
        List<Object> messages = new ArrayList<Object>();
        Message message = new Message();
        message.where("id IN (SELECT message_id FROM hashtag WHERE tag = \'" + tag + "\')")
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
    
    
    public void after() {
        PreparedStatement stmt;
        try {
            stmt = conn.prepareStatement("DELETE FROM hashtag WHERE message_id = ?;");
            stmt.setInt(1, id);
            stmt.execute();
            
            Pattern p = Pattern.compile("\\B#\\w*[a-zA-Z]+\\w*");
            Matcher m = p.matcher(body);
            while (m.find()) {
                System.out.println(m.group());
                String hashtag = m.group().substring(1);
                stmt = conn.prepareStatement("INSERT INTO hashtag (tag, message_id) VALUES (?, ?);");
                stmt.setString(1, hashtag);
                stmt.setInt(2, id);
                System.out.println(stmt);
                try {
                    stmt.execute();
                } catch (Exception ex) {}
            }
            
        } catch (SQLException ex) {
        }
        
        
        // Ao fazer update, atualizar as
        // republicações dessa mensagem
        if (exists()) {
            try {
                stmt = conn.prepareStatement("UPDATE \"message\" SET body = \'" + body + "\' WHERE original_message_id = " + id);
                stmt.execute();
            } catch (SQLException ex) {
                System.out.println(ex.getMessage());
            }
        }
    }
    
    
    public List<MessagePOJO> getMessagesAdvanced(String query) throws Exception {
        List<Object> messages = new ArrayList<Object>();
        where("id IN (" + query + ")").transfer(messages);
        
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
