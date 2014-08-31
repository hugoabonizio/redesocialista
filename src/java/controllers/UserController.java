package controllers;

import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.*;

@WebServlet(urlPatterns = {
    "/login",
    "/logout",
    "/auth",
    "/user",
    "/user/new",
    "/user/create",
    "/me",
    "/me/edit",
    "/me/edit/password",
    "/me/update",
    "/me/destroy"
})
public class UserController extends HttpServlet {
    
    int current_page = 2;
    
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        RequestDispatcher dispatcher;
        User user;
        HttpSession session;
        
        switch (req.getServletPath()) {
            case "/login":
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/user/login.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/user":
                if (req.getSession().getAttribute("user") == null) {
                    res.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                
                user = new User();
                try {
                    
                    Follow follow = new Follow();
                    
                    if (req.getParameter("user") == null) {
                        user.find(req.getParameter("id"));
                    } else {
                        List<User> users = new ArrayList<User>();
                        user.where("login = \'" + req.getParameter("user") + "\'").transfer(users);
                        user = users.get(0);
                    }
                    
                    req.setAttribute("user_info", user);
                    
                    int count = follow.where("follower_id = " + (int) req.getSession().getAttribute("user_id")
                             + "AND followed_id = " + user.getId()).count();
                    
                    if (count > 0) {
                        req.setAttribute("following", true);
                    } else {
                        req.setAttribute("following", false);
                    }
                    
                    req.setAttribute("messages", (new Message()).getMessagesFrom(user.getId(), 1));
                } catch (Exception ex) {
                    System.out.println("Exceção: " + ex.getMessage());
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/user/show.jsp");
                dispatcher.forward(req, res);
                break;
            
            case "/user/new":
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/user/new.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/me":
                // Verifica se tá logado
                if (req.getSession().getAttribute("user") == null) {
                    res.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                
                user = new User();
                try {
                    user.find((int) req.getSession().getAttribute("user_id"));
                    req.setAttribute("user_info", user);
                    req.setAttribute("messages", (new Message()).getMessagesFrom(user.getId(), 1));
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/user/show.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/me/edit":
                // Verifica se tá logado
                if (req.getSession().getAttribute("user") == null) {
                    res.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                
                user = new User();
                try {
                    user.find((int) req.getSession().getAttribute("user_id"));
                    req.setAttribute("user_info", user);
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/user/edit.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/me/edit/password":
                // Verifica se tá logado
                if (req.getSession().getAttribute("user") == null) {
                    res.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                
                user = new User();
                try {
                    user.find((int) req.getSession().getAttribute("user_id"));
                    req.setAttribute("user_info", user);
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/user/password.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/me/destroy":
                // Verifica se tá logado
                if (req.getSession().getAttribute("user") == null) {
                    res.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                
                user = new User();
                try {
                    System.out.println("ate aqui");
                    user.find((int) req.getSession().getAttribute("user_id"));
                    user.destroy();
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                
                res.sendRedirect(req.getContextPath() + "/logout");
                break;
            
                
            case "/logout":
                session = req.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                res.sendRedirect(req.getContextPath() + "/");
                break;
        }
    }
    
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        RequestDispatcher dispatcher;
        User user;
        
        switch (req.getServletPath()) {
            case "/user/create":
                user = new User();
                
                try {
                    user.setLogin(req.getParameter("login"));
                    user.setName(req.getParameter("name"));
                    user.setBirth(Date.valueOf(req.getParameter("birth")));
                    user.setPassword(req.getParameter("password"));
                    user.save();
                    req.setAttribute("registerResult", true);
                } catch (Exception ex) {
                    req.setAttribute("registerResult", false);
                    System.out.println("||" + ex.getMessage());
                }
                dispatcher = req.getRequestDispatcher("/views/user/login.jsp");
                dispatcher.forward(req, res);
                break;
            
            case "/auth":
                user = new User();
                user.setLogin(req.getParameter("login"));
                user.setPassword(req.getParameter("password"));
                if (user.authenticate()) {
                    req.setAttribute("loginResult", true);
                    HttpSession session = req.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("user_id", user.getId());
                    res.sendRedirect(req.getContextPath() + "/");
                } else {
                    req.setAttribute("loginResult", false);
                    dispatcher = req.getRequestDispatcher("/views/user/login.jsp");
                    dispatcher.forward(req, res);
                }
                break;
                
            case "/me/update":
                // Verifica se tá logado
                if (req.getSession().getAttribute("user") == null) {
                    res.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                user = new User();
                user.setId((int) req.getSession().getAttribute("user_id"));
                user.setName(req.getParameter("name"));
                user.setDescription(req.getParameter("description"));
                user.setBirth(Date.valueOf(req.getParameter("birth")));
                req.setAttribute("user_info", user);
                try {
                    User new_user = ((User) req.getSession().getAttribute("user"));
                    new_user.setName(user.getName());
                    req.getSession().setAttribute("user", new_user);
                    
                    user.update();
                    req.setAttribute("updateResult", true);
                } catch (Exception ex) {
                    req.setAttribute("updateResult", false);
                    System.out.println(ex.getMessage());
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/user/edit.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/me/edit/password":
                // Verifica se tá logado
                if (req.getSession().getAttribute("user") == null) {
                    res.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                user = new User();
                try {
                    user.find((int) req.getSession().getAttribute("user_id"));
                    System.out.println(user.getPassword() + " == " + user.toMD5((String) req.getParameter("old_password")));
                    if (user.getPassword().equals(user.toMD5((String) req.getParameter("old_password")))) {
                        user.setPassword((String) req.getParameter("new_password"));
                        user.save();
                        System.out.println("true");
                        req.setAttribute("updateResult", true);
                    } else {
                        System.out.println("false");
                        req.setAttribute("updateResult", false);
                    }
                    req.setAttribute("user_info", user);
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                    req.setAttribute("updateResult", false);
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/user/password.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/user":
                if (req.getSession().getAttribute("user") == null) {
                    res.sendRedirect(req.getContextPath() + "/");
                    return;
                }
                
                Comment comment = new Comment();
                comment.setMessage_id(req.getParameter("mid"));
                comment.setUser_id((int) req.getSession().getAttribute("user_id"));
                comment.setBody(req.getParameter("comment"));
                try {
                    comment.save();
                } catch (Exception ex) {
                    res.setStatus(500);
                    System.out.println(ex.getMessage());
                }
                res.sendRedirect(req.getContextPath() + "/");
                break;
                
        }
    }
}
