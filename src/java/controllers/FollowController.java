package controllers;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.*;

@WebServlet(urlPatterns = {
    "/follow/create",
    "/follow/destroy"
})
public class FollowController extends HttpServlet {
    
    int current_page = 2;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        
        // Verifica se tá logado
        if (req.getSession().getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        
        RequestDispatcher dispatcher;
        Follow follow = new Follow();
        
        try {
            
            switch (req.getServletPath()) {
                case "/follow/create":
                    follow.setFollower_id((int) req.getSession().getAttribute("user_id"));
                    follow.setFollowed_id(req.getParameter("follow"));
                    try {
                        follow.save();
                        res.setStatus(200);
                    } catch (Exception ex) {
                        res.setStatus(500);
                    }
                    break;
                    
                case "/follow/destroy":
                    
                    try {
                        follow.where("follower_id = " + (int) req.getSession().getAttribute("user_id")
                             + "AND followed_id = " + req.getParameter("follow"));
                        if (follow.destroy()) {
                            res.setStatus(200);
                        } else {
                            res.setStatus(500);
                        }
                    } catch (Exception ex) {
                        res.setStatus(500);
                    }
                    break;

            }
        } catch (Exception ex) {
            System.out.println(ex.getClass());
        }
    }
    
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        
        // Verifica se tá logado
        if (req.getSession().getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        
        RequestDispatcher dispatcher;
        User user;
        Follow follow = new Follow();
        
        switch (req.getServletPath()) {
            
        }
    }
}
