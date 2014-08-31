package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.*;

@WebServlet(urlPatterns = {
    "/welcome",
    "/message/create",
    "/message/edit",
    "/message/update",
    "/message/destroy",
    "/message/repost",
    "/message/comments"
        
})
public class MessageController extends HttpServlet {
    
    int current_page = 1;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        
        // Verifica se tá logado
        if (req.getSession().getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        
        RequestDispatcher dispatcher;
        Message message = new Message();
        
        try {
            
            switch (req.getServletPath()) {
                case "/welcome":
                    message.setUser_id((int) req.getSession().getAttribute("user_id"));
                    List<MessagePOJO> messages = message.timeline_messages();
                    req.setAttribute("messages", messages);
                    
                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/message/index.jsp");
                    dispatcher.forward(req, res);
                    break;
                    
                case "/message/edit":
                    message.find(req.getParameter("id"));
                    if (message.getUser_id() != (int) req.getSession().getAttribute("user_id")) {
                        res.sendRedirect(req.getContextPath() + "/");
                        return;
                    } else {
                        req.setAttribute("message_info", message);
                    }
                    
                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/message/edit.jsp");
                    dispatcher.forward(req, res);
                    break;
                    
                case "/message/destroy":
                    message.find(Integer.parseInt(req.getParameter("id")));
                    if (message.getUser_id() == (int) req.getSession().getAttribute("user_id")) {
                        if (message.destroy()) {
                            res.setStatus(200);
                        } else {
                            res.setStatus(500);
                        }
                    }
                    break;
                    
                case "/message/repost":
                    Message old = new Message();
                    old.find(req.getParameter("mid"));
                    message.setBody(old.getBody());
                    message.setUser_id((int) req.getSession().getAttribute("user_id"));
                    message.setOriginal_user_id(old.getOriginal_user_id());
                    message.setOriginal_message_id(old.getOriginal_message_id());
                    try {
                        message.save();
                        req.setAttribute("messageResult", true);
                    } catch (Exception ex) {
                        req.setAttribute("messageResult", false);
                    }

                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/message/index.jsp");
                    dispatcher.forward(req, res);
                    break;
                    
                case "/message/comments":
                    System.out.println(req.getParameter("mid"));
                    List<Comment> comments = (new Comment()).getComments(req.getParameter("mid"));
                    
                    req.setAttribute("comments", comments);
                    dispatcher = req.getRequestDispatcher("/views/message/comments.jsp");
                    dispatcher.forward(req, res);
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
        Message message = new Message();
        
        switch (req.getServletPath()) {
            case "/message/create":
                message.setBody(req.getParameter("message"));
                message.setUser_id((int) req.getSession().getAttribute("user_id"));
                message.setOriginal_user_id((int) req.getSession().getAttribute("user_id"));
                try {
                    message.save(true);
                    req.setAttribute("messageResult", true);
                } catch (Exception ex) {
                    req.setAttribute("messageResult", false);
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/message/index.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/message/update":
                try {
                    message.find(req.getParameter("message_id"));
                    if (message.getUser_id() != (int) req.getSession().getAttribute("user_id")) {
                        res.sendRedirect(req.getContextPath() + "/");
                        return;
                    } else {
                        message.setBody((String) req.getParameter("message"));
                        req.setAttribute("message_info", message);
                        message.update();
                        req.setAttribute("updateResult", true);

                    }
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                    req.setAttribute("updateResult", false);
                }

                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/message/edit.jsp");
                dispatcher.forward(req, res);
                break;
        }
    }
}
