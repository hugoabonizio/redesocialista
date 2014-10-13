package models;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import libs.*;

public class Comment extends ActiveRecord {
    private int message_id;
    private int user_id;
    private String body;
    private Timestamp comment_date;
    private int server_id;

    public List<Comment> getComments(String message_id) throws Exception {
        List<Object> comments = new ArrayList<Object>();
        
        try {
            (new Comment()).where("message_id = " + message_id)
                    .order("comment_date DESC").transfer(comments);

            List<Comment> comments_cast = new ArrayList<Comment>();
            for (Object obj: comments) {
                comments_cast.add((Comment) obj);
            }
            return comments_cast;
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        return null;
        
    }

    public int getMessage_id() {
        return message_id;
    }
    public void setMessage_id(String message_id) {
        setMessage_id(new Integer(message_id));
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

    public String getBody() {
        return body;
    }
    public void setBody(String body) {
        this.body = body;
    }

    public Timestamp getComment_date() {
        return comment_date;
    }

    public int getServer_id() {
        return server_id;
    }

    public void setServer_id(int server_id) {
        this.server_id = server_id;
    }
    
}
