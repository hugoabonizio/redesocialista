package models;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import libs.ActiveRecord;

public class User extends ActiveRecord {
    private int id;
    private String login;
    private String name;
    private String password;
    private String description;
    private String origin;
    private Date birth;

    
    public boolean authenticate() {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM \"user\" WHERE login = ? AND password = ?;");) {
            stmt.setString(1, login);
            stmt.setString(2, password);
            ResultSet result = stmt.executeQuery();
            if (result.next()) {
                this.id = result.getInt("id");
                this.name = result.getString("name");
                this.login = result.getString("login");
                this.birth = result.getDate("birth");
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            return false;
        }
    }
    
    
    public List<User> search(String term) throws Exception {
        String where = "name ILIKE \'%" + term + "%\' OR login ILIKE \'%" + term + "%\'";
        
        List<Object> users = new ArrayList<Object>();
        User user = new User();
        user.where(where).transfer(users);
        
        List<User> users_cast = new ArrayList<User>();
        for (Object obj: users) {
            users_cast.add((User) obj);
        }
        return users_cast;
    }
    
    
    
    public String advancedSearchQuery(List<String> mentions, List<String> hashtags) {
        //String query = "SELECT original_user_id, body, login, description, birth FROM \n" +
        String query = "SELECT m.id FROM \n" +
"	hashtag AS h, message AS m, \"user\" AS u, \"group\" AS g\n" +
"	WHERE\n" +
"	m.id = h.message_id\n" +
"	AND u.id = original_user_id\n AND ";
        
        int i;
        
        if (mentions.size() > 0) {
            // mentions
            i = 0;
            query += "(";
            for (String mention: mentions) {
                if (i > 0) {
                    query += " OR ";
                }
                i++;
                query += "u.login = \'" + mention + "\' OR g.name = \'" + mention + "\'";
            }
            query += ")";
        }
        
        if (mentions.size() > 0 && hashtags.size() > 0) {
            query += " AND ";
        }
        
        if (hashtags.size() > 0) {
            // hashtags
            i = 0;
            query += "(";
            for (String hashtag: hashtags) {
                if (i > 0) {
                    query += " OR ";
                }
                i++;
                query += "h.tag = \'" + hashtag + "\'";
            }
            query += ")";
        }
        
        System.out.println(query);
        return query;
        
    }
    
    
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    
    public String getLogin() {
        return login;
    }
    public void setLogin(String login) {
        this.login = login;
    }
    
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = toMD5(password);
    }
    
    public String toMD5(String text) {
        MessageDigest m;
        try {
            m = MessageDigest.getInstance("MD5");
            m.update(text.getBytes(), 0, text.length());
            return new BigInteger(1, m.digest()).toString(16);
        } catch (NoSuchAlgorithmException ex) {
            System.out.println("erro no md5: " + ex.getMessage());
            return null;
        }
    }

    public Date getBirth() {
        return birth;
    }
    public void setBirth(Date birth) {
        this.birth = birth;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getOrigin() {
        return origin;
    }
    public void setOrigin(String origin) {
        this.origin = origin;
    }

    
}
