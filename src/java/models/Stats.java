package models;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;
import libs.ActiveRecord;
import static libs.ActiveRecord.conn;

public class Stats extends ActiveRecord {
    
    public List<UserPOJO> getTop20Users(String from, String to) throws SQLException {
        List<UserPOJO> users = new LinkedList<>();
        UserPOJO user;
        try (PreparedStatement stmt = conn.prepareStatement("SELECT name, calc_influence(id, ?, ?) as influence "
                + "FROM \"user\" ORDER BY calc_influence(id, ?, ?) DESC LIMIT 20");) {
            stmt.setString(1, from);
            stmt.setString(2, to);
            stmt.setString(3, from);
            stmt.setString(4, to);
            System.out.println(stmt.toString());
            try (ResultSet result = stmt.executeQuery();) {
                while (result.next()) {
                    user = new UserPOJO();
                    user.setName(result.getString("name"));
                    user.setInfluence(result.getInt("influence"));
                    users.add(user);
                }
            }
        }
        return users;
    }
    
    public List<Message> getTop20Messages(String from, String to) throws SQLException {
        List<Message> messages = new LinkedList<>();
        Message message;
        try (PreparedStatement stmt = conn.prepareStatement("SELECT SUBSTRING(body, 0, 20) AS body, calc_impact(id, ?, ?) AS impact "
                + "FROM \"message\" ORDER BY calc_impact(id, ?, ?) DESC LIMIT 20");) {
            stmt.setString(1, from);
            stmt.setString(2, to);
            stmt.setString(3, from);
            stmt.setString(4, to);
            System.out.println(stmt.toString());
            try (ResultSet result = stmt.executeQuery();) {
                while (result.next()) {
                    message = new Message();
                    message.setBody(result.getString("body"));
                    message.setId(result.getInt("impact"));
                    messages.add(message);
                }
            }
        }
        return messages;
    }
    
    public List<User> influence(String uid_raw) throws SQLException {
        int uid = new Integer(uid_raw);
        List<User> users = new LinkedList<>();
        User user;
        int id;
        try (PreparedStatement stmt = conn.prepareStatement("SELECT DISTINCT ON (login) * FROM \"follow\" LEFT JOIN \"user\" ON id = follower_id WHERE followed_id IN\n" +
"(SELECT DISTINCT id FROM \"follow\" LEFT JOIN \"user\" ON id = follower_id WHERE followed_id = ?)\n" +
"OR followed_id = ?;");) {
            stmt.setInt(1, uid);
            stmt.setInt(2, uid);
            try (ResultSet result = stmt.executeQuery();) {
                while (result.next()) {
                    id = result.getInt("id");
                    if (id != uid) {
                        user = new User();
                        user.setId(id);
                        user.setName(result.getString("name"));
                        users.add(user);
                    }
                }
            }
        }
        return users;
    }
}
