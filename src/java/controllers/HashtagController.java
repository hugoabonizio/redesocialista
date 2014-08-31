package controllers;

import java.io.IOException;
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
import models.Message;
import models.MessagePOJO;
import models.User;

@WebServlet(urlPatterns = {
    "/hashtag"
})
public class HashtagController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        
        // Verifica se tá logado
        if (req.getSession().getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        
        RequestDispatcher dispatcher;
        User user;
        
        switch (req.getServletPath()) {
            case "/hashtag":
                String term = req.getParameter("tag");
                Message message = new Message();
                List<MessagePOJO> messages = null;
                try {
                    messages = message.getMessagesHashtag(term);
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                }
                req.setAttribute("messageList", messages);
                
                dispatcher = req.getRequestDispatcher("/views/hashtag/index.jsp");
                dispatcher.forward(req, res);
                break;
        }
    }
}
