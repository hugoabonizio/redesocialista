
package controllers;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import libs.ActiveRecord;
import models.*;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

@WebServlet(urlPatterns = {
    "/exportar",
    "/importar"
})
public class WebserviceController extends HttpServlet {
    
    int server_id = 14;
    
    static Gson gson = new GsonBuilder()
            .setPrettyPrinting()
            .setDateFormat("dd/MM/yyyy HH:mm")
            .create();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher;
        
        switch (request.getServletPath()) {
            case "/exportar":
                Pacote pacote = new Pacote();
                
                Gson gson = new GsonBuilder()
                        .setPrettyPrinting()
                        .setDateFormat("dd/MM/yyyy HH:mm")
                        .create();
                response.setCharacterEncoding("utf-8");
                response.setContentType("application/json");
                
                try {
                    // POSTS
                    PostJSON post;
                    for (MessagePOJO message: (new Message()).getMessagesFrom(-1, 100)) {
                        if (message.getMessage().getOriginal_message_id() == message.getMessage().getId()
                            && message.getMessage().getServer_id() == 0) {
                            post = new PostJSON();
                            post.id = message.getMessage().getId();
                            post.id_usuario = message.getMessage().getUser_id();
                            post.titulo = "Título";
                            post.conteudo = message.getMessage().getBody();
                            post.data = new Date(message.getMessage().getMessage_date().getTime());
                            pacote.posts.add(post);
                        }
                    }
                    
                    // REPOSTS
                    RepostJSON repost;
                    for (MessagePOJO message: (new Message()).getMessagesFrom(-1, 100)) {
                        if (message.getMessage().getOriginal_message_id() != message.getMessage().getId()
                            && message.getMessage().getServer_id() == 0) {
                            repost = new RepostJSON();
                            repost.id = message.getMessage().getId();
                            repost.id_usuario = message.getMessage().getUser_id();
                            repost.id_post = message.getMessage().getOriginal_message_id();
                            repost.data = new Date(message.getMessage().getMessage_date().getTime());
                            pacote.reposts.add(repost);
                        }
                    }
                    
                    // LIKES
                    LikeJSON like;
                    DislikeJSON dislike;
                    for (Like l: (new Like()).all()) {
                        if (l.getValue() > 0) {
                            like = new LikeJSON();
                            like.id_usuario = l.getUser_id();
                            like.id_post = l.getMessage_id();
                            like.data = new Date(l.getCreated_at().getTime());
                            pacote.likes.add(like);
                        } else {
                            dislike = new DislikeJSON();
                            dislike.id_usuario = l.getUser_id();
                            dislike.id_post = l.getMessage_id();
                            dislike.data = new Date(l.getCreated_at().getTime());
                            pacote.dislikes.add(dislike);
                        }
                    }
                    
                    // COMENTARIOS
                    ComentarioJSON comentario;
                    int i = 1;
                    for (Comment comment: (new Comment()).getComments("1 OR 1=1 AND (server_id IS NULL OR server_id = 0)")) {
                        comentario = new ComentarioJSON();
                        comentario.id = i++;
                        comentario.id_usuario = comment.getUser_id();
                        comentario.id_post = comment.getMessage_id();
                        comentario.conteudo = comment.getBody();
                        comentario.data = new Date(comment.getComment_date().getTime());
                        pacote.comentarios.add(comentario);
                    }
                    
                    // USUARIOS
                    UsuarioJSON usuario;
                    for (User user: (new User()).search("")) {
                        usuario = new UsuarioJSON();
                        usuario.id = user.getId();
                        usuario.nome = user.getName();
                        usuario.login = user.getLogin();
                        usuario.nascimento = user.getBirth();
                        usuario.descricao = user.getDescription();
                        pacote.usuarios.add(usuario);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(WebserviceController.class.getName()).log(Level.SEVERE, null, ex);
                }

                try (PrintWriter out = response.getWriter()) {
                    gson.toJson(pacote, out);
                }
                break;
                
            case "/importar":
                dispatcher = request.getRequestDispatcher("/views/import/index.jsp");
                dispatcher.forward(request, response);
                break;
        }
        
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher;
        
        Map<Integer, Integer> mapUserId = new TreeMap<>();
        Map<Integer, Integer> mapMessageId = new TreeMap<>();
        Map<Integer, String> mapMessageBody = new TreeMap<>();
        
        switch (request.getServletPath()) {
            case "/importar":
                String url = request.getParameter("url");
                Pacote pacote = importFromURL(url);
                
                try {
                    // DELETA DADOS DO SERVIDOR
                    PreparedStatement stmt = (new ActiveRecord()).conn.prepareStatement(
                            "DELETE FROM \"user\" WHERE server_id = " + pacote.id_servidor + ";"
                          + "DELETE FROM \"message\" WHERE server_id = " + pacote.id_servidor + ";"
                          + "DELETE FROM \"comment\" WHERE server_id = " + pacote.id_servidor + ";"
                          + "DELETE FROM \"like\" WHERE server_id = " + pacote.id_servidor + ";"
                    );
                    stmt.execute();
                    
                    // IMPORTAR
                    
                    // USER
                    User user;
                    for (UsuarioJSON usuario: pacote.usuarios) {
                        user = new User();
                        user.setLogin(usuario.login + "_" + pacote.id_servidor);
                        user.setName(usuario.nome);
                        user.setBirth(new Date(usuario.nascimento.getTime()));
                        user.setDescription(usuario.descricao);
                        user.setServer_id(pacote.id_servidor);
                        user.setPassword("senha");
                        user.save(true);
                        mapUserId.put(usuario.id, user.getId());
                    }
                    
                    // MESSAGE
                    Message message;
                    for (PostJSON post: pacote.posts) {
                        message = new Message();
                        message.setBody(post.conteudo);
                        message.setMessage_date(new Timestamp(post.data.getTime()));
                        message.setUser_id(mapUserId.get(post.id_usuario));
                        message.setOriginal_user_id(mapUserId.get(post.id_usuario));
                        message.setServer_id(pacote.id_servidor);
                        message.save(true);
                        mapMessageId.put(post.id, message.getId());
                        mapMessageBody.put(post.id, post.conteudo);
                    }
                    
                    // MESSAGE (REPOST)
                    for (RepostJSON post: pacote.reposts) {
                        message = new Message();
                        message.setBody(mapMessageBody.get(post.id_post));
                        message.setMessage_date(new Timestamp(post.data.getTime()));
                        message.setUser_id(mapUserId.get(post.id_usuario));
                        message.setOriginal_user_id(mapUserId.get(post.id_usuario));
                        message.setOriginal_message_id(mapMessageId.get(post.id_post));
                        message.setServer_id(pacote.id_servidor);
                        message.save(true);
                        mapMessageId.put(post.id, message.getId());
                    }
                    
                    // COMMENT
                    Comment comment;
                    for (ComentarioJSON comentario: pacote.comentarios) {
                        comment = new Comment();
                        comment.setBody(comentario.conteudo);
                        comment.setUser_id(mapUserId.get(comentario.id_usuario));
                        comment.setMessage_id(mapMessageId.get(comentario.id_post));
                        comment.setServer_id(pacote.id_servidor);
                        comment.save();
                    }
                    
                    // LIKE
                    Like like;
                    for (LikeJSON likejson: pacote.likes) {
                        like = new Like();
                        like.setMessage_id(mapMessageId.get(likejson.id_post));
                        like.setUser_id(mapUserId.get(likejson.id_usuario));
                        like.setValue(1);
                        like.setServer_id(pacote.id_servidor);
                        like.save();
                    }
                    
                    // LIKE (DISLIKE)
                    for (DislikeJSON likejson: pacote.dislikes) {
                        like = new Like();
                        like.setMessage_id(mapMessageId.get(likejson.id_post));
                        like.setUser_id(mapUserId.get(likejson.id_usuario));
                        like.setValue(-1);
                        like.setServer_id(pacote.id_servidor);
                        like.save();
                    }
                    
                } catch (SQLException ex) {
                    Logger.getLogger(WebserviceController.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(WebserviceController.class.getName()).log(Level.SEVERE, null, ex);
                }
                try (PrintWriter out = response.getWriter()) {
                    gson.toJson(pacote, out);
                }
                //dispatcher = request.getRequestDispatcher("/views/import/index.jsp");
                //dispatcher.forward(request, response);
                break;
        }
    }
    
    Pacote importFromURL(String url) throws IOException {
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            try (CloseableHttpResponse jsonResponse = httpClient.execute(new HttpGet(url)); InputStreamReader jsonContent = new InputStreamReader(jsonResponse.getEntity().getContent(), "utf-8")) {
                return gson.fromJson(jsonContent, Pacote.class);
            }
        }
    }
    
    
    
    static class Pacote {

        int id_servidor = 14;

        List<PostJSON> posts;
        List<RepostJSON> reposts;
        List<UsuarioJSON> usuarios;
        List<LikeJSON> likes;
        List<DislikeJSON> dislikes;
        List<ComentarioJSON> comentarios;

        public Pacote() {
            posts = new LinkedList<>();
            reposts = new LinkedList<>();
            likes = new LinkedList<>();
            dislikes = new LinkedList<>();
            comentarios = new LinkedList<>();
            usuarios = new LinkedList<>();
        }

    }

    static class PostJSON {
        int id;
        int id_usuario;
        String titulo;
        String conteudo;
        Date data;
    }
    
    static class RepostJSON {

        int id;
        int id_usuario;
        int id_post;
        Date data;
    }

    static class LikeJSON {

        int id_usuario;
        int id_post;
        Date data;
    }

    static class DislikeJSON {

        int id_usuario;
        int id_post;
        Date data;
    }

    static class ComentarioJSON {

        int id;
        int id_usuario;
        int id_post;
        String conteudo;
        Date data;
    }

    static class UsuarioJSON {

        int id;
        String nome;
        String login;
        Date nascimento;
        String descricao;
    }

}
