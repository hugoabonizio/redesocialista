
package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.Stats;
import models.User;

@WebServlet(urlPatterns = {
    "/stats",
    "/stats/top20users",
    "/stats/top20messages"
})
public class StatsController extends HttpServlet {

    int current_page = 5;
    
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        
        // Verifica se tá logado
        if (req.getSession().getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        
        RequestDispatcher dispatcher;
        User user;
        
        switch (req.getServletPath()) {
            case "/stats":
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/stats/index.jsp");
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
        Stats s;
        
        switch (req.getServletPath()) {
            case "/stats/top20users":
                s = new Stats();
                try {
                    req.setAttribute("users", s.getTop20Users(req.getParameter("from"), req.getParameter("to")));
                } catch (SQLException ex) {
                    Logger.getLogger(StatsController.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/stats/top20users.jsp");
                dispatcher.forward(req, res);
                break;
                
            case "/stats/top20messages":
                s = new Stats();
                try {
                    req.setAttribute("messages", s.getTop20Messages(req.getParameter("from"), req.getParameter("to")));
                } catch (SQLException ex) {
                    Logger.getLogger(StatsController.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                req.setAttribute("current_page", current_page);
                dispatcher = req.getRequestDispatcher("/views/stats/top20messages.jsp");
                dispatcher.forward(req, res);
                break;
        }
    }
}
