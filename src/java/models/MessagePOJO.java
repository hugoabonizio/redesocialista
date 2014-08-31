package models;

public class MessagePOJO {
    private Message message;
    private boolean opinion;
    private int likes;
    
    public MessagePOJO(Message message, int likes) {
        this.message = message;
        this.likes = likes;
    }

    public Message getMessage() {
        return message;
    }
    public void setMessage(Message message) {
        this.message = message;
    }

    public boolean getOpinion() {
        return opinion;
    }
    public void setOpinion(boolean opinion) {
        this.opinion = opinion;
    }

    public int getLikes() {
        return likes;
    }
    public void setLikes(int likes) {
        this.likes = likes;
    }
}
