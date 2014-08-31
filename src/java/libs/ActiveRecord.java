package libs;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class ActiveRecord<T> {
    
    private boolean exists = true;
    public String table = "\"" + this.getClass().getSimpleName().toLowerCase() + "\"";
    private String limit;
    public String where;
    private String order;
    public static Connection conn;
    
    public ActiveRecord() {
        exists = false;
        if (conn == null) {
            try {
                Class.forName("org.postgresql.Driver");
                String url = "jdbc:postgresql://localhost:5432/projeto_bd";
                conn = DriverManager.getConnection(url, "postgres", "postgres");
                System.out.println("criou uma nova conexao");
            } catch (Exception e) {
                System.out.println("não conseguiu criar");
            }
        }
    }
    
    // Popula o model com os atribudos do banco de dados
    // Exemplo:
    //  User u = new User();
    //  u.find(1);
    //  Symtem.out.println(u.login);
    public void find(int id) throws Exception {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM " + table + " WHERE id = ?");) {
            stmt.setInt(1, id);
            try (ResultSet result = stmt.executeQuery();) {
                if (result.next()) {
                    Field[] fields = this.getClass().getDeclaredFields();
                    for (Field field : fields) {
                        Field f = this.getClass().getDeclaredField(field.getName());
                        f.setAccessible(true);
                        if (field.getType() == int.class) {
                            f.set(this, result.getInt(field.getName()));
                        } else if (field.getType() == java.sql.Date.class) {
                            f.set(this, result.getDate(field.getName()));
                        } else if (field.getType() == java.sql.Timestamp.class) {
                            f.set(this, result.getTimestamp(field.getName()));
                        } else if (field.getType() == java.lang.String.class) {
                            f.set(this, result.getString(field.getName()));
                        }
                    }
                    // Indica que já existe no banco de dados,
                    // pois o construtor seta como false por
                    // padrão (faz sentido)
                    this.exists = true;
                }
            }
        }
    }
    
    // Alias para passar string ocmo parametro
    public void find(String id) throws Exception {
        find(Integer.parseInt(id));
    }
    
    
    // Persiste no banco de dados, sendo INSERT se o
    // atributo "exists" for TRUE, ou UPDATE se o atributo
    // for FALSE
    public void save() throws Exception {
        if (validate()) {
            String query;
            if (exists) {
                query = "UPDATE " + table + " SET ";
                Field[] fields = this.getClass().getDeclaredFields();
                for (Field field : fields) {
                    Field f = this.getClass().getDeclaredField(field.getName());
                    f.setAccessible(true);
                    /*System.out.println(field.getName() + " - " + field.getType() + " - " 
                            + f.get(this));*/
                    if (f.get(this) != null && field.getName() != "id") {
                        query += field.getName() + " = '" + f.get(this)
                            + "',";
                    }
                }
                Field instance_id = this.getClass().getDeclaredField("id");
                instance_id.setAccessible(true);
                query = query.substring(0, query.length() - 1) + " WHERE id = " 
                        + instance_id.get(this) + ";";
                
                conn.createStatement().execute(query);
            } else {
                query = "INSERT INTO " + table + " (";
                Field[] fields = this.getClass().getDeclaredFields();

                for (Field field : fields) {
                    Field f = this.getClass().getDeclaredField(field.getName());
                    f.setAccessible(true);
                    if (f.get(this) != null && field.getName() != "id") {
                        query += field.getName() + ",";
                    }
                }
                query = query.substring(0, query.length() - 1) + ") VALUES (";

                // Primeiro os ? para escapar os valores
                fields = this.getClass().getDeclaredFields();
                for (Field field : fields) {
                    Field f = this.getClass().getDeclaredField(field.getName());
                    f.setAccessible(true);
                    if (f.get(this) != null && field.getName() != "id") {
                        //query += "'" + f.get(this) + "',";
                        query += "?,";
                    }
                }

                query = query.substring(0, query.length() - 1) + ");";
                
                System.out.println(query);
                
                PreparedStatement stmt = conn.prepareStatement(query);

                // Agora os valores
                fields = this.getClass().getDeclaredFields();
                int i = 0;
                for (Field field : fields) {
                    Field f = this.getClass().getDeclaredField(field.getName());
                    f.setAccessible(true);
                    if (f.get(this) != null && field.getName() != "id") {
                        i++;
                        if (field.getType() == int.class) {
                            stmt.setInt(i, (int) f.get(this));
                        } else if (field.getType() == java.sql.Date.class) {
                            stmt.setDate(i, (Date) f.get(this));
                        } else if (field.getType() == java.sql.Timestamp.class) {
                            stmt.setTimestamp(i, (Timestamp) f.get(this));
                        } else if (field.getType() == java.lang.String.class) {
                            stmt.setString(i, (String) f.get(this));
                        }
                        //query += "'" + f.get(this) + "',";

                    }
                }
                System.out.println("executou");
                System.out.println("query: " + stmt);
                stmt.execute();
            }

            //conn.createStatement().execute(query);
        } else {
            throw new Exception("não validou");
        }
    }
    
    
    public ActiveRecord where(String where) {
        this.where = where;
        return this;
    }
    
    public ActiveRecord order(String order) {
        this.order = order;
        return this;
    }
    
    public ActiveRecord limit(int limit) {
        this.limit = Integer.toString(limit);
        return this;
    }
    
    public ActiveRecord all() {
        return this;
    }    
    
    public void transfer(List<Object> list) throws SQLException, ClassNotFoundException, Exception {
        String query = "SELECT * FROM " + table + " ";
        if (where != null) {
            query += "WHERE " + where + " ";
        }
        if (order != null) {
            query += "ORDER BY " + order + " ";
        }
        if (limit != null) {
            query += "LIMIT " + limit;
        }
        query += ";";
        System.out.println(query);
        try (PreparedStatement stmt = conn.prepareStatement(query);) {
            try (ResultSet result = stmt.executeQuery();) {
                Field f;
                
                while (result.next()) {
                    Object obj = Class.forName(this.getClass().getName()).newInstance();
                    
                    ResultSetMetaData rsmd = result.getMetaData();
                    int columnCount = rsmd.getColumnCount();

                    for (int i = 1; i < columnCount + 1; i++) {
                        String columnName = rsmd.getColumnName(i);
                        f = obj.getClass().getDeclaredField(columnName);
                        f.setAccessible(true);
                        if (rsmd.getColumnClassName(i).toString() == "java.lang.String") {
                            f.set(obj, result.getString(columnName));
                        }
                        if (rsmd.getColumnClassName(i).toString() == "java.lang.Integer") {
                            f.set(obj, result.getInt(columnName));
                        }
                        if (rsmd.getColumnClassName(i).toString() == "java.sql.Date") {
                            f.set(obj, result.getDate(columnName));
                        }
                        if (rsmd.getColumnClassName(i).toString() == "java.sql.Timestamp") {
                            f.set(obj, result.getTimestamp(columnName));
                        }
                        //System.out.println(rsmd.getColumnClassName(i));
                        //obj.getClass().getDeclaredField(columnName).set(obj, );
                    }
                    list.add(obj);
                    
                    // Indica que já existe no banco de dados,
                    // pois o construtor seta como false por
                    // padrão (faz sentido)
                    this.exists = true;
                }
            }
        }
    }
    
    // Se o registro já existe (attributo "exists"),
    // executa um delete pegando o id (que já deveria
    // estar atribuído, pela lógica, já que o objeto já
    // está persistido no banco de dados
    public boolean destroy() throws NoSuchFieldException, IllegalArgumentException, IllegalAccessException {
        if (exists) {
            Field f;
            try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM " + table + " WHERE id = ?;");) {
                f = this.getClass().getDeclaredField("id");
                f.setAccessible(true);
                
                System.out.println("DELETE FROM " + table + " WHERE id = " + (int) f.get(this) + ";");
                
                stmt.setInt(1, (int) f.get(this));
                stmt.execute();
                return true;
            } catch (SQLException ex) {
                return false;
            }
        } else {
            return false;
        }
    }
    
    // Seta "exists" como TRUE para passar
    // na verificação do método save() e dar
    // um INSERT, e não UPDATE
    public void update() throws Exception {
        exists = true;
        save();
    }
    
    public boolean validate() {
        return true;
    }
    
    public int count() throws Exception {
        int count = 0;
        
        String query = "SELECT COUNT(*) AS count FROM " + table + " ";
        if (where != null) {
            query += "WHERE " + where;
        }
        query += ";";
        
        System.out.println(query);
        try (PreparedStatement stmt = conn.prepareStatement(query);) {
            try (ResultSet result = stmt.executeQuery();) {
                if (result.next()) {
                    count = result.getInt("count");
                }
            }
        }
        return count;
    }
    
}
