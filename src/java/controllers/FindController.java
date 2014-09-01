package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.Group;
import models.Message;
import models.MessagePOJO;
import models.User;

@WebServlet(urlPatterns = {
    "/find",
    "/search",
    "/advanced_search"
})
public class FindController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        
        // Verifica se tá logado
        if (req.getSession().getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        
        RequestDispatcher dispatcher;
        User user;
        
        switch (req.getServletPath()) {
            case "/find":
                String term = req.getParameter("search");
                
                // Procura nos usuários
                user = new User();
                try {
                    if (user.where("login = \'" + term + "\'").count() > 0) {
                        res.sendRedirect(req.getContextPath() + "/user?user=" + term);
                        return;
                    }
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                
                // Procura nos grupos
                Group group = new Group();
                try {
                    List<Group> groups = new ArrayList<Group>();
                    group.where("name = \'" + term + "\'").transfer(groups);
                    if (groups.size() > 0) {
                        res.sendRedirect(req.getContextPath() + "/group?id=" + groups.get(0).getId());
                        return;
                    }
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                
                // Não achou
                dispatcher = req.getRequestDispatcher("/views/find/not_found.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/search":
                dispatcher = req.getRequestDispatcher("/views/find/index.jsp");
                dispatcher.forward(req, res);
                break;
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
        
        switch (req.getServletPath()) {
            case "/search":
                user = new User();
                List<User> users = null;
                try {
                    users = user.search(req.getParameter("search"));
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                
                req.setAttribute("userList", users);
                
                dispatcher = req.getRequestDispatcher("/views/find/users.jsp");
                dispatcher.forward(req, res);
                
                break;
                
            case "/advanced_search":
                String search = req.getParameter("search");
                
                List<String> mentions = new ArrayList<String>();
                List<String> hashtags = new ArrayList<String>();
                
                Pattern p = Pattern.compile("@([a-z\\d_]+)");
                Matcher m = p.matcher(search);
                System.out.println("mentions:");
                while (m.find()) {
                    mentions.add(m.group().substring(1));
                    System.out.println(m.group());
                }
                
                p = Pattern.compile("\\B#\\w*[a-zA-Z]+\\w*");
                m = p.matcher(search);
                System.out.println("hashtags:");
                while (m.find()) {
                    hashtags.add(m.group().substring(1));
                    System.out.println(m.group());
                }
                
                user = new User();
                List<MessagePOJO> messages = null;
                try {
                    messages = (new Message()).getMessagesAdvanced(user.advancedSearchQuery(mentions, hashtags));
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                req.setAttribute("messageList", messages);
                
                dispatcher = req.getRequestDispatcher("/views/find/advanced_search.jsp");
                dispatcher.forward(req, res);
                break;
        }
    }
}
