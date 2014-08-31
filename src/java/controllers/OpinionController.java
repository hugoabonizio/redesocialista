package controllers;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.*;

@WebServlet(urlPatterns = {
    "/like",
    "/unlike",
    "/opinate"
})
public class OpinionController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        
            // Verifica se tá logado
            if (req.getSession().getAttribute("user") == null) {
                res.sendRedirect(req.getContextPath() + "/");
                return;
            }
            
            RequestDispatcher dispatcher;
            Like like;

        try {
            switch (req.getServletPath()) {
                case "/like":
                    like = new Like();
                    like.setUser_id(new Integer((int) req.getSession().getAttribute("user_id")));
                    like.setMessage_id(new Integer(req.getParameter("mid")));
                    like.like();
                    break;
                    
                case "/unlike":
                    like = new Like();
                    like.setUser_id(new Integer((int) req.getSession().getAttribute("user_id")));
                    like.setMessage_id(new Integer(req.getParameter("mid")));
                    like.dislike();
                    break;
                    
                case "/opinate":
                    
                    like = new Like();

                    if (like.hasLike(new Integer(req.getParameter("mid")), (int) req.getSession().getAttribute("user_id"))) {
                        // Já deu like/dislike
                        res.setStatus(500);
                    } else {
                        // Ainda não existe like/dislike
                        res.setStatus(200);
                    }
                    
                    break;
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }
}
