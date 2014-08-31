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
