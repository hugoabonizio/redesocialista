package controllers;

import java.io.IOException;
import java.io.PrintWriter;
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
import models.Group;
import models.User;

@WebServlet(urlPatterns = {
    "/find"
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
        }
    }
}
