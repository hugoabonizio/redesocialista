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
                + "FROM \"user\" ORDER BY calc_influence(id, ?, ?) DESC");) {
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
}
