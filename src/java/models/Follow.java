package models;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import libs.ActiveRecord;

public class Follow extends ActiveRecord {
    private int follower_id;
    private int followed_id;
    
    @Override
    public boolean destroy() {
        System.out.println("DELETE FROM " + table + " WHERE " + this.where + ";");
        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM " + table + " WHERE " + this.where + ";");) {
            stmt.execute();
            return true;
        } catch (SQLException ex) {
            return false;
        }
    }

    public int getFollower_id() {
        return follower_id;
    }
    public void setFollower_id(int follower_id) {
        this.follower_id = follower_id;
    }
    public void setFollower_id(String follower_id) {
        setFollower_id(Integer.parseInt(follower_id));
    }

    public int getFollowed_id() {
        return followed_id;
    }
    public void setFollowed_id(int followed_id) {
        this.followed_id = followed_id;
    }
    public void setFollowed_id(String followed_id) {
        setFollowed_id(Integer.parseInt(followed_id));
    }
}
