
package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.User;

@WebServlet(urlPatterns = {
    "/stats"
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
}
