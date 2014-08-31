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
    "/groups",
    "/group",
    "/group/new",
    "/group/create",
    "/group/edit",
    "/group/update",
    "/group/destroy",
    "/group/add",
    "/group/remove"
})
public class GroupController extends HttpServlet {
    
    int current_page = 3;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        
        // Verifica se tá logado
        if (req.getSession().getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        
        RequestDispatcher dispatcher;
        Group group = new Group();
        User user;
        
        try {
            
            switch (req.getServletPath()) {
                case "/groups":
                    req.setAttribute(
                            "groupList",
                            (new Group()).groupsFrom((int) req.getSession().getAttribute("user_id"))
                    );
                    
                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/group/index.jsp");
                    dispatcher.forward(req, res);
                    break;
                    
                case "/group":
                    group = new Group();
                    boolean error = false;
                    try {
                        group.find(req.getParameter("id"));
                        System.out.println(group.getUser_id() + " != " + (int) req.getSession().getAttribute("user_id"));
                        /*if (group.getUser_id() != (int) req.getSession().getAttribute("user_id")) {
                            error = true;
                        }*/
                        req.setAttribute("group_info", group);
                        req.setAttribute("messageList", group.groupMessages());
                    } catch (Exception ex) {
                        error = true;
                        System.out.println(ex.getMessage());
                    }
                    if (error) {
                        res.sendRedirect(req.getContextPath() + "/");
                    }
                    
                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/group/show.jsp");
                    dispatcher.forward(req, res);
                    break;
                    
                case "/group/new":
                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/group/new.jsp");
                    dispatcher.forward(req, res);
                    break;
                    
                case "/group/edit":
                    group = new Group();
                    user = new User();
                    
                    group.find(req.getParameter("id"));
                    if (group.getUser_id() != (int) req.getSession().getAttribute("user_id")) {
                        res.sendRedirect(req.getContextPath() + "/");
                        return;
                    }
                    req.setAttribute("group_info", group);
                    
                    List<User> users = new ArrayList<User>();
                    user.where("id NOT IN (SELECT user_id FROM group_members WHERE "
                            + "group_id = " + group.getId() + ")  AND id != " + group.getUser_id() + "")
                            .transfer(users);
                    
                    req.setAttribute("userList", users);
                    
                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/group/edit.jsp");
                    dispatcher.forward(req, res);
                    break;
                    
                case "/group/add":
                    group = new Group();
                    group.find(Integer.parseInt(req.getParameter("id")));
                    if (group.getUser_id() == (int) req.getSession().getAttribute("user_id")) {
                        try {
                            group.add(Integer.parseInt(req.getParameter("user_id")));
                            res.setStatus(200);
                        } catch (Exception ex) {
                            System.out.println(ex.getMessage());
                            res.setStatus(500);
                        }
                        
                    } else {
                        res.setStatus(500);
                    }
                    break;
                    
                case "/group/remove":
                    group = new Group();
                    group.find(Integer.parseInt(req.getParameter("id")));
                    if (group.getUser_id() == (int) req.getSession().getAttribute("user_id")) {
                        try {
                            group.remove(Integer.parseInt(req.getParameter("user_id")));
                            res.setStatus(200);
                        } catch (Exception ex) {
                            System.out.println(ex.getMessage());
                            res.setStatus(500);
                        }
                        
                    } else {
                        res.setStatus(500);
                    }
                    break;
                
                case "/group/destroy":
                    group = new Group();
                    group.find(Integer.parseInt(req.getParameter("id")));
                    if (group.destroy()) {
                        res.setStatus(200);
                    } else {
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
        Group group;
        
        try {
            switch (req.getServletPath()) {
                case "/group/create":
                    group = new Group();
                    group.setName(req.getParameter("name"));
                    group.setUser_id((int) req.getSession().getAttribute("user_id"));

                    try {
                        group.save();
                        req.setAttribute("createResult", true);
                        
                        req.setAttribute("groupList", (new Group()).groupsFrom((int) req.getSession().getAttribute("user_id")));
                    } catch (Exception ex) {
                        req.setAttribute("createResult", false);
                        System.out.println(ex.getMessage());
                    }

                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/group/index.jsp");
                    dispatcher.forward(req, res);
                    break;
                    
                case "/group/update":
                    group = new Group();
                    group.find(req.getParameter("group_id"));
                    if (group.getUser_id() != (int) req.getSession().getAttribute("user_id")) {
                        res.sendRedirect(req.getContextPath() + "/");
                    }
                    
                    group.setName(req.getParameter("name"));
                    try {
                        group.save();
                        req.setAttribute("updateResult", true);
                    } catch (Exception ex) {
                        req.setAttribute("updateResult", false);
                        System.out.println(ex.getMessage());
                    }
                    
                    req.setAttribute("group_info", group);
                    
                    req.setAttribute("current_page", current_page);
                    dispatcher = req.getRequestDispatcher("/views/group/edit.jsp");
                    dispatcher.forward(req, res);
                    break;
            }
        } catch (Exception ex) {
            System.out.println(ex.getClass());
        }
    }
}
