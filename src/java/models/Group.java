package models;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import libs.ActiveRecord;
import static libs.ActiveRecord.conn;

public class Group extends ActiveRecord {
    private int id;
    private int user_id;
    private String name;
    private int user_count = 1;

    public List<Group> groupsFrom(int user_id) throws ClassNotFoundException, Exception {
        List<Object> groups = new ArrayList<Object>();
        where("user_id = " + user_id).transfer(groups);
        
        List<Group> groups_cast = new ArrayList<Group>();
        for (Object obj: groups) {
            groups_cast.add((Group) obj);
        }
        return groups_cast;
    }
    
    public List<Message> groupMessages() throws ClassNotFoundException, Exception {
        List<Object> messages = new ArrayList<Object>();
        Message message = new Message();
        message.where("user_id IN (SELECT user_id FROM group_members WHERE group_id = " + id + ")")
                .order("message_date DESC").transfer(messages);
        
        List<Message> messages_cast = new ArrayList<Message>();
        for (Object obj: messages) {
            messages_cast.add((Message) obj);
        }
        return messages_cast;
    }
    
    public void add(int member_id) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("INSERT INTO group_members (group_id, user_id) VALUES "
                + "(?, ?);");
        stmt.setInt(1, id);
        stmt.setInt(2, member_id);
        stmt.execute();
    }
    
    public void remove(int member_id) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("DELETE FROM group_members WHERE user_id = ? AND group_id = ?;");
        stmt.setInt(1, member_id);
        stmt.setInt(2, id);
        stmt.execute();
    }
    
    public boolean validate() {
        if (name.length() > 0) {
            User user = new User();
            try {
                if (user.where("login = \'" + name + "\'").count() == 0) {
                    return true;
                }
            } catch (Exception ex) {
                return false;
            }
        }
        return false;
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

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
